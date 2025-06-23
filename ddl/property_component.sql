-- --------------------------------------------------
-- Lookup Tables
-- --------------------------------------------------
CREATE TABLE energy_efficiency_band_code (
  band_id INTEGER PRIMARY KEY,
  code CHAR(1) NOT NULL UNIQUE
);

INSERT INTO energy_efficiency_band_code (band_id, code)
VALUES 
  (1, 'A'),
  (2, 'B'),
  (3, 'C'),
  (4, 'D'),
  (5, 'E'),
  (6, 'F'),
  (7, 'G');

CREATE TABLE location_alert_type_code (
  alert_type_id INTEGER PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO location_alert_type_code (alert_type_id, code, display_name)
VALUES
  (1, 'OtherContactDetails'),
  (2, 'OtherSeeComments'),
  (3, 'Asbestos'),
  (4, 'Warranty'),
  (5, 'HeritageListedBuilding'),
  (6, 'SewageNotToMains'),
  (7, 'Operative Gender'),
  (8, 'DampAndMould**');

CREATE TABLE glazing_layer_type_code (
  glazing_type_id INTEGER PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO glazing_layer_type_code (glazing_type_id, code)
VALUES 
  (1, 'None'),
  (2, 'Single'),
  (3, 'Secondary'),
  (4, 'Double'),
  (5, 'Triple');

INSERT INTO glazing_layer_type_code (glazing_type_id, code) 
VALUES
  (1, 'Other'),
  (2, 'Single'), 
  (3, 'Secondary'),
  (4, 'Double'),
  (5, 'Triple');

CREATE TABLE roof_insulation_type_code (
  insulation_type_id INTEGER PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO roof_insulation_type_code (insulation_type_id, code)
VALUES 
  (1, 'None'),
  (2, 'Partial'),
  (3, 'Full'),
  (4, 'Board'),
  (5, 'Roll'),
  (6, 'LooseFill'),
  (7, 'SprayFoam');

CREATE TABLE wall_insulation_type_code (
  insulation_type_id INTEGER PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO wall_insulation_type_code (insulation_type_id, code) 
VALUES
  (1, 'None'),
  (2, 'Cavity'),
  (3, 'External'),
  (4, 'Internal'),
  (5, 'Partial'),
  (6, 'Full'),
  (7, 'Board'),
  (8, 'Roll'),
  (9, 'LooseFill'),
  (10, 'SprayFoam');

CREATE TABLE construction_type_code (
  construction_type_id INTEGER PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO construction_type_code (construction_type_id, code) 
VALUES
  (1, 'SolidWall'),
  (2, 'CavityWall'),
  (3, 'TimberFrame'),
  (4, 'SteelFrame'),
  (5, 'ConcreteFrame'),
  (6, 'CompositeWall'),
  (7, 'Prefabricated'),
  (8, 'InsulatedPanel'),
  (9, 'Stone'),
  (10, 'Blockwork');

CREATE TABLE certification_type_code (
  certification_type_id INTEGER PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO certification_type_code (certification_type_id, code) 
VALUES
  (1, 'EICR'),    -- Electrical Installation Condition Report
  (2, 'EIC'),     -- Electrical Installation Certificate
  (3, 'LGSR'),    -- Landlord Gas Safety Record
  (4, 'FRA'),     -- Fire Risk Assessment
  (5, 'PAT'),     -- Portable Appliance Test
  (6, 'CPC'),     -- Combustion Performance Certificate
  (7, 'EPC');     -- Energy Performance Certificate (if needed)

-- --------------------------------------------------
-- Core Tables
-- --------------------------------------------------

CREATE TABLE site (
  site_id INTEGER PRIMARY KEY,
  site_name VARCHAR(255) NOT NULL
);

CREATE TABLE property (
  property_id INTEGER PRIMARY KEY,
  property_name VARCHAR(255) NOT NULL,
  site_id INTEGER NOT NULL,
  CONSTRAINT fk_property_site FOREIGN KEY (site_id) 
    REFERENCES site(site_id)
);

CREATE TABLE unit (
  unit_id INTEGER PRIMARY KEY,
  property_id INTEGER NOT NULL,
  alert_type_id INTEGER,
  lease VARCHAR(255),
  CONSTRAINT fk_unit_property FOREIGN KEY (property_id) 
    REFERENCES property(property_id),
  CONSTRAINT fk_unit_alert_type FOREIGN KEY (alert_type_id)
    REFERENCES location_alert_type_code(alert_type_id)
);

CREATE TABLE address (
  address_id INTEGER PRIMARY KEY,
  unit_id INTEGER NOT NULL,
  address_line VARCHAR(255),
  building_name VARCHAR(255),
  street_name VARCHAR(255),
  building_number VARCHAR(50),
  floor INTEGER,
  city_name VARCHAR(100) NOT NULL,
  country VARCHAR(100) NOT NULL,
  post_code VARCHAR(20) NOT NULL,
  CONSTRAINT fk_address_unit FOREIGN KEY (unit_id) 
    REFERENCES unit(unit_id)
);

CREATE TABLE physical_characteristics (
  physical_char_id INTEGER PRIMARY KEY,
  property_id INTEGER NOT NULL,
  window_glazing_type_id INTEGER,
  wall_insulation_type_id INTEGER,
  roof_insulation_type_id INTEGER,
  ventilation_type VARCHAR(100),
  built_year INTEGER,
  construction_type_id INTEGER,
  last_updated_date DATE NOT NULL,
  CONSTRAINT fk_phys_property FOREIGN KEY (property_id) 
    REFERENCES property(property_id),
  CONSTRAINT fk_glazing_type FOREIGN KEY (window_glazing_type_id) 
    REFERENCES glazing_layer_type_code(glazing_type_id),
  CONSTRAINT fk_wall_insulation FOREIGN KEY (wall_insulation_type_id) 
    REFERENCES wall_insulation_type_code(insulation_type_id),
  CONSTRAINT fk_roof_insulation FOREIGN KEY (roof_insulation_type_id) 
    REFERENCES roof_insulation_type_code(insulation_type_id),
  CONSTRAINT fk_construction_type FOREIGN KEY (construction_type_id) 
    REFERENCES construction_type_code(construction_type_id)
);

CREATE TABLE heating_system (
  heating_system_id INTEGER PRIMARY KEY,
  property_id INTEGER NOT NULL,
  energy_control VARCHAR(100),
  heat_conversion_method VARCHAR(100),
  purpose VARCHAR(100),
  is_smart_system BOOLEAN DEFAULT FALSE,
  installation_date DATE,
  manufacturer VARCHAR(255),
  model_number VARCHAR(100),
  last_serviced_date DATE,
  notes TEXT,
  CONSTRAINT fk_heating_property FOREIGN KEY (property_id) 
    REFERENCES property(property_id)
);

CREATE TABLE thermal_transmittance (
  thermal_trans_id INTEGER PRIMARY KEY,
  physical_char_id INTEGER NOT NULL,
  u_value NUMERIC(5,3) NOT NULL,
  element VARCHAR(100) NOT NULL,
  measurement_date DATE NOT NULL,
  notes TEXT,
  CONSTRAINT fk_thermal_phys FOREIGN KEY (physical_char_id) 
    REFERENCES physical_characteristics(physical_char_id)
);

CREATE TABLE energy_performance_certification (
  epc_id INTEGER PRIMARY KEY,
  unit_id INTEGER NOT NULL,
  certificate_number VARCHAR(50) NOT NULL UNIQUE,
  current_energy_rating INTEGER NOT NULL,
  current_energy_band CHAR(1) NOT NULL,
  potential_energy_rating INTEGER NOT NULL,
  potential_energy_band CHAR(1) NOT NULL,
  current_env_impact_rating INTEGER NOT NULL,
  current_env_impact_band CHAR(1) NOT NULL,
  potential_env_impact_rating INTEGER NOT NULL,
  potential_env_impact_band CHAR(1) NOT NULL,
  co2_per_year INTEGER NOT NULL,
  space_heating_cost_year NUMERIC(10,2) NOT NULL,
  water_heating_cost_year NUMERIC(10,2) NOT NULL,
  lighting_cost_year NUMERIC(10,2) NOT NULL,
  total_energy_cost_year NUMERIC(12,2) NOT NULL,
  energy_use_per_sqm_year INTEGER NOT NULL,
  recommendation_summary TEXT,
  CONSTRAINT fk_epc_unit FOREIGN KEY (unit_id) 
    REFERENCES unit(unit_id),
  CONSTRAINT fk_current_energy_band FOREIGN KEY (current_energy_band) 
    REFERENCES energy_efficiency_band_code(band_id),
  CONSTRAINT fk_potential_energy_band FOREIGN KEY (potential_energy_band) 
    REFERENCES energy_efficiency_band_code(band_id),
  CONSTRAINT fk_current_env_band FOREIGN KEY (current_env_impact_band) 
    REFERENCES energy_efficiency_band_code(band_id),
  CONSTRAINT fk_potential_env_band FOREIGN KEY (potential_env_impact_band) 
    REFERENCES energy_efficiency_band_code(band_id),
  CONSTRAINT chk_ratings CHECK (
    current_energy_rating BETWEEN 0 AND 100 AND
    potential_energy_rating BETWEEN 0 AND 100 AND
    current_env_impact_rating BETWEEN 0 AND 100 AND
    potential_env_impact_rating BETWEEN 0 AND 100
  )
);

CREATE TABLE certification (
  certification_id INTEGER PRIMARY KEY,
  unit_id INTEGER NOT NULL,
  certification_type_id INTEGER NOT NULL,
  issue_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  issued_by VARCHAR(255) NOT NULL,
  status VARCHAR(50) NOT NULL,
  attachment_url VARCHAR(2048),
  CONSTRAINT fk_cert_unit FOREIGN KEY (unit_id) 
    REFERENCES unit(unit_id),
  CONSTRAINT fk_cert_type FOREIGN KEY (certification_type_id) 
    REFERENCES certification_type_code(certification_type_id),
  CONSTRAINT chk_date_validity CHECK (expiry_date > issue_date)
);
