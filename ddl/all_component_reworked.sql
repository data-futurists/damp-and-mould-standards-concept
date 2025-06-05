-- Author(s): George Foster (TPXImpact), Rizwan Nobeebux (Data Futurists), Elena Iurco (Data Futurists)
-- Email(s): george.foster@tpximpact.com, rizwan.nobeebux@datafuturists.com, elena.iurco@datafuturists.com
--
-- SQLite Schema: Inspection, Property, Tenant, and Work Order Modules
-- Following best practices with consistent snake_case naming, ordered dependencies, and clear comments

-- ============================================
-- SECTION 1: CODE LISTS (Reference Tables)
-- ============================================

CREATE TABLE health_risk_rating (
  health_risk_rating_id INTEGER PRIMARY KEY AUTOINCREMENT,
  rating NVARCHAR(20) NOT NULL
);

CREATE TABLE severity (
  severity_id INTEGER PRIMARY KEY AUTOINCREMENT,
  level NVARCHAR(20) NOT NULL
);

CREATE TABLE investigation_type (
  investigation_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  type NVARCHAR(20) NOT NULL
);

CREATE TABLE report_status (
  report_status_id INTEGER PRIMARY KEY AUTOINCREMENT,
  status NVARCHAR(20) NOT NULL
);

CREATE TABLE trigger_source (
  trigger_source_id INTEGER PRIMARY KEY AUTOINCREMENT,
  source NVARCHAR(20) NOT NULL
);

CREATE TABLE escalation_status (
  escalation_status_id INTEGER PRIMARY KEY AUTOINCREMENT,
  status NVARCHAR(20) NOT NULL
);

CREATE TABLE escalation_stage (
  escalation_stage_id INTEGER PRIMARY KEY AUTOINCREMENT,
  stage NVARCHAR(20) NOT NULL
);

CREATE TABLE escalation_type (
  escalation_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  type NVARCHAR(30) NOT NULL
);

CREATE TABLE notification_type (
  notification_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  type NVARCHAR(20) NOT NULL
);

CREATE TABLE notification_method (
  notification_method_id INTEGER PRIMARY KEY AUTOINCREMENT,
  method NVARCHAR(20) NOT NULL
);

CREATE TABLE energy_efficiency_band (
  band_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code CHAR(1) NOT NULL UNIQUE
);

