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

print("## Summary Report")
total_tables = 0
examples = []

for root, _, files in os.walk(SOURCE_DIR):
    if os.path.basename(root) in EXCLUDED: continue
    for file in [f for f in files if f.endswith(".sql")]:
        with open(os.path.join(root, file), 'r') as f: content = f.read()
        matches = re.findall(r'^\s+([a-zA-Z0-9_]+)\s+([a-zA-Z0-9()]+)', content, re.M)
        if not matches: continue
        
        renamed_count = 0
        new_tbl = standardize(file.replace(".sql", ""))
        for n, t in matches:
            std_n = standardize(n)
            if n != std_n:
                renamed_count += 1
                if len(examples) < 3:
                    examples.append((file.replace('.sql', ''), n, std_n))
        
        print(f"- **{new_tbl}** (Original: {file.replace('.sql', '')}): {renamed_count} columns renamed.")
        total_tables += 1

print(f"\nTotal tables processed: {total_tables}")
print("\n### Transformation Examples:")
for tbl, old, new in examples:
    print(f"- In table **{tbl}**: `{old}` ➡️ `{new}`")
