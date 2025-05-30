----------------------------------------------------------------------------------------
-- Author(s): George Foster (TPXImpact), Rizwan Nobeebux (Data Futurists), Elena Iurco (Data Futurists)
-- Email(s): george.foster@tpximpact.com, rizwan.nobeebux@datafuturists.com, elena.iurco@datafuturists.com
--
-- Scripts below create the required tables in the Inspection, Property, Tenant and Work Order Modules
----------------------------------------------------------------------------------------
-- NOTES
-- On delete or on update behaviour for the FKs? Leave for now
----------------------------------------------------------------------------------------
-- Create HazardType table
-- Table storing types of hazards.
CREATE TABLE HazardType (
  HazardTypeID INT PRIMARY KEY IDENTITY(1, 1), 
  HazardType NVARCHAR(100) NOT NULL, 
  HealthRiskRatingID INT NOT NULL, 
  Category NVARCHAR(500) NULL, 
  CONSTRAINT fk_hazardtype_healthriskrating FOREIGN KEY (HealthRiskRatingID) REFERENCES HealthRiskRating(HealthRiskRatingID)
);
-- Create HazardReport table
-- Table storing hazard reports submitted.
CREATE TABLE HazardReport (
  HazardReportID INT PRIMARY KEY IDENTITY(1, 1), 
  PropertyID INT NOT NULL, 
  TenantID INT NOT NULL, 
  DateReported DATE NOT NULL, 
  ReportedBy NVARCHAR(100) NOT NULL, 
  Description NVARCHAR(500) NULL, 
  PhotoEvidence NVARCHAR(500) NULL, 
  LocationDetails NVARCHAR(500) NULL, 
  InvestigationTypeID INT NOT NULL, 
  InvestigationDueDate DATE NOT NULL, 
  EmergencyActionTaken BIT NOT NULL DEFAULT 0, 
  MadeSafeDate DATE NULL, 
  FurtherWorkRequired BIT NOT NULL DEFAULT 0, 
  FurtherWorkDueDate DATE NULL, 
  ReportStatusID INT NOT NULL, 
  CONSTRAINT fk_hazardreport_property FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID), 
  CONSTRAINT fk_hazardreport_tenant FOREIGN KEY (TenantID) REFERENCES TenantPerson(TenantID), 
  CONSTRAINT fk_hazardreport_investigationtype FOREIGN KEY (InvestigationTypeID) REFERENCES InvestigationType(InvestigationTypeID), 
  CONSTRAINT fk_hazardreport_reportstatus FOREIGN KEY (ReportStatusID) REFERENCES ReportStatus(ReportStatusID), 
  CONSTRAINT chk_emergency_action CHECK (
    EmergencyActionTaken IN (0, 1)
  ), 
  CONSTRAINT chk_further_work_required CHECK (
    FurtherWorkRequired IN (0, 1)
  ), 
  CONSTRAINT chk_further_work_due_date CHECK (
    FurtherWorkDueDate IS NULL 
    OR FurtherWorkDueDate >= InvestigationDueDate
  ), 
  CONSTRAINT chk_made_safe_date CHECK (
    MadeSafeDate IS NULL 
    OR MadeSafeDate >= DateReported
  )
);
-- Create Inspection table
-- Table storing inspection details.
CREATE TABLE Inspection (
  InspectionID INT PRIMARY KEY IDENTITY(1, 1), 
  PropertyID INT NOT NULL, 
  TenantID INT NOT NULL, 
  TenancyID INT NOT NULL, 
  TriggerSourceID INT NOT NULL, 
  HazardReportedDate DATE NOT NULL, 
  InspectionScheduledDate DATE NULL, 
  InspectionCompletedDate DATE NULL, 
  InspectorName NVARCHAR(100) NULL, 
  HazardConfirmed BIT NOT NULL DEFAULT 0, 
  RepairRequired BIT NOT NULL DEFAULT 0, 
  RepairScheduledDate DATE NULL, 
  RepairCompletedDate DATE NULL, 
  SLABreachFlag BIT NOT NULL DEFAULT 0, 
  EscalationStatusID INT NOT NULL, 
  NotificationSentToTenant BIT NOT NULL DEFAULT 0, 
  InspectionNotes NVARCHAR(500) NULL, 
  CONSTRAINT fk_inspection_property FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID), 
  CONSTRAINT fk_inspection_tenant FOREIGN KEY (TenantID) REFERENCES TenantPerson(TenantID), 
  CONSTRAINT fk_inspection_tenancy FOREIGN KEY (TenancyID) REFERENCES Tenancy(TenancyID), 
  CONSTRAINT fk_inspection_triggersource FOREIGN KEY (TriggerSourceID) REFERENCES TriggerSource(TriggerSourceID), 
  CONSTRAINT fk_inspection_escalationstatus FOREIGN KEY (EscalationStatusID) REFERENCES EscalationStatus(EscalationStatusID), 
  CONSTRAINT chk_hazard_confirmed CHECK (
    HazardConfirmed IN (0, 1)
  ), 
  CONSTRAINT chk_repair_required CHECK (
    RepairRequired IN (0, 1)
  ), 
  CONSTRAINT chk_sla_breach CHECK (
    SLABreachFlag IN (0, 1)
  ), 
  CONSTRAINT chk_notification_sent_tenant CHECK (
    NotificationSentToTenant IN (0, 1)
  ), 
  CONSTRAINT chk_repair_completed_date CHECK (
    RepairCompletedDate IS NULL 
    OR RepairScheduledDate IS NULL 
    OR RepairCompletedDate >= RepairScheduledDate
  ), 
  CONSTRAINT chk_inspection_scheduled_date CHECK (
    InspectionScheduledDate IS NULL 
    OR InspectionScheduledDate >= HazardReportedDate
  ), 
  CONSTRAINT chk_inspection_completed_date CHECK (
    InspectionCompletedDate IS NULL 
    OR InspectionScheduledDate IS NULL 
    OR InspectionCompletedDate >= InspectionScheduledDate
  )
);
-- Create InspectionHazard table
-- Table mapping inspections to hazards found.
CREATE TABLE InspectionHazard (
  InspectionHazardID INT PRIMARY KEY IDENTITY(1, 1), 
  HazardTypeID INT NOT NULL, 
  InspectionID INT NOT NULL, 
  HazardReportID INT NOT NULL, 
  SeverityID INT NOT NULL, 
  Notes NVARCHAR(500) NULL, 
  CONSTRAINT fk_inspectionhazard_hazardtype FOREIGN KEY (HazardTypeID) REFERENCES HazardType(HazardTypeID), 
  CONSTRAINT fk_inspectionhazard_inspection FOREIGN KEY (InspectionID) REFERENCES Inspection(InspectionID), 
  CONSTRAINT fk_inspectionhazard_hazardreport FOREIGN KEY (HazardReportID) REFERENCES HazardReport(HazardReportID), 
  CONSTRAINT fk_inspectionhazard_severity FOREIGN KEY (SeverityID) REFERENCES Severity(SeverityID)
);
-- Create Notification table
-- Table storing notifications related to inspections.
CREATE TABLE Notification (
  NotificationID INT PRIMARY KEY IDENTITY(1, 1), 
  InspectionID INT NOT NULL, 
  TenantID INT NOT NULL, 
  WorkOrderID INT NOT NULL, 
  NotificationTypeID INT NOT NULL, 
  DateSent DATE NOT NULL, 
  NotificationMethodID INT NOT NULL, 
  ContentSummary NVARCHAR(500) NULL, 
  CONSTRAINT fk_notification_inspection FOREIGN KEY (InspectionID) REFERENCES Inspection(InspectionID), 
  CONSTRAINT fk_notification_tenant FOREIGN KEY (TenantID) REFERENCES TenantPerson(TenantID), 
  CONSTRAINT fk_notification_workorder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID), 
  CONSTRAINT fk_notification_notificationtype FOREIGN KEY (NotificationTypeID) REFERENCES NotificationType(NotificationTypeID), 
  CONSTRAINT fk_notification_notificationmethod FOREIGN KEY (NotificationMethodID) REFERENCES NotificationMethod(NotificationMethodID)
);
-- Create Escalation table
-- Table storing escalation actions and tracking.
CREATE TABLE Escalation (
  EscalationID INT PRIMARY KEY IDENTITY(1, 1), 
  InspectionID INT NOT NULL, 
  EscalationReason NVARCHAR(100) NULL, 
  EscalationStageID INT NOT NULL, 
  EscalationTypeID INT NOT NULL, 
  EscalatedTo NVARCHAR(100) NOT NULL, 
  EscalationStartDate DATE NOT NULL, 
  EscalationEndDate DATE NULL, 
  ActionTaken NVARCHAR(500) NULL, 
  CompensationOffered BIT NOT NULL DEFAULT 0, 
  CompensationAmount DECIMAL(10, 2) NULL, 
  AlternativeAccommodationOffered BIT NOT NULL DEFAULT 0, 
  AlternativeAccommodationDetails NVARCHAR(500) NULL, 
  TenantAcceptance BIT NOT NULL DEFAULT 0, 
  EscalationNotes NVARCHAR(500) NULL, 
  CONSTRAINT fk_escalation_inspection FOREIGN KEY (InspectionID) REFERENCES Inspection(InspectionID), 
  CONSTRAINT fk_escalation_escalationstage FOREIGN KEY (EscalationStageID) REFERENCES EscalationStage(EscalationStageID), 
  CONSTRAINT fk_escalation_escalationtype FOREIGN KEY (EscalationTypeID) REFERENCES EscalationType(EscalationTypeID), 
  CONSTRAINT chk_compensation_offered CHECK (
    CompensationOffered IN (0, 1)
  ), 
  CONSTRAINT chk_alternative_accomodation CHECK (
    AlternativeAccommodationOffered IN (0, 1)
  ), 
  CONSTRAINT chk_tenant_acceptance CHECK (
    TenantAcceptance IN (0, 1)
  ), 
  CONSTRAINT chk_compensation_amount CHECK (
    CompensationAmount IS NULL 
    OR CompensationAmount >= 0
  ), 
  CONSTRAINT chk_escalation_end_date CHECK (
    EscalationEndDate IS NULL 
    OR EscalationEndDate >= EscalationStartDate
  ), 
  CONSTRAINT chk_compensation_amount_offered CHECK (
    (
      CompensationOffered = 0 
      AND CompensationAmount IS NULL
    ) 
    OR (
      CompensationOffered = 1 
      AND CompensationAmount IS NOT NULL
    )
  ), 
  CONSTRAINT chk_alternative_accomodation_offered CHECK (
    (
      AlternativeAccommodationOffered = 0 
      AND AlternativeAccommodationDetails IS NULL
    ) 
    OR (
      AlternativeAccommodationOffered = 1 
      AND AlternativeAccommodationDetails IS NOT NULL
    )
  )
);