CREATE TABLE location_alert_type (
  alert_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE glazing_type (
  glazing_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE roof_insulation_type (
  insulation_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE wall_insulation_type (
  insulation_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE construction_type (
  construction_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE certification_type (
  certification_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);

-- ============================================
-- SECTION 2: CORE AND MODULE TABLES
-- ============================================

-- --------------------------------------------------
-- Property Module Tables
-- --------------------------------------------------

CREATE TABLE site (
  site_id INTEGER PRIMARY KEY,
  site_name VARCHAR(255) NOT NULL
);

CREATE TABLE property (
  property_id INTEGER PRIMARY KEY,
  property_name VARCHAR(255) NOT NULL,
  site_id INTEGER NOT NULL,
  CONSTRAINT fk_property_site FOREIGN KEY (site_id) REFERENCES site(site_id)
);

CREATE TABLE "unit" (
  unit_id INTEGER PRIMARY KEY,
  property_id INTEGER NOT NULL,
  alert_type_id INTEGER,
  lease VARCHAR(255),
  CONSTRAINT fk_unit_property FOREIGN KEY (property_id) REFERENCES property(property_id),
  CONSTRAINT fk_unit_alert_type FOREIGN KEY (alert_type_id) REFERENCES location_alert_type(alert_type_id)
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
  CONSTRAINT fk_address_unit FOREIGN KEY (unit_id) REFERENCES "unit"(unit_id)
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
  CONSTRAINT fk_phys_property FOREIGN KEY (property_id) REFERENCES property(property_id),
  CONSTRAINT fk_glazing_type FOREIGN KEY (window_glazing_type_id) REFERENCES glazing_type(glazing_type_id),
  CONSTRAINT fk_wall_insulation FOREIGN KEY (wall_insulation_type_id) REFERENCES wall_insulation_type(insulation_type_id),
  CONSTRAINT fk_roof_insulation FOREIGN KEY (roof_insulation_type_id) REFERENCES roof_insulation_type(insulation_type_id),
  CONSTRAINT fk_construction_type FOREIGN KEY (construction_type_id) REFERENCES construction_type(construction_type_id)
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
  CONSTRAINT fk_heating_property FOREIGN KEY (property_id) REFERENCES property(property_id)
);

CREATE TABLE thermal_transmittance (
  thermal_trans_id INTEGER PRIMARY KEY,
  physical_char_id INTEGER NOT NULL,
  u_value NUMERIC(5,3) NOT NULL,
  element VARCHAR(100) NOT NULL,
  measurement_date DATE NOT NULL,
  notes TEXT,
  CONSTRAINT fk_thermal_phys FOREIGN KEY (physical_char_id) REFERENCES physical_characteristics(physical_char_id)
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
  CONSTRAINT fk_epc_unit FOREIGN KEY (unit_id) REFERENCES "unit"(unit_id),
  CONSTRAINT fk_current_energy_band FOREIGN KEY (current_energy_band) REFERENCES energy_efficiency_band(band_id),
  CONSTRAINT fk_potential_energy_band FOREIGN KEY (potential_energy_band) REFERENCES energy_efficiency_band(band_id),
  CONSTRAINT fk_current_env_band FOREIGN KEY (current_env_impact_band) REFERENCES energy_efficiency_band(band_id),
  CONSTRAINT fk_potential_env_band FOREIGN KEY (potential_env_impact_band) REFERENCES energy_efficiency_band(band_id),
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
  CONSTRAINT fk_cert_unit FOREIGN KEY (unit_id) REFERENCES "unit"(unit_id),
  CONSTRAINT fk_cert_type FOREIGN KEY (certification_type_id) REFERENCES certification_type(certification_type_id),
  CONSTRAINT chk_date_validity CHECK (expiry_date > issue_date)
);

-- --------------------------------------------------
-- Tenant Module Tables
-- --------------------------------------------------

CREATE TABLE tenant_person (
  tenant_id VARCHAR(50) PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  date_of_birth DATE,
  contact_details TEXT,
  vulnerability_flag BOOLEAN DEFAULT FALSE,
  person_alert_code VARCHAR(50)
);

CREATE TABLE tenancy (
  tenancy_id VARCHAR(50) PRIMARY KEY,
  tenant_id VARCHAR(50) NOT NULL,
  address_id VARCHAR(50) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  tenancy_type VARCHAR(100),
  tenancy_status VARCHAR(100),
  CONSTRAINT fk_tenancy_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id)
);

CREATE TABLE household_member_person (
  household_member_id VARCHAR(50) PRIMARY KEY,
  tenant_id VARCHAR(50) NOT NULL,
  tenancy_id VARCHAR(50) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  date_of_birth DATE,
  relationship_to_tenant VARCHAR(100),
  is_contract_holder BOOLEAN DEFAULT FALSE,
  vulnerability_details TEXT,
  person_alert_code VARCHAR(50),
  risk_assessment_status VARCHAR(100),
  risk_assessment_date DATE,
  CONSTRAINT fk_household_member_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id),
  CONSTRAINT fk_household_member_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id)
);

-- --------------------------------------------------
-- Work Order Lookup Tables
-- --------------------------------------------------

CREATE TABLE contractor_organisation (
  contractor_organisation_id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255),
  contractor_portal VARCHAR(255),
  subcontractors TEXT
);

CREATE TABLE work_class (
  work_class_id VARCHAR(255) PRIMARY KEY,
  work_class_code VARCHAR(100),
  work_class_description TEXT
);

CREATE TABLE work_priority (
  work_priority_id VARCHAR(255) PRIMARY KEY,
  priority_code VARCHAR(100),
  priority_description TEXT,
  effective_date_time TIMESTAMP,
  number_of_days INTEGER,
  comments TEXT,
  required_start_date_time DATE,
  required_completion_date_time DATE
);

CREATE TABLE trade_code (
  trade_code VARCHAR(100) PRIMARY KEY,
  custom_code VARCHAR(100),
  custom_name VARCHAR(255)
);

CREATE TABLE rate_schedule_item (
  rate_schedule_item_id VARCHAR(255) PRIMARY KEY,
  m3nhf_sor_code VARCHAR(100),
  quantity DECIMAL(10,2),
  custom_code VARCHAR(100),
  custom_name VARCHAR(255)
);

-- --------------------------------------------------
-- Work Order Module Tables
-- --------------------------------------------------

CREATE TABLE work_order (
  work_order_id VARCHAR(255) PRIMARY KEY,
  work_element_id VARCHAR(255),
  address_id VARCHAR(255),
  inspection_id VARCHAR(255),
  escalation_id VARCHAR(255),
  tenancy_id VARCHAR(255),
  tenant_id VARCHAR(255),
  hazard_report_id VARCHAR(255),
  work_class_id VARCHAR(255),
  location_alert_id VARCHAR(255),
  person_alert_id VARCHAR(255),
  work_priority_id VARCHAR(255),
  contractor_organisation_id VARCHAR(255),
  date_raised DATE,
  date_reported DATE,
  planned_start_date DATE,
  planned_finish_date DATE,
  actual_start_date_time TIMESTAMP,
  actual_completion_date_time TIMESTAMP,
  description_of_work TEXT,
  estimated_cost DECIMAL(10,2),
  estimated_labour_hours DECIMAL(5,2),
  location_of_repair VARCHAR(255),
  job_status_update VARCHAR(255),
  repair_sla_breach_flag VARCHAR(10),
  CONSTRAINT fk_work_order_work_class FOREIGN KEY (work_class_id) REFERENCES work_class(work_class_id),
  CONSTRAINT fk_work_order_work_priority FOREIGN KEY (work_priority_id) REFERENCES work_priority(work_priority_id),
  CONSTRAINT fk_work_order_contractor_org FOREIGN KEY (contractor_organisation_id) REFERENCES contractor_organisation(contractor_organisation_id)
);

CREATE TABLE work_order_status_history (
  work_order_status_history_id VARCHAR(255) PRIMARY KEY,
  work_order_id VARCHAR(255),
  status_code VARCHAR(100),
  updated_by VARCHAR(255),
  reason TEXT,
  reason_code VARCHAR(100),
  created_date_time TIMESTAMP,
  entered_date_time TIMESTAMP,
  exited_date_time TIMESTAMP,
  comments TEXT,
  CONSTRAINT fk_work_order_status_history_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id)
);

