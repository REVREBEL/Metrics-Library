
-- clean_crm_schema_v2.sql
-- Portable PostgreSQL schema (no prefixes). Includes recommendations + new fields.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;

BEGIN;

-- Enums
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'charge_by') THEN
    CREATE TYPE charge_by AS ENUM ('per_day','per_month','per_hour','flat_fee');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'visibility') THEN
    CREATE TYPE visibility AS ENUM ('public','internal','private');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'recurring_type') THEN
    CREATE TYPE recurring_type AS ENUM ('none','weekly','monthly','quarterly','yearly','custom');
  END IF;
END $$;

-- Companies
CREATE TABLE IF NOT EXISTS companies (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id           UUID REFERENCES companies(id) ON DELETE SET NULL,
  relationship        TEXT,
  name                TEXT NOT NULL,
  industry            TEXT,
  account_type        TEXT,
  ownership           TEXT,
  management_company  TEXT,
  chain               TEXT,
  brand               TEXT,
  domain              TEXT,
  website             TEXT,
  phone               TEXT,
  email_opt_out       BOOLEAN,
  logo_square         TEXT,
  logo_vertical       TEXT,
  notes               TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_companies_name ON companies (lower(name));
CREATE INDEX IF NOT EXISTS idx_companies_parent ON companies (parent_id);

-- Account addresses
CREATE TABLE IF NOT EXISTS account_addresses (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id     UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  bill_street    TEXT,
  bill_city      TEXT,
  bill_state     TEXT,
  bill_code      TEXT,
  bill_country   TEXT,
  is_primary     BOOLEAN DEFAULT TRUE,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_account_addresses_company ON account_addresses(company_id);

-- Clients
CREATE TABLE IF NOT EXISTS clients (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id      UUID REFERENCES companies(id) ON DELETE SET NULL,
  name            TEXT NOT NULL,
  email           CITEXT,
  phone           TEXT,
  website         TEXT,
  notes           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (email)
);
CREATE INDEX IF NOT EXISTS idx_clients_company ON clients(company_id);

CREATE TABLE IF NOT EXISTS client_access (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id       UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  access_level    TEXT NOT NULL,
  active          BOOLEAN NOT NULL DEFAULT TRUE,
  start_date      DATE,
  end_date        DATE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_client_access_client ON client_access(client_id);

-- Contacts
CREATE TABLE IF NOT EXISTS contacts (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id                  UUID REFERENCES companies(id) ON DELETE SET NULL,
  client_id                   UUID REFERENCES clients(id) ON DELETE SET NULL,
  first_name                  TEXT,
  last_name                   TEXT,
  email                       CITEXT UNIQUE,
  phone                       TEXT,
  title                       TEXT,
  department                  TEXT,
  is_active                   BOOLEAN DEFAULT TRUE,
  do_not_call                 BOOLEAN,
  email_opt_out               BOOLEAN,
  profile_image               TEXT,
  birthday                    DATE,
  last_login_time             TIMESTAMPTZ,
  last_stay_intouch_request   TIMESTAMPTZ,
  last_stay_intouch_save_date TIMESTAMPTZ,
  notes                       TEXT,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_contacts_company ON contacts(company_id);
CREATE INDEX IF NOT EXISTS idx_contacts_client  ON contacts(client_id);

-- Files
CREATE TABLE IF NOT EXISTS files (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  folder_id           UUID,
  owner_company_id    UUID REFERENCES companies(id) ON DELETE SET NULL,
  owner_client_id     UUID REFERENCES clients(id) ON DELETE SET NULL,
  owner_contact_id    UUID REFERENCES contacts(id) ON DELETE SET NULL,
  owner_project_id    UUID,
  file_name           TEXT NOT NULL,
  file_type           TEXT,
  file_location_type  TEXT,
  file_url            TEXT,
  note_content        TEXT,
  private             BOOLEAN DEFAULT FALSE,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Leads
CREATE TABLE IF NOT EXISTS leads (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id      UUID REFERENCES companies(id) ON DELETE SET NULL,
  contact_id      UUID REFERENCES contacts(id) ON DELETE SET NULL,
  campaign_id     UUID,
  website         TEXT,
  priority        TEXT,
  converted       BOOLEAN DEFAULT FALSE,
  rating          TEXT,
  lead_source     TEXT,
  lead_status     TEXT,
  notes           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_leads_company ON leads(company_id);
CREATE INDEX IF NOT EXISTS idx_leads_contact ON leads(contact_id);

-- Campaigns
CREATE TABLE IF NOT EXISTS campaigns (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_no       TEXT,
  campaign_name     TEXT NOT NULL,
  campaign_type     TEXT,
  expected_revenue  NUMERIC,
  budget_cost       NUMERIC,
  actual_cost       NUMERIC,
  target_audience   TEXT,
  target_size       INTEGER,
  start_date        DATE,
  end_date          DATE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
ALTER TABLE leads
  ADD CONSTRAINT IF NOT EXISTS fk_leads_campaign
  FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE SET NULL;

-- Deals
CREATE TABLE IF NOT EXISTS deals (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id          UUID REFERENCES companies(id) ON DELETE SET NULL,
  client_id           UUID REFERENCES clients(id) ON DELETE SET NULL,
  contact_id          UUID REFERENCES contacts(id) ON DELETE SET NULL,
  name                TEXT NOT NULL,
  stage               TEXT,
  amount              NUMERIC,
  currency            TEXT,
  probability         NUMERIC,
  closing_date        DATE,
  next_step           TEXT,
  revenue_type        TEXT,
  campaign_id         UUID REFERENCES campaigns(id) ON DELETE SET NULL,
  follow_update       TIMESTAMPTZ,
  forecast_category   TEXT,
  expected_revenue    NUMERIC,
  last_modified       TIMESTAMPTZ,
  private             BOOLEAN DEFAULT FALSE,
  description         TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_deals_company ON deals(company_id);
CREATE INDEX IF NOT EXISTS idx_deals_client  ON deals(client_id);
CREATE INDEX IF NOT EXISTS idx_deals_contact ON deals(contact_id);
CREATE INDEX IF NOT EXISTS idx_deals_stage   ON deals(stage);
CREATE INDEX IF NOT EXISTS idx_deals_closing ON deals(closing_date);

-- Projects / milestones / tasks
CREATE TABLE IF NOT EXISTS projects (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id       UUID REFERENCES companies(id) ON DELETE SET NULL,
  client_id        UUID REFERENCES clients(id) ON DELETE SET NULL,
  name             TEXT NOT NULL,
  status           TEXT,
  start_date       DATE,
  end_date         DATE,
  budget_amount    NUMERIC,
  description      TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_projects_company ON projects(company_id);
CREATE INDEX IF NOT EXISTS idx_projects_client  ON projects(client_id);
ALTER TABLE files
  ADD CONSTRAINT IF NOT EXISTS fk_files_project
  FOREIGN KEY (owner_project_id) REFERENCES projects(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS milestones (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id       UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name             TEXT NOT NULL,
  due_date         DATE,
  status           TEXT,
  notes            TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (project_id, name)
);
CREATE INDEX IF NOT EXISTS idx_milestones_project ON milestones(project_id);

CREATE TABLE IF NOT EXISTS tasks (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id       UUID REFERENCES projects(id) ON DELETE SET NULL,
  assigned_to_id   UUID REFERENCES contacts(id) ON DELETE SET NULL,
  name             TEXT NOT NULL,
  status           TEXT,
  priority         TEXT,
  due_date         DATE,
  description      TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_tasks_project  ON tasks(project_id);
CREATE INDEX IF NOT EXISTS idx_tasks_assignee ON tasks(assigned_to_id);
CREATE INDEX IF NOT EXISTS idx_tasks_due      ON tasks(due_date);

CREATE TABLE IF NOT EXISTS project_contacts (
  project_id       UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  contact_id       UUID NOT NULL REFERENCES contacts(id) ON DELETE CASCADE,
  role             TEXT,
  PRIMARY KEY (project_id, contact_id)
);

-- Proposals + versions
CREATE TABLE IF NOT EXISTS proposals (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  deal_id         UUID REFERENCES deals(id) ON DELETE SET NULL,
  contact_id      UUID REFERENCES contacts(id) ON DELETE SET NULL,
  title           TEXT,
  status          TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_proposals_deal ON proposals(deal_id);

CREATE TABLE IF NOT EXISTS proposal_versions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id     UUID NOT NULL REFERENCES proposals(id) ON DELETE CASCADE,
  version_id      TEXT NOT NULL,
  update_log      TEXT,
  pdf_url         TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (proposal_id, version_id)
);

-- Activities
CREATE TABLE IF NOT EXISTS activities (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  activity_type               TEXT,
  activity_subject            TEXT,
  activity_due_date           DATE,
  activity_time_start         TIMESTAMPTZ,
  activity_time_end           TIMESTAMPTZ,
  activity_send_notification  BOOLEAN,
  activity_duration_hours     INTEGER,
  activity_duration_minutes   INTEGER,
  activity_status             TEXT,
  activity_event_status       TEXT,
  activity_priority           TEXT,
  activity_location           TEXT,
  activity_visibility         visibility DEFAULT 'internal',
  activity_recurring_type     recurring_type DEFAULT 'none',
  activity_attachments_id     UUID,
  activity_notes              TEXT,
  company_id                  UUID REFERENCES companies(id) ON DELETE SET NULL,
  contact_id                  UUID REFERENCES contacts(id) ON DELETE SET NULL,
  deal_id                     UUID REFERENCES deals(id) ON DELETE SET NULL,
  project_id                  UUID REFERENCES projects(id) ON DELETE SET NULL,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_activities_company ON activities(company_id);
CREATE INDEX IF NOT EXISTS idx_activities_contact ON activities(contact_id);
CREATE INDEX IF NOT EXISTS idx_activities_due     ON activities(activity_due_date);

-- Catalog: solutions/services + items
CREATE TABLE IF NOT EXISTS solutions (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sort                        INTEGER,
  solution_visibility         visibility DEFAULT 'public',
  solution_image              TEXT,
  solution_internal_name      TEXT,
  solution_name               TEXT NOT NULL,
  solution_short_description  TEXT,
  solution_long_description   TEXT,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS solution_items (
  id                            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  solution_id                   UUID NOT NULL REFERENCES solutions(id) ON DELETE CASCADE,
  solution_item_visibility      visibility DEFAULT 'public',
  solution_item_color           TEXT,
  solution_item                 TEXT NOT NULL,
  solution_item_short_description TEXT,
  solution_item_long_description  TEXT,
  solution_item_currency        TEXT,
  solution_item_amount          NUMERIC,
  solution_item_charge_by       charge_by DEFAULT 'flat_fee',
  solution_item_start_date      DATE,
  solution_item_end_date        DATE,
  solution_item_quantity        NUMERIC,
  solution_item_recurring_type  recurring_type DEFAULT 'none',
  sort                          INTEGER,
  created_at                    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_solution_items_solution ON solution_items(solution_id);

CREATE TABLE IF NOT EXISTS services (
  id                        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sort                      INTEGER,
  visibility_service        visibility DEFAULT 'public',
  service_image             TEXT,
  service_internal_name     TEXT,
  service_name              TEXT NOT NULL,
  service_short_description TEXT,
  service_long_description  TEXT,
  created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS service_items (
  id                            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_id                    UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  visibility_service_item       visibility DEFAULT 'public',
  service_item_color            TEXT,
  service_item                  TEXT NOT NULL,
  service_item_short_description TEXT,
  service_item_long_description  TEXT,
  service_item_currency         TEXT,
  service_item_amount           NUMERIC,
  service_item_charge_by        charge_by DEFAULT 'flat_fee',
  service_item_start_date       DATE,
  service_item_end_date         DATE,
  service_item_quantity         NUMERIC,
  service_item_recurring_type   recurring_type DEFAULT 'none',
  sort                          INTEGER,
  created_at                    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_service_items_service ON service_items(service_id);

COMMIT;
