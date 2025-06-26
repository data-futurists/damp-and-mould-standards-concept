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
  work_order_id VARCHAR(255) PRIMARY KEY,
  work_element_id VARCHAR(255),
  address_id VARCHAR(255),
  investigation_id VARCHAR(255),
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
  work_element_id VARCHAR(50) PRIMARY KEY,          -- Unique ID for the work element  
  work_order_id VARCHAR(50),                        -- FK to the associated work order
  rate_schedule_item_id VARCHAR(255),               -- FK to rate_schedule_item
  trade_code_id VARCHAR(100),                       -- FK to trade_code
  service_charge_subject VARCHAR(255),              -- Subject to service charge?
  CONSTRAINT fk_work_element_work_order FOREIGN KEY (work_order_id) 
    REFERENCES work_order(work_order_id),
  CONSTRAINT fk_work_element_rate_schedule_item FOREIGN KEY (rate_schedule_item_id) 
    REFERENCES rate_schedule_item(rate_schedule_item_id),
  CONSTRAINT fk_work_element_trade_code FOREIGN KEY (trade_code_id) 
    REFERENCES trade_code(trade_code_id)
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

CREATE TABLE work_element (
    work_element_id VARCHAR(50) PRIMARY KEY,            -- Unique ID for the work element
    work_order_id VARCHAR(50),                          -- FK to the associated work order
    rate_schedule_item_id VARCHAR(255),                  -- FK to RateScheduleItem
    trade_code_id VARCHAR(100),                         -- FK to TradeCode
    service_charge_subject VARCHAR(255),                -- Subject to service charge?
    CONSTRAINT fk_work_element_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id), 
    CONSTRAINT fk_workE_element_rate_schedule_item FOREIGN KEY (rate_schedule_item_id) REFERENCES rate_schedule_item(rate_schedule_item_id), 
    CONSTRAINT fk_work_element_trade_code FOREIGN KEY (trade_code_id) REFERENCES trade_code(trade_code_id)
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
  reason_id TEXT,
  created_date_time TIMESTAMP,
  entered_date_time TIMESTAMP,
  exited_date_time TIMESTAMP,
  comments TEXT,
  CONSTRAINT fk_work_order_status_history_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id)
  CONSTRAINT fk_work_order_status_history_work_status FOREIGN KEY (work_status_id) REFERENCES work_status(work_status_id),
  CONSTRAINT fk_work_order_status_history_reason FOREIGN KEY (reason_id) REFERENCES reason_code(reason_code_id)
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