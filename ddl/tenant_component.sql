-- tenant person Table
CREATE TABLE tenant_person (
  tenant_id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name VARCHAR(255) NOT NULL,
  person_alert_type_id INTEGER,
  date_of_birth DATE,
  phone_number INTEGER,
  email INTEGER
  vulnerability_flag BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_tenant_person_alert_type FOREIGN KEY (person_alert_type_id) REFERENCES person_alert_type(person_alert_type_id),
  CONSTRAINT chk_vulnerability_flag CHECK (vulnerability_flag IN (0, 1))
);

-- tenancy Table
CREATE TABLE tenancy (
  tenancy_id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant_id INTEGER NOT NULL,
  address_id INTEGER NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  tenancy_type VARCHAR(100),
  tenancy_status VARCHAR(100),
  CONSTRAINT fk_tenancy_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id)
);

-- household member person Table
CREATE TABLE household_member_person (
  household_member_id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant_id INTEGER NOT NULL,
  tenancy_id INTEGER NOT NULL,
  person_alert_type_id INTEGER,
  full_name VARCHAR(255) NOT NULL,
  date_of_birth DATE,
  relationship_to_tenant VARCHAR(100),
  is_contract_holder BOOLEAN DEFAULT FALSE,
  vulnerability_details TEXT,
  risk_assessment_status VARCHAR(100),
  risk_assessment_date DATE,
  CONSTRAINT fk_household_member_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id),
  CONSTRAINT fk_household_member_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_household_member_person_alert_type FOREIGN KEY (person_alert_type_id) REFERENCES person_alert_type(person_alert_type_id)
);