----------------------------------------------------------------------------------------
-- Property tables
----------------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------
-- Tenant Tables
----------------------------------------------------------------------------------------
-- TenantPerson Table
CREATE TABLE TenantPerson (
  TenantID VARCHAR(50) PRIMARY KEY,
  FullName VARCHAR(255) NOT NULL,
  DateOfBirth DATE,
  ContactDetails TEXT,
  VulnerabilityFlag BOOLEAN DEFAULT FALSE,
  PersonAlertCode VARCHAR(50)
);

-- Tenancy Table
CREATE TABLE Tenancy (
  TenancyID VARCHAR(50) PRIMARY KEY,
  TenantID VARCHAR(50) NOT NULL,
  AddressID VARCHAR(50) NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE,
  TenancyType VARCHAR(100),
  TenancyStatus VARCHAR(100),
  CONSTRAINT FK_Tenancy_Tenant FOREIGN KEY (TenantID) REFERENCES TenantPerson(TenantID)
);

-- HouseholdMemberPerson Table
CREATE TABLE HouseholdMemberPerson (
  HouseholdMemberID VARCHAR(50) PRIMARY KEY,
  TenantID VARCHAR(50) NOT NULL,
  TenancyID VARCHAR(50) NOT NULL,
  FullName VARCHAR(255) NOT NULL,
  DateOfBirth DATE,
  RelationshipToTenant VARCHAR(100),
  IsContractHolder BOOLEAN DEFAULT FALSE,
  VulnerabilityDetails TEXT,
  PersonAlertCode VARCHAR(50),
  RiskAssessmentStatus VARCHAR(100),
  RiskAssessmentDate DATE,
  CONSTRAINT FK_HouseholdMember_Tenant FOREIGN KEY (TenantID) REFERENCES TenantPerson(TenantID),
  CONSTRAINT FK_HouseholdMember_Tenancy FOREIGN KEY (TenancyID) REFERENCES Tenancy(TenancyID)
);