CREATE TABLE work_order_complete (
  work_order_complete_id VARCHAR(255) PRIMARY KEY,
  work_order_id VARCHAR(255),
  bill_of_material_item VARCHAR(255),
  completed_work_elements TEXT,
  operatives_used TEXT,
  job_status_update VARCHAR(255),
  follow_on_work VARCHAR(255),
  CONSTRAINT fk_work_order_complete_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id)
);

CREATE TABLE work_order_access_information (
  access_info_id VARCHAR(255) PRIMARY KEY,
  work_order_id VARCHAR(255),
  description VARCHAR(100),
  key_safe TEXT,
  CONSTRAINT fk_work_order_access_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id)
);

CREATE TABLE alert_regarding_location (
  location_alert_id VARCHAR(255) PRIMARY KEY,
  alert_type VARCHAR(100),
  attachments TEXT,
  comments TEXT,
  work_order_id VARCHAR(255),
  CONSTRAINT fk_alert_location_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id)
);

CREATE TABLE alert_regarding_person (
  person_alert_id VARCHAR(255) PRIMARY KEY,
  alert_type VARCHAR(100),
  comments TEXT,
  work_order_id VARCHAR(255),
  CONSTRAINT fk_alert_person_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id)
);

-- --------------------------------------------------
-- Inspection Module Tables
-- --------------------------------------------------

CREATE TABLE hazard_type (
  hazard_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  hazard_type NVARCHAR(100) NOT NULL,
  health_risk_rating_id INTEGER NOT NULL,
  category NVARCHAR(500),
  CONSTRAINT fk_hazard_type_health_risk_rating FOREIGN KEY (health_risk_rating_id) REFERENCES health_risk_rating(health_risk_rating_id)
);

