-- ============================================
-- SECTION 1: CODE LISTS (Reference Tables)
-- ============================================

CREATE TABLE health_risk_rating (
  health_risk_rating_id INTEGER PRIMARY KEY AUTOINCREMENT,
  rating NVARCHAR(20) NOT NULL
);

INSERT INTO health_risk_rating (rating) 
VALUES 
  ('High'), 
  ('Medium'), 
  ('Low');

CREATE TABLE severity (
  severity_id INTEGER PRIMARY KEY AUTOINCREMENT,
  level NVARCHAR(20) NOT NULL
);
INSERT INTO severity (level) 
VALUES 
  ('High'), 
  ('Medium'), 
  ('Low');

CREATE TABLE investigation_type (
  investigation_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  type NVARCHAR(20) NOT NULL
);
INSERT INTO investigation_type (type) 
VALUES 
  ('Standard'), 
  ('Renewed'), 
  ('Further'), 
  ('Emergency');

CREATE TABLE report_status (
  report_status_id INTEGER PRIMARY KEY AUTOINCREMENT,
  status NVARCHAR(20) NOT NULL
);
INSERT INTO report_status (status) 
VALUES 
  ('Open'), 
  ('Under Review'), 
  ('Made Safe'), 
  ('Closed');

CREATE TABLE trigger_source (
  trigger_source_id INTEGER PRIMARY KEY AUTOINCREMENT,
  source NVARCHAR(20) NOT NULL
);
INSERT INTO trigger_source (source) 
VALUES 
  ('Tenant Report'), 
  ('Routine Check'), 
  ('Environmental Sensor'), 
  ('Staff Report');

CREATE TABLE escalation_status (
  escalation_status_id INTEGER PRIMARY KEY AUTOINCREMENT,
  status NVARCHAR(20) NOT NULL
);
INSERT INTO escalation_status (status) 
VALUES 
  ('None'), 
  ('In Progress'), 
  ('Escalated');

CREATE TABLE escalation_stage (
  escalation_stage_id INTEGER PRIMARY KEY AUTOINCREMENT,
  stage NVARCHAR(20) NOT NULL
);
INSERT INTO escalation_stage (stage) 
VALUES 
  ('Open'), 
  ('In Progress'), 
  ('Resolved'), 
  ('Rejected');

CREATE TABLE escalation_type (
  escalation_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  type NVARCHAR(30) NOT NULL
);
INSERT INTO escalation_type (type)
VALUES 
  ('Senior Review'), 
  ('Legal Action'), 
  ('Compensation'), 
  ('Alternative Accommodation');

CREATE TABLE notification_type (
  notification_type_id INT PRIMARY KEY IDENTITY(1, 1), 
  notification_type NVARCHAR(20) NOT NULL
);
INSERT INTO notification_type (notification_type) 
VALUES 
  ('Scheduled'), 
  ('Result'), 
  ('Advice'), 
  ('Delay'),
  ('Escalation');

CREATE TABLE notification_method (
  notification_method_id INTEGER PRIMARY KEY AUTOINCREMENT,
  method NVARCHAR(20) NOT NULL
);
INSERT INTO notification_method (method)
VALUES 
  ('Email'), 
  ('SMS'), 
  ('Phone Call'), 
  ('Letter');

CREATE TABLE energy_efficiency_band (
  energy_efficiency_band_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code CHAR(1) NOT NULL UNIQUE
);
INSERT INTO energy_efficiency_band (code)
VALUES 
  ('A'), 
  ('B'), 
  ('C'), 
  ('D'), 
  ('E'), 
  ('F'), 
  ('G');