----------------------------------------------------------------------------------------
-- Work Order Tables
----------------------------------------------------------------------------------------
-- Table: ContractorOrganisation
CREATE TABLE ContractorOrganisation (
    ContractorOrganisationID VARCHAR(255) PRIMARY KEY, -- Unique ID for the contractor organisation
    Name VARCHAR(255),                                -- Name of the contractor
    ContractorPortal VARCHAR(255),                    -- Portal used by the contractor
    Subcontractors TEXT                               -- List of subcontractors used
);

-- Table: WorkClass
CREATE TABLE WorkClass (
    WorkClassID VARCHAR(255) PRIMARY KEY,             -- Unique ID for the work class
    WorkClassCode VARCHAR(100),                       -- Short code for work class
    WorkClassDescription TEXT                         -- Detailed description of the work class
);

-- Table: WorkPriority
CREATE TABLE WorkPriority (
    WorkPriorityID VARCHAR(255) PRIMARY KEY,          -- Unique ID for work priority
    PriorityCode VARCHAR(100),                        -- Code representing the priority
    PriorityDescription TEXT,                         -- Description of the priority
    EffectiveDateTime TIMESTAMP,                      -- When this priority became effective
    NumberOfDays INTEGER,                             -- Number of days to resolve
    Comments TEXT,                                    -- Additional comments
    RequiredStartDateTime DATE,                       -- Required start date
    RequiredCompletionDateTime DATE                   -- Required completion date
);