CREATE TABLE hazard_report (
  hazard_report_id INTEGER PRIMARY KEY AUTOINCREMENT,
  property_id INTEGER NOT NULL,
  tenant_id VARCHAR(50) NOT NULL,
  date_reported DATE NOT NULL,
  reported_by NVARCHAR(100) NOT NULL,
  description NVARCHAR(500),
  photo_evidence NVARCHAR(500),
  location_details NVARCHAR(500),
  investigation_type_id INTEGER NOT NULL,
  investigation_due_date DATE NOT NULL,
  emergency_action_taken INTEGER NOT NULL DEFAULT 0,
  made_safe_date DATE,
  further_work_required INTEGER NOT NULL DEFAULT 0,
  further_work_due_date DATE,
  report_status_id INTEGER NOT NULL,
  CONSTRAINT fk_hazard_report_property FOREIGN KEY (property_id) REFERENCES property(property_id),
  CONSTRAINT fk_hazard_report_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id),
  CONSTRAINT fk_hazard_report_investigation_type FOREIGN KEY (investigation_type_id) REFERENCES investigation_type(investigation_type_id),
  CONSTRAINT fk_hazard_report_status FOREIGN KEY (report_status_id) REFERENCES report_status(report_status_id),
  CONSTRAINT chk_emergency_action CHECK (emergency_action_taken IN (0,1)),
  CONSTRAINT chk_further_work_required CHECK (further_work_required IN (0,1)),
  CONSTRAINT chk_further_work_due_date CHECK (further_work_due_date IS NULL OR further_work_due_date >= investigation_due_date),
  CONSTRAINT chk_made_safe_date CHECK (made_safe_date IS NULL OR made_safe_date >= date_reported)
);

CREATE TABLE inspection (
  inspection_id INTEGER PRIMARY KEY AUTOINCREMENT,
  property_id INTEGER NOT NULL,
  tenant_id VARCHAR(50) NOT NULL,
  tenancy_id VARCHAR(50) NOT NULL,
  trigger_source_id INTEGER NOT NULL,
  hazard_reported_date DATE NOT NULL,
  inspection_scheduled_date DATE,
  inspection_completed_date DATE,
  inspector_name NVARCHAR(100),
  hazard_confirmed INTEGER NOT NULL DEFAULT 0,
  repair_required INTEGER NOT NULL DEFAULT 0,
  repair_scheduled_date DATE,
  repair_completed_date DATE,
  sla_breach_flag INTEGER NOT NULL DEFAULT 0,
  escalation_status_id INTEGER NOT NULL,
  notification_sent_to_tenant INTEGER NOT NULL DEFAULT 0,
  inspection_notes NVARCHAR(500),
  CONSTRAINT fk_inspection_property FOREIGN KEY (property_id) REFERENCES property(property_id),
  CONSTRAINT fk_inspection_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id),
  CONSTRAINT fk_inspection_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_inspection_trigger_source FOREIGN KEY (trigger_source_id) REFERENCES trigger_source(trigger_source_id),
  CONSTRAINT fk_inspection_escalation_status FOREIGN KEY (escalation_status_id) REFERENCES escalation_status(escalation_status_id),
  CONSTRAINT chk_hazard_confirmed CHECK (hazard_confirmed IN (0,1)),
  CONSTRAINT chk_repair_required CHECK (repair_required IN (0,1)),
  CONSTRAINT chk_sla_breach CHECK (sla_breach_flag IN (0,1)),
  CONSTRAINT chk_notification_sent_to_tenant CHECK (notification_sent_to_tenant IN (0,1)),
  CONSTRAINT chk_repair_completed_date CHECK (repair_completed_date IS NULL OR repair_scheduled_date IS NULL OR repair_completed_date >= repair_scheduled_date),
  CONSTRAINT chk_inspection_scheduled_date CHECK (inspection_scheduled_date IS NULL OR inspection_scheduled_date >= hazard_reported_date),
  CONSTRAINT chk_inspection_completed_date CHECK (inspection_completed_date IS NULL OR inspection_scheduled_date IS NULL OR inspection_completed_date >= inspection_scheduled_date)
);

CREATE TABLE inspection_hazard (
  inspection_hazard_id INTEGER PRIMARY KEY AUTOINCREMENT,
  hazard_type_id INTEGER NOT NULL,
  inspection_id INTEGER NOT NULL,
  hazard_report_id INTEGER NOT NULL,
  severity_id INTEGER NOT NULL,
  notes NVARCHAR(500),
  CONSTRAINT fk_inspection_hazard_type FOREIGN KEY (hazard_type_id) REFERENCES hazard_type(hazard_type_id),
  CONSTRAINT fk_inspection_hazard_inspection FOREIGN KEY (inspection_id) REFERENCES inspection(inspection_id),
  CONSTRAINT fk_inspection_hazard_report FOREIGN KEY (hazard_report_id) REFERENCES hazard_report(hazard_report_id),
  CONSTRAINT fk_inspection_hazard_severity FOREIGN KEY (severity_id) REFERENCES severity(severity_id)
);

CREATE TABLE escalation (
  escalation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  inspection_id INTEGER NOT NULL,
  escalation_reason NVARCHAR(100),
  escalation_stage_id INTEGER NOT NULL,
  escalation_type_id INTEGER NOT NULL,
  escalated_to NVARCHAR(100) NOT NULL,
  escalation_start_date DATE NOT NULL,
  escalation_end_date DATE,
  action_taken NVARCHAR(500),
  compensation_offered INTEGER NOT NULL DEFAULT 0,
  compensation_amount DECIMAL(10,2),
  alternative_accommodation_offered INTEGER NOT NULL DEFAULT 0,
  alternative_accommodation_details NVARCHAR(500),
  tenant_acceptance INTEGER NOT NULL DEFAULT 0,
  escalation_notes NVARCHAR(500),
  CONSTRAINT fk_escalation_inspection FOREIGN KEY (inspection_id) REFERENCES inspection(inspection_id),
  CONSTRAINT fk_escalation_stage FOREIGN KEY (escalation_stage_id) REFERENCES escalation_stage(escalation_stage_id),
  CONSTRAINT fk_escalation_type FOREIGN KEY (escalation_type_id) REFERENCES escalation_type(escalation_type_id),
  CONSTRAINT chk_compensation_offered CHECK (compensation_offered IN (0,1)),
  CONSTRAINT chk_alternative_accommodation_offered CHECK (alternative_accommodation_offered IN (0,1)),
  CONSTRAINT chk_tenant_acceptance CHECK (tenant_acceptance IN (0,1)),
  CONSTRAINT chk_compensation_amount CHECK (compensation_amount IS NULL OR compensation_amount >= 0),
  CONSTRAINT chk_escalation_end_date CHECK (escalation_end_date IS NULL OR escalation_end_date >= escalation_start_date),
  CONSTRAINT chk_compensation_amount_offered CHECK ((compensation_offered = 0 AND compensation_amount IS NULL) OR (compensation_offered = 1 AND compensation_amount IS NOT NULL)),
  CONSTRAINT chk_alternative_accommodation_details_offered CHECK ((alternative_accommodation_offered = 0 AND alternative_accommodation_details IS NULL) OR (alternative_accommodation_offered = 1 AND alternative_accommodation_details IS NOT NULL))
);

CREATE TABLE work_order_notification (
  notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
  inspection_id INTEGER NOT NULL,
  tenant_id VARCHAR(50) NOT NULL,
  work_order_id VARCHAR(255) NOT NULL,
  notification_type_id INTEGER NOT NULL,
  date_sent DATE NOT NULL,
  notification_method_id INTEGER NOT NULL,
  content_summary NVARCHAR(500),
  CONSTRAINT fk_notification_inspection FOREIGN KEY (inspection_id) REFERENCES inspection(inspection_id),
  CONSTRAINT fk_notification_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id),
  CONSTRAINT fk_notification_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id),
  CONSTRAINT fk_notification_type FOREIGN KEY (notification_type_id) REFERENCES notification_type(notification_type_id),
  CONSTRAINT fk_notification_method FOREIGN KEY (notification_method_id) REFERENCES notification_method(notification_method_id)
);