CREATE TABLE location_alert_type (
  location_alert_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO location_alert_type (code)
VALUES 
  ('Warranty'), 
  ('NonMainsSewage'), 
  ('ContactForDetails'), 
  ('OperativeGenderRestriction'),
  ('HeritageBuilding'),
  ('RecurringIssue'), 
  ('HighRiskArea'), 
  ('EnvironmentalHazard'), 
  ('AccessRestriction'), 
  ('StructuralIssue'),
  ('PoorVentilation'),
  ('PastHHSRSFailure'),
  ('FireSafetyConcern'),
  ('PestInfestation'),
  ('AsbestosPresent'),
  ('WaterLeakage'),
  ('FireRisk');

CREATE TABLE glazing_type (
  glazing_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO glazing_type (code)
VALUES 
  ('None'),
  ('Single'), 
  ('Double'), 
  ('Triple'), 
  ('Secondary'),
  ('Other'), 
  ('Unknown');

CREATE TABLE roof_insulation_type (
  roof_insulation_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO roof_insulation_type (code)
VALUES 
  ('None'), 
  ('Partial'), 
  ('Full'), 
  ('Board'), 
  ('Roll'),
  ('LooseFill'),
  ('SprayFoam'), 
  ('Other'), 
  ('Unknown');

CREATE TABLE wall_insulation_type (
  wall_insulation_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO wall_insulation_type (code)
VALUES 
  ('None'),                             
  ('Cavity'), 
  ('CavityPartial'), 
  ('CavityFull'), 
  ('External'), 
  ('External_EPS'), 
  ('External_MineralWool'), 
  ('External_WoodFibre'), 
  ('Internal'), 
  ('Internal_PIR'), 
  ('Internal_MineralWool'), 
  ('Internal_InsulatedPlasterboard'), 
  ('SolidWallInsulated'), 
  ('SolidWallUninsulated'), 
  ('TimberFrameInsulated'), 
  ('TimberFrameUninsulated'), 
  ('SystemBuildInsulated'), 
  ('SystemBuildUninsulated'), 
  ('StoneWallInsulated'), 
  ('StoneWallUninsulated'), 
  ('ParkHomeInsulation'), 
  ('PartyWallInsulation'), 
  ('Partial'), 
  ('Full'), 
  ('Unknown');

CREATE TABLE construction_type (
  construction_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO construction_type (code)
VALUES
  ('SolidBrick'), 
  ('CavityBrick'), 
  ('TimberFrame'), 
  ('SteelFrame'), 
  ('ConcreteFrame'), 
  ('SystemBuilt'), 
  ('Cob'), 
  ('Stone'), 
  ('WattleAndDaub'), 
  ('BrickAndBlock'), 
  ('CrossLaminatedTimber'), 
  ('InsulatedConcreteFormwork'), 
  ('StructuralInsulatedPanels'), 
  ('ParkHome'), 
  ('PreCastConcrete'), 
  ('NoFinesConcrete'), 
  ('ReinforcedConcrete'), 
  ('Mixed'), 
  ('Unknown');

CREATE TABLE certification_type (
  certification_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO certification_type (code)
VALUES 
  ('EPC'),      -- Energy Performance Certificate
  ('EIC'),      -- Electrical Installation Certificate
  ('EICR'),     -- Electrical Installation Condition Report
  ('PAT'),      -- Portable Appliance Testing
  ('FRA'),      -- Fire Risk Assessment
  ('LGSR'),     -- Landlord Gas Safety Record
  ('CPC');      -- Compliance with Property Conditions

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
  location_alert_type_id INTEGER,
  lease VARCHAR(255),
  CONSTRAINT fk_unit_property FOREIGN KEY (property_id) REFERENCES property(property_id),
  CONSTRAINT fk_unit_alert_type FOREIGN KEY (location_alert_type_id) REFERENCES location_alert_type(location_alert_type_id)
);

CREATE TABLE address (
  address_id INTEGER PRIMARY KEY,
  unit_id INTEGER NOT NULL,
  uprn INTEGER NOT NULL,
  address_line VARCHAR(255),
  building_name VARCHAR(255),
  street_name VARCHAR(255),
  building_number VARCHAR(50),
  floor INTEGER,
  city_name VARCHAR(100) NOT NULL,
  country VARCHAR(100) NOT NULL,
  post_code VARCHAR(20) NOT NULL,
  CONSTRAINT fk_address_unit FOREIGN KEY (unit_id) REFERENCES unit(unit_id)
);

CREATE TABLE physical_characteristics (
  physical_char_id INTEGER PRIMARY KEY,
  property_id INTEGER NOT NULL,
  glazing_type_id INTEGER,
  wall_insulation_type_id INTEGER,
  roof_insulation_type_id INTEGER,
  ventilation_type VARCHAR(100),
  built_year INTEGER,
  construction_type_id INTEGER,
  last_updated_date DATE NOT NULL,
  CONSTRAINT fk_phys_property FOREIGN KEY (property_id) REFERENCES property(property_id),
  CONSTRAINT fk_glazing_type FOREIGN KEY (glazing_type_id) REFERENCES glazing_type(glazing_type_id),
  CONSTRAINT fk_wall_insulation FOREIGN KEY (wall_insulation_type_id) REFERENCES wall_insulation_type(wall_insulation_type_id),
  CONSTRAINT fk_roof_insulation FOREIGN KEY (roof_insulation_type_id) REFERENCES roof_insulation_type(roof_insulation_type_id),
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

CREATE TABLE tenancy (
  tenancy_id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant_id INTEGER NOT NULL,
  address_id INTEGER NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  tenancy_type VARCHAR(100),
  tenancy_status VARCHAR(100),
  CONSTRAINT fk_tenancy_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id)
);00

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

-- --------------------------------------------------
-- Work Order Lookup Tables
-- --------------------------------------------------

CREATE TABLE contractor_organisation (
  contractor_organisation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(255),
  contractor_portal VARCHAR(255),
  subcontractors TEXT
);

CREATE TABLE work_class (
  work_class_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO work_class (code)
VALUES 
  ('Emergency'), 
  ('Defect'), 
  ('Urgent'), 
  ('Remedial'), 
  ('Routine'),
  ('Upgrade'),
  ('Statutory'), 
  ('InsuranceClaim'), 
  ('PreventativePlanned'), 
  ('PlannedMaintenance'), 
  ('ReactiveMaintenance'), 
  ('VoidWorks'), 
  ('Adaptations'), 
  ('ImprovementWorks'), 
  ('ComplianceCheck'), 
  ('investigationFollowUp'), 
  ('EscalationWork'), 
  ('MoveManagement'),
  ('investigation'),
  ('Survey'), 
  ('Cleaning'), 
  ('GroundsMaintenance'), 
  ('PestControl'), 
  ('Security'), 
  ('FireSafety'), 
  ('HealthAndSafety'), 
  ('EnergyEfficiency'),
  ('EnvironmentalWorks'), 
  ('Decoration'), 
  ('Fencing'), 
  ('Roofing'), 
  ('Plumbing'), 
  ('Electrical'),
  ('HeatingAndVentilation'),
  ('CarpentryAndJoinery'),
  ('PaintingAndDecorating'),
  ('Flooring'),
  ('Landscaping'),
  ('Other');

CREATE TABLE trade_code (
  trade_code_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(100)
);
INSERT INTO trade_code (code) 
VALUES 
  ('Asphalter'),             
  ('Bricklayer'),
  ('BricklayingGang'),
  ('CarpenterJoiner'),
  ('CarpentryGang'),
  ('CleanTeam'),
  ('CleanVoid'),
  ('CleanGang'),
  ('CleanOperator'),
  ('DisabledAdaptation'),
  ('DrainLayer'),
  ('ElectricEngineer'),
  ('Electrician'),
  ('ElectricianGang'),
  ('ElectricianOperative'),
  ('Fencer'),
  ('FloorLayer'),
  ('Glazier'),
  ('GroundWorker'),
  ('GroundsMaintenanceGardener'),
  ('GroundsMaintenanceMowGrass'),
  ('GroundsMaintenanceRemoveGrassByHand'),
  ('GroundsMaintenanceRemoveLitter'),
  ('GroundsMaintenanceReplaceGravelMargins'),
  ('groundsMaintenanceRubbishRefuse'),
  ('GroundsMaintenanceGang'),
  ('GroundsMaintenanceOperative'),
  ('HeatingEngineer'),
  ('HeatingGasEngineer'),
  ('MechanicalEngineer'),
  ('MechanicalLiftCare'),
  ('MultiSkilledOperative'),
  ('MultiSkilledOperativeGeneral'),
  ('MultiSkilledOperativeHandyman'),
  ('PainterDecorator'),
  ('PainiterDecoratorGang'),
  ('Plasterer'),
  ('Plumber'),
  ('PlumberDrain'),
  ('PlumberWaterStorage'),
  ('PlumberGang'),
  ('Roofer'),
  ('RooferFlat'),
  ('RooferPitch'),
  ('RoofingGang'),
  ('Specialist'),
  ('SpecialistAsbestos'),
  ('SpecialistCCTV'),
  ('SpecialistDigitalAerials'),
  ('SpecialistDoorEntry'),
  ('SpecialistElectricianPlumber'),
  ('SpecialistEmergencyLighting'),
  ('SpecialistFireSafety'),
  ('SpecialistPestControl'),
  ('SpecialistRenewables'),
  ('SpecialistScaffolding'),
  ('SpecialistSecurity'),
  ('SpecialistUPVC'),
  ('StoneMason'),
  ('TilerWallFloor'),
  ('Other');

CREATE TABLE rate_schedule_item (
  rate_schedule_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO rate_schedule_item (code)
VALUES 
  ('SOR001'), 
  ('SOR002'), 
  ('SOR003'), 
  ('SOR004'), 
  ('SOR005'), 
  ('SOR006'), 
  ('SOR007'), 
  ('SOR008'), 
  ('SOR009'), 
  ('SOR010'),
  ('SOR011'),
  ('SOR012'),
  ('SOR013'),
  ('SOR014'),
  ('SOR015'),
  ('SOR016'),
  ('SOR017'),
  ('SOR018'),
  ('SOR019'),
  ('SOR020');

CREATE TABLE person_alert_type (
  person_alert_type_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  code VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO person_alert_type (code)
VALUES 
  -- from UKHDS
  ('DoNotVisitAlone'),
  ('DoNotVisitAloneASB'),
  ('Disability'),
  ('HearingImpairment'),
  ('VisionImpairment'),
  ('Illness'),
  ('PhysicalSupport'),
  ('WheelchairUser'),
  ('Elderly'),
  ('OtherSafeguardingConcern'),
  ('RegularMissingAppointments'),
  ('LanguageSupport'),
  ('LimitedCapacity'),
  -- new codes to consider
  ('Vulnerable'), 
  ('HighRisk'), 
  ('MedicalCondition'), 
  ('MentalHealthConcern'), 
  ('ChildProtectionIssue'), 
  ('ElderlyCareNeed'),
  ('DomesticAbuseConcern'),
  ('SubstanceMisuseIssue'),
  ('FinancialHardship'),
  ('HousingNeed'),
  ('CulturalSensitivity'),
  ('CommunicationBarrier'),
  ('MobilityImpairment'),
  ('SensoryImpairment'),
  ('LearningDisability'),
  ('AutismSpectrumCondition'),
  ('RefusedAccess'),
  ('Other');

-- --------------------------------------------------
-- Work Order Module Tables
-- --------------------------------------------------

CREATE TABLE work_order (
  work_order_id INTEGER PRIMARY KEY AUTOINCREMENT,
  work_element_id INTEGER(50) NOT NULL,  -- FK to work_element
  address_id INTEGER(50),
  investigation_id INTEGER(50),
  escalation_id INTEGER(50),
  tenancy_id INTEGER(50),
  tenant_id INTEGER(50),
  hazard_report_id INTEGER(50),
  work_class_id INTEGER(50),
  location_alert_id INTEGER(50),
  person_alert_id INTEGER(50),
  work_priority_id INTEGER(50),
  contractor_organisation_id INTEGER(50),
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
  CONSTRAINT fk_work_order_contractor_org FOREIGN KEY (contractor_organisation_id) REFERENCES contractor_organisation(contractor_organisation_id),  -- ← Added missing comma
  CONSTRAINT fk_work_order_location_alert_type FOREIGN KEY (location_alert_id) REFERENCES location_alert_type(location_alert_type_id),
  CONSTRAINT fk_work_order_person_alert_type FOREIGN KEY (person_alert_id) REFERENCES person_alert_type(person_alert_type_id),
  CONSTRAINT fk_work_order_address FOREIGN KEY (address_id) REFERENCES address(address_id),
  CONSTRAINT fk_work_order_investigation FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id),
  CONSTRAINT fk_work_order_escalation FOREIGN KEY (escalation_id) REFERENCES escalation(escalation_id),
  CONSTRAINT fk_work_order_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_work_order_tenant FOREIGN KEY (tenant_id) REFERENCES tenant_person(tenant_id),
  CONSTRAINT fk_work_order_hazard_report FOREIGN KEY (hazard_report_id) REFERENCES hazard_report(hazard_report_id),
  -- NOTE: The table `work_element` was not defined in the original script. If it exists, keep this FK; otherwise remove or adjust it.
  CONSTRAINT fk_work_order_work_element FOREIGN KEY (work_element_id) REFERENCES work_element(work_element_id),
  CONSTRAINT chk_repair_sla_breach_flag CHECK (repair_sla_breach_flag IN ('Yes', 'No'))
);

CREATE TABLE work_element (
  work_element_id INTEGER PRIMARY KEY AUTOINCREMENT,          -- Unique ID for the work element  
  work_order_id INTEGER(50),                        -- FK to the associated work order
  rate_schedule_item_id INTEGER(50),               -- FK to rate_schedule_item
  trade_code_id INTEGER(50),                       -- FK to trade_code
  service_charge_subject VARCHAR(255),              -- Subject to service charge?
  CONSTRAINT fk_work_element_work_order FOREIGN KEY (work_order_id) 
    REFERENCES work_order(work_order_id),
  CONSTRAINT fk_work_element_rate_schedule_item FOREIGN KEY (rate_schedule_item_id) 
    REFERENCES rate_schedule_item(rate_schedule_item_id),
  CONSTRAINT fk_work_element_trade_code FOREIGN KEY (trade_code_id) 
    REFERENCES trade_code(trade_code_id)
);

CREATE TABLE work_priority (
  work_priority_id INTEGER PRIMARY KEY AUTOINCREMENT,
  priority_code VARCHAR(100),
  priority_description TEXT,
  effective_date_time TIMESTAMP,
  number_of_days INTEGER,
  comments TEXT,
  required_start_date_time DATE,
  required_completion_date_time DATE
);

CREATE TABLE work_element_dependency (
    work_element_id VARCHAR(50) PRIMARY kEY,              -- Unique ID for the work element
    depends_on_work_element_id VARCHAR(50),                 -- FK to the required previous element
    type VARCHAR(100),                                  -- Type of dependency
    timing VARCHAR(255),                                -- Timing constraint or information
    description TEXT,                                   -- Description of the dependency
    CONSTRAINT fk_work_element_dependency_work_element FOREIGN KEY (work_element_id) REFERENCES work_element(work_element_id),
    CONSTRAINT fk_work_element_dependency_depends_on FOREIGN KEY (depends_on_work_element_id) REFERENCES work_element(work_element_id),
);

CREATE TABLE work_order_status_history (
  work_order_status_history_id VARCHAR(255) PRIMARY KEY,
  work_order_id VARCHAR(255),
  work_status_id VARCHAR(100),
  updated_by VARCHAR(255),
  reason_code_id TEXT,
  created_date_time TIMESTAMP,
  entered_date_time TIMESTAMP,
  exited_date_time TIMESTAMP,
  comments TEXT,
  CONSTRAINT fk_work_order_status_history_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id)
  CONSTRAINT fk_work_order_status_history_work_status FOREIGN KEY (work_status_id) REFERENCES work_status(work_status_id),
  CONSTRAINT fk_work_order_status_history_reason FOREIGN KEY (reason_code_id) REFERENCES reason_code(reason_code_id)
);




CREATE TABLE reason_code (
  reason_code_id VARCHAR(255) PRIMARY KEY,
  code VARCHAR(100) NOT NULL UNIQUE,
);
INSERT INTO reason_code (code)
VALUES 
-- UKHDS codes
  ('NoBudget'), 
  ('LowPriority'), 
  ('FullyFunded'), 
  ('PartiallyFunded'), 
  ('ScheduleConflict'), 
  ('NoApproval'), 
  ('Approved'), 
  ('PriorityChange'), 
 
-- new codes to consider
  ('NoAccess'), 
  ('TenantUnavailable'), 
  ('WeatherConditions'), 
  ('MaterialShortage'), 
  ('TechnicalIssue'), 
  ('ResourceAvailability'), 
  ('SafetyConcern'), 
  ('RegulatoryCompliance'), 
  ('Other');

CREATE TABLE work_status (
  work_status_id VARCHAR(255) PRIMARY KEY,
  code VARCHAR(100) NOT NULL UNIQUE,
  description TEXT
);
INSERT INTO work_status (code)
VALUES

  -- UKHDS codes
  ('AccountingHold'), 
  ('Cancelled'), 
  ('Complete'), 
  ('Estimating'), 
  ('Hold'), 
  ('PendingApproval'), 
  ('PendingDesign'), 
  ('PendingMaterial'), 
  ('Scheduled'),
  ('Superceded'),
--new codes to consider
  ('Open'), 
  ('InProgress'), 
  ('Completed'), 
  ('Cancelled'), 
  ('OnHold'), 
  ('AwaitingParts'), 
  ('AwaitingApproval'), 
  ('Scheduled'), 
  ('Delayed');

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

-- --------------------------------------------------
-- investigation Module Tables
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
  hazard_report_reference VARCHAR(36) NOT NULL,
  uprn INTEGER NOT NULL,
  tenancy_id VARCHAR(50) NOT NULL,
  date_reported DATE NOT NULL,
  reported_by NVARCHAR(100) NOT NULL,
  description NVARCHAR(500),
  photo_evidence NVARCHAR(500),
  location_details NVARCHAR(500),
  emergency_action_taken INTEGER NOT NULL DEFAULT 0,
  made_safe_date DATE,
  further_work_required INTEGER NOT NULL DEFAULT 0,
  further_work_due_date DATE,
  report_status_id INTEGER NOT NULL,
  CONSTRAINT fk_hazard_report_reference FOREGIN KEY (hazard_report_reference) REFERENCES reference(id),
  CONSTRAINT fk_hazard_report_property FOREIGN KEY (uprn) REFERENCES address(uprn),
  CONSTRAINT fk_hazard_report_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_hazard_report_investigation_type FOREIGN KEY (investigation_type_id) REFERENCES investigation_type(investigation_type_id),
  CONSTRAINT fk_hazard_report_status FOREIGN KEY (report_status_id) REFERENCES report_status(report_status_id),
  CONSTRAINT chk_emergency_action CHECK (emergency_action_taken IN (0,1)),
  CONSTRAINT chk_further_work_required CHECK (further_work_required IN (0,1)),
  CONSTRAINT chk_further_work_due_date CHECK (further_work_due_date IS NULL OR further_work_due_date >= investigation_due_date),
  CONSTRAINT chk_made_safe_date CHECK (made_safe_date IS NULL OR made_safe_date >= date_reported)
);

CREATE TABLE investigation (
  investigation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  investigation_reference VARCHAR(36) NOT NULL,
  uprn INTEGER NOT NULL,
  tenancy_id VARCHAR(50) NOT NULL,
  hazard_report_id INTEGER NOT NULL,
  trigger_source_id INTEGER NOT NULL,
  investigation_type_id INTEGER NOT NULL,
  investigation_scheduled_date DATE,
  investigation_completed_date DATE,
  investigator_id INTEGER NOT NULL,
  hazard_confirmed INTEGER NOT NULL DEFAULT 0,
  sla_breach_flag INTEGER NOT NULL DEFAULT 0,
  notification_sent_to_tenant INTEGER NOT NULL DEFAULT 0,
  investigation_notes NVARCHAR(500),
  CONSTRAINT fk_investigation_reference FOREGIN KEY (investigation_reference) REFERENCES reference(id),
  CONSTRAINT fk_investigation_property FOREIGN KEY (uprn) REFERENCES address(uprn),
  CONSTRAINT fk_investigation_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_investigation_hazard_report FOREIGN KEY (hazard_report_id) REFERENCES hazard_report(hazard_report_id),
  CONSTRAINT fk_investigation_trigger_source FOREIGN KEY (trigger_source_id) REFERENCES trigger_source(trigger_source_id),
  CONSTRAINT fk_investigation_investigator FOREIGN KEY (investigator_id) REFERENCES investigator(investigator_id),
  CONSTRAINT chk_hazard_confirmed CHECK (hazard_confirmed IN (0,1)),
  CONSTRAINT chk_repair_required CHECK (repair_required IN (0,1)),
  CONSTRAINT chk_sla_breach CHECK (sla_breach_flag IN (0,1)),
  CONSTRAINT chk_notification_sent_to_tenant CHECK (notification_sent_to_tenant IN (0,1)),,
  CONSTRAINT chk_investigation_scheduled_date CHECK (investigation_scheduled_date IS NULL OR investigation_scheduled_date >= hazard_reported_date),
  CONSTRAINT chk_investigation_completed_date CHECK (investigation_completed_date IS NULL OR investigation_scheduled_date IS NULL OR investigation_completed_date >= investigation_scheduled_date)
);

CREATE TABLE investigation_hazard (
  investigation_hazard_id INTEGER PRIMARY KEY AUTOINCREMENT,
  hazard_type_id INTEGER NOT NULL,
  investigation_id INTEGER NOT NULL,
  hazard_report_id INTEGER NOT NULL,
  severity_id INTEGER NOT NULL,
  notes NVARCHAR(500),
  CONSTRAINT fk_investigation_hazard_type FOREIGN KEY (hazard_type_id) REFERENCES hazard_type(hazard_type_id),
  CONSTRAINT fk_investigation_hazard_investigation FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id),
  CONSTRAINT fk_investigation_hazard_report FOREIGN KEY (hazard_report_id) REFERENCES hazard_report(hazard_report_id),
  CONSTRAINT fk_investigation_hazard_severity FOREIGN KEY (severity_id) REFERENCES severity(severity_id)
);

CREATE TABLE investigation_status_history (
  investigation_status_history_id VARCHAR(255) PRIMARY KEY,
  investigation_id VARCHAR(255),
  investigation_status_id VARCHAR(100),
  updated_by VARCHAR(255),
  reason_code_id TEXT,
  created_date_time TIMESTAMP,
  entered_date_time TIMESTAMP,
  exited_date_time TIMESTAMP,
  comments TEXT,
  CONSTRAINT fk_ivestigation_status_history_investigation FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id)
  CONSTRAINT fk_investigation_status_history_investigation_status FOREIGN KEY (investigation_status_id) REFERENCES investigation_status(investigation_status_id),
  CONSTRAINT fk_investigation_status_history_reason FOREIGN KEY (reason_code_id) REFERENCES reason_code(reason_code_id)
);

CREATE TABLE investigation_status (
  investigation_status_id VARCHAR(255) PRIMARY KEY,
  code VARCHAR(100) NOT NULL UNIQUE,
  description TEXT
);
INSERT INTO work_status (code)
VALUES

  ('Open'), 
  ('InProgress'), 
  ('Completed'), 
  ('Cancelled'), 
  ('OnHold'),
  ('AwaitingApproval'), 
  ('Scheduled'), 
  ('Delayed');

CREATE TABLE escalation (
  escalation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  escalation_reference VARCHAR(36) NOT NULL,
  investigation_id INTEGER NOT NULL,
  escalation_reason NVARCHAR(100),
  escalation_stage_id INTEGER NOT NULL,
  escalation_type_id INTEGER NOT NULL,
  escalated_to NVARCHAR(100) NOT NULL,
  escalation_start_date DATE NOT NULL,
  escalation_end_date DATE,
  action_taken NVARCHAR(500),
  compensation_amount DECIMAL(10,2),
  alternative_accommodation_details NVARCHAR(500),
  tenant_acceptance INTEGER NOT NULL DEFAULT 0,
  escalation_notes NVARCHAR(500),
  CONSTRAINT fk_escalation_reference FOREGIN KEY (escalation_reference) REFERENCES reference(id),
  CONSTRAINT fk_escalation_investigation FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id),
  CONSTRAINT fk_escalation_stage FOREIGN KEY (escalation_stage_id) REFERENCES escalation_stage(escalation_stage_id),
  CONSTRAINT fk_escalation_type FOREIGN KEY (escalation_type_id) REFERENCES escalation_type(escalation_type_id),
  CONSTRAINT chk_tenant_acceptance CHECK (tenant_acceptance IN (0,1)),
  CONSTRAINT chk_compensation_amount CHECK (compensation_amount IS NULL OR compensation_amount >= 0),
  CONSTRAINT chk_escalation_end_date CHECK (escalation_end_date IS NULL OR escalation_end_date >= escalation_start_date)
);

CREATE TABLE notification (
  notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
  investigation_id INTEGER NOT NULL,
  tenancy_id VARCHAR(50) NOT NULL,
  work_order_id VARCHAR(255) NOT NULL,
  notification_type_id INTEGER NOT NULL,
  escalation_id INTEGER NULL,
  date_sent DATE NOT NULL,
  notification_method_id INTEGER NOT NULL,
  content_summary NVARCHAR(500),
  CONSTRAINT fk_notification_investigation FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id),
  CONSTRAINT fk_notification_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_notification_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id),
  CONSTRAINT fk_notification_type FOREIGN KEY (notification_type_id) REFERENCES notification_type(notification_type_id),
  CONSTRAINT fk_notification_escalation FOREIGN KEY (escalation_id) REFERENCES escalation(escalation_id),
  CONSTRAINT fk_notification_method FOREIGN KEY (notification_method_id) REFERENCES notification_method(notification_method_id)
);

CREATE TABLE reference (
    id VARCHAR(36) NOT NULL PRIMARY KEY,
    allocated_by_code INTEGER NOT NULL,
    allocated_by_description VARCHAR(50) NOT NULL,
    description VARCHAR(200) NULL,
    allocated_by VARCHAR(50) NOT NULL
);