-- Table: TradeCode
CREATE TABLE TradeCode (
    TradeCode VARCHAR(100) PRIMARY KEY,                    -- Standard trade code
    CustomCode VARCHAR(100),                          -- Custom code used by provider
    CustomName VARCHAR(255)                           -- Custom name for the trade
);

-- Table: RateScheduleItem
CREATE TABLE RateScheduleItem (
    RateScheduleItemID VARCHAR(255) PRIMARY KEY,      -- Unique ID for the rate schedule item
    M3NHFSORCode VARCHAR(100),                        -- M3 NHF Schedule of Rates code
    Quantity DECIMAL(10, 2),                          -- Quantity required
    CustomCode VARCHAR(100),                          -- Custom rate code
    CustomName VARCHAR(255)                           -- Custom name for rate item
);

-- Table: WorkElement
CREATE TABLE WorkElement (
    WorkElementID VARCHAR(255) PRIMARY KEY,           -- Unique ID for the work element
    WorkOrderID VARCHAR(255),                         -- FK to the associated work order
    RateScheduleItemID VARCHAR(255),                  -- FK to RateScheduleItem
    TradeCode VARCHAR(100),                           -- FK to TradeCode
    ServiceChargeSubject VARCHAR(255),                -- Subject to service charge?
    CONSTRAINT FK_WorkElement_WorkOrder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID),
    CONSTRAINT FK_WorkElement_RateScheduleItem FOREIGN KEY (RateScheduleItemID) REFERENCES RateScheduleItem(RateScheduleItemID),
    CONSTRAINT FK_WorkElement_TradeCode FOREIGN KEY (TradeCode) REFERENCES TradeCode(Code)
);

-- Table: WorkElementDependency
CREATE TABLE WorkElementDependency (
    WorkElementID VARCHAR(255),                       -- FK to dependent work element
    DependsOnWorkElementID VARCHAR(255),              -- FK to the required previous element
    Type VARCHAR(100),                                -- Type of dependency
    Timing VARCHAR(255),                              -- Timing constraint or information
    CONSTRAINT PK_WorkElementDependency PRIMARY KEY (WorkElementID, DependsOnWorkElementID),
    CONSTRAINT FK_WorkElementDependency_WorkElement FOREIGN KEY (WorkElementID) REFERENCES WorkElement(WorkElementID),
    CONSTRAINT FK_WorkElementDependency_DependsOn FOREIGN KEY (DependsOnWorkElementID) REFERENCES WorkElement(WorkElementID)
);

-- Table: WorkOrder
CREATE TABLE WorkOrder (
    WorkOrderID VARCHAR(255) PRIMARY KEY,             -- Unique ID for the work order
    WorkElementID VARCHAR(255),                       -- Possibly a representative element (optional FK)
    AddressID VARCHAR(255),                           -- FK to address
    InspectionID VARCHAR(255),                        -- FK to inspection
    EscalationID VARCHAR(255),                        -- FK to escalation event
    TenancyID VARCHAR(255),                           -- FK to tenancy
    TenantID VARCHAR(255),                            -- FK to tenant
    HazardReportID VARCHAR(255),                      -- FK to hazard report
    WorkClassID VARCHAR(255),                         -- FK to WorkClass
    LocationAlerdID VARCHAR(255),                     -- FK to location alert
    PersonAlertID VARCHAR(255),                       -- FK to person alert
    WorkPriorityID VARCHAR(255),                      -- FK to WorkPriority
    ContractorOrganisationID VARCHAR(255),            -- FK to ContractorOrganisation
    DateRaised DATE,                                  -- When the work order was raised
    DateReported DATE,                                -- When it was reported
    PlannedStartDate DATE,                            -- Planned start date
    PlannedFinishDate DATE,                           -- Planned finish date
    ActualStartDateTime TIMESTAMP,                    -- Actual start timestamp
    ActualCompletionDateTime TIMESTAMP,               -- Actual completion timestamp
    DescriptionOfWork TEXT,                           -- Detailed work description
    EstimatedCost DECIMAL(10, 2),                     -- Estimated cost of work
    EstimatedLabourHours DECIMAL(5, 2),               -- Estimated labour hours
    LocationOfRepair VARCHAR(255),                    -- Where the repair is happening
    JobStatusUpdate VARCHAR(255),                     -- Last known job status
    RepairSLABreachFlag VARCHAR(10),                  -- SLA breach indicator (Y/N/Null)
    CONSTRAINT FK_WorkOrder_WorkClass FOREIGN KEY (WorkClassID) REFERENCES WorkClass(WorkClassID),
    CONSTRAINT FK_WorkOrder_WorkPriority FOREIGN KEY (WorkPriorityID) REFERENCES WorkPriority(WorkPriorityID),
    CONSTRAINT FK_WorkOrder_ContractorOrg FOREIGN KEY (ContractorOrganisationID) REFERENCES ContractorOrganisation(ContractorOrganisationID)
);

-- Table: WorkOrderStatusHistory
CREATE TABLE WorkOrderStatusHistory (
    WorkOrderStatusHistoryID VARCHAR(255) PRIMARY KEY, -- Unique ID for each status update
    WorkOrderID VARCHAR(255),                          -- FK to the related work order
    StatusCode VARCHAR(100),                           -- Code of the current status
    UpdatedBy VARCHAR(255),                            -- Who updated it
    Reason TEXT,                                       -- Reason for this status
    ReasonCode VARCHAR(100),                           -- Code representing reason
    CreatedDateTime TIMESTAMP,                         -- When status was created
    EnteredDateTime TIMESTAMP,                         -- When status was entered
    ExistedDateTime TIMESTAMP,                         -- When status ended
    Comments TEXT,                                     -- Any extra comments
    CONSTRAINT FK_WorkOrderStatusHistory_WorkOrder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- Table: WorkOrderComplete
CREATE TABLE WorkOrderComplete (
    WorkOrderCompleteID VARCHAR(255) PRIMARY KEY,      -- Unique ID for completion record
    WorkOrderID VARCHAR(255),                          -- FK to completed work order
    BillOfMeterialItem VARCHAR(255),                   -- Bill of materials
    CompletedWorkElements TEXT,                        -- Description of completed elements
    OperativesUsed TEXT,                               -- Who completed the work
    JosStatusUpdate VARCHAR(255),                      -- Status update
    FollowOnWork VARCHAR(255),                         -- Follow-on work needed
    CONSTRAINT FK_WorkOrderComplete_WorkOrder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- Table: WorkOrderAccessInformation
CREATE TABLE WorkOrderAccessInformation (
    WorkOrderAccessInformationID VARCHAR(255) PRIMARY KEY,      -- Unique ID for access record
    WorkOrderID VARCHAR(255),                          -- FK to work order
    Description VARCHAR(100),                           -- Type of access (e.g. key, presence)
    KeySafe TEXT,                                -- Detailed access info
    CONSTRAINT FK_WorkOrderAccess_WorkOrder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- Table: AlertRegardingLocation
CREATE TABLE AlertRegardingLocation (
    LocationAlertID VARCHAR(255) PRIMARY KEY,                  -- Unique alert ID
    AlertType VARCHAR(100),                            -- Type of location alert
    Attachments TEXT,                                 -- Attachments related to the alert
    Comments TEXT,                                  -- Description of the alert
    CONSTRAINT FK_AlertLocation_WorkOrder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- Table: AlertRegardingPerson
CREATE TABLE AlertRegardingPerson (
    PersonAlertID VARCHAR(255) PRIMARY KEY,                  -- Unique alert ID
    AlertType VARCHAR(100),                            -- Type of person alert
    Comments TEXT,                                  -- Description of the alert
    CONSTRAINT FK_AlertPerson_WorkOrder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

----------------------------------------------------------------------------------------
-- Code lists
-- Scripts below create the required code lists and populate the options
-- Additional values can be added to the codelists in the values sections
----------------------------------------------------------------------------------------
-- HealthRiskRating Table
-- Code list for health risk rating levels.
CREATE TABLE HealthRiskRating (
  HealthRiskRatingID INT PRIMARY KEY IDENTITY(1, 1), 
  HealthRiskRating NVARCHAR(20) NOT NULL
);
INSERT INTO HealthRiskRating (HealthRiskRating) 
VALUES 
  ('High'), 
  ('Medium'), 
  ('Low');
-- Severity Table
-- Code list for hazard severity levels.
CREATE TABLE Severity (
  SeverityID INT PRIMARY KEY IDENTITY(1, 1), 
  Severity NVARCHAR(20) NOT NULL
);
INSERT INTO Severity (Severity) 
VALUES 
  ('High'), 
  ('Medium'), 
  ('Low');
-- InvestigationType Table
-- Code list for types of investigation.
CREATE TABLE InvestigationType (
  InvestigationTypeID INT PRIMARY KEY IDENTITY(1, 1), 
  InvestigationType NVARCHAR(20) NOT NULL
);
INSERT INTO InvestigationType (InvestigationType) 
VALUES 
  ('Standard'), 
  ('Renewed'), 
  ('Further'), 
  ('Emergency');
-- ReportStatus Table
-- Code list for report statuses.
CREATE TABLE ReportStatus (
  ReportStatusID INT PRIMARY KEY IDENTITY(1, 1), 
  ReportStatus NVARCHAR(20) NOT NULL
);
INSERT INTO ReportStatus (ReportStatus) 
VALUES 
  ('Open'), 
  ('Under Review'), 
  ('Made Safe'), 
  ('Closed');
-- TriggerSource Table
-- Code list for what triggered inspections.
CREATE TABLE TriggerSource (
  TriggerSourceID INT PRIMARY KEY IDENTITY(1, 1), 
  TriggerSource NVARCHAR(20) NOT NULL
);
INSERT INTO TriggerSource (TriggerSource) 
VALUES 
  ('Tenant Report'), 
  ('Routine Check'), 
  ('Environmental Sensor'), 
  ('Staff Report');
-- EscalationStatus Table
-- Code list for escalation statuses.
CREATE TABLE EscalationStatus (
  EscalationStatusID INT PRIMARY KEY IDENTITY(1, 1), 
  EscalationStatus NVARCHAR(20) NOT NULL
);
INSERT INTO EscalationStatus (EscalationStatus) 
VALUES 
  ('None'), 
  ('In Progress'), 
  ('Escalated');
-- NotificationType Table
-- Code list for types of notifications.
CREATE TABLE NotificationType (
  NotificationTypeID INT PRIMARY KEY IDENTITY(1, 1), 
  NotificationType NVARCHAR(20) NOT NULL
);
INSERT INTO NotificationType (NotificationType) 
VALUES 
  ('Scheduled'), 
  ('Result'), 
  ('Advice'), 
  ('Delay');
-- EscalationStage Table
-- Code list for stages in escalation lifecycle.
CREATE TABLE EscalationStage (
  EscalationStageID INT PRIMARY KEY IDENTITY(1, 1), 
  EscalationStage NVARCHAR(20) NOT NULL
);
INSERT INTO EscalationStage (EscalationStage) 
VALUES 
  ('Open'), 
  ('In Progress'), 
  ('Resolved'), 
  ('Rejected');
-- NotificationMethod Table
-- Code list for notification methods.
CREATE TABLE NotificationMethod (
  NotificationMethodID INT PRIMARY KEY IDENTITY(1, 1), 
  NotificationMethod NVARCHAR(20) NOT NULL
);
INSERT INTO NotificationMethod (NotificationMethod) 
VALUES 
  ('Email'), 
  ('SMS'), 
  ('Letter');
-- EscalationType Table
-- Code list for types of escalations.
CREATE TABLE EscalationType (
  EscalationTypeID INT PRIMARY KEY IDENTITY(1, 1), 
  EscalationType NVARCHAR(30) NOT NULL
);
INSERT INTO EscalationType (EscalationType) 
VALUES 
  ('Senior Review'), 
  ('Legal Action'), 
  ('Compensation'), 
  ('Alternative Accommodation');

-- --------------------------------------------------
-- Property Lookup Tables
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
  code VARCHAR(50) NOT NULL UNIQUE,
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


