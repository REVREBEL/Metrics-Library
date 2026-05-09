import os, re

SOURCE_DIR, OUTPUT_DIR = "./schemas", "./production_migration_templates"
EXCLUDED = ["dev_hotel_g4a", "dev_hotel_g4a_events", "dev_hotel_sales"]
REPLACEMENTS = {
    r'(?<![a-zA-Z0-9])rooms(?![a-zA-Z0-9])': 'rms',
    r'(?<![a-zA-Z0-9])available_rooms(?![a-zA-Z0-9])': 'available_rms',
    r'(?<![a-zA-Z0-9])revenue(?![a-zA-Z0-9])': 'rev',
    r'(?<![a-zA-Z0-9])occupancy(?![a-zA-Z0-9])': 'occ',
    r'(?<![a-zA-Z0-9])budget(?![a-zA-Z0-9])': 'bgt',
    r'(?<![a-zA-Z0-9])forecast(?![a-zA-Z0-9])': 'fct',
    r'(?<![a-zA-Z0-9])actual(?![a-zA-Z0-9])': 'act',
    r'(?<![a-zA-Z0-9])prior_year(?![a-zA-Z0-9])': 'ly',
    r'(?<![a-zA-Z0-9])py(?![a-zA-Z0-9])': 'ly',
    r'(?<![a-zA-Z0-9])compset_': 'cs_',
    r'(?<![a-zA-Z0-9])compset(?![a-zA-Z0-9])': 'cs',
    r'_ly_actual(?![a-zA-Z0-9])': '_ly',
    r'_py(?![a-zA-Z0-9])': '_ly',
    r'(?<![a-zA-Z0-9])day(?![a-zA-Z0-9])': 'date',
    r'(?<![a-zA-Z0-9])reservation_number(?![a-zA-Z0-9])': 'source_id',
    r'(?<![a-zA-Z0-9])confirmation_number(?![a-zA-Z0-9])': 'source_id'
}

def standardize(name):
    for p, r in REPLACEMENTS.items(): name = re.sub(p, r, name, flags=re.I)
    name = re.sub(r'_(\d{1,2})$', lambda m: f"_{int(m.group(1)):03d}", name)
    return name.lower().replace("__", "_").strip("_")

def run():
    if not os.path.exists(OUTPUT_DIR): os.makedirs(OUTPUT_DIR)
    for root, _, files in os.walk(SOURCE_DIR):
        if os.path.basename(root) in EXCLUDED: continue
        for file in [f for f in files if f.endswith(".sql")]:
            with open(os.path.join(root, file), 'r') as f: content = f.read()
            matches = re.findall(r'^\s+([a-zA-Z0-9_]+)\s+([a-zA-Z0-9()]+)', content, re.M)
            if not matches: continue
            new_tbl = standardize(file.replace(".sql", ""))
            cols = ",\n".join([f"    {standardize(n)} {t} OPTIONS(description='Standardized {standardize(n)}.')" for n, t in matches])
            with open(os.path.join(OUTPUT_DIR, f"{new_tbl}.sql"), 'w') as f:
                f.write(f"DECLARE project_id STRING DEFAULT 'your-production-project';\nDECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';\nDECLARE table_name STRING DEFAULT '{new_tbl}';\n\nEXECUTE IMMEDIATE FORMAT(\"\"\"\n  CREATE OR REPLACE TABLE `%s.%s.%s` (\n{cols}\n  )\n\"\"\", project_id, dataset_name, table_name);")
    print("Migration Complete.")

if __name__ == '__main__': run()