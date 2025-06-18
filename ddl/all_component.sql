----------------------------------------------------------------------------------------
-- Author(s): George Foster (TPXImpact), Rizwan Nobeebux (Data Futurists), Elena Iurco (Data Futurists)
-- Email(s): george.foster@tpximpact.com, rizwan.nobeebux@datafuturists.com, elena.iurco@datafuturists.com
--
-- Scripts below create the required tables in the investigation, Property, Tenant and Work Order Modules
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
  CONSTRAINT fk_hazardreport_tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID), 
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
-- Create investigation table
-- Table storing investigation details.
CREATE TABLE investigation (
  investigationID INT PRIMARY KEY IDENTITY(1, 1), 
  PropertyID INT NOT NULL, 
  TenantID INT NOT NULL, 
  TenancyID INT NOT NULL, 
  TriggerSourceID INT NOT NULL, 
  HazardReportedDate DATE NOT NULL, 
  investigationScheduledDate DATE NULL, 
  investigationCompletedDate DATE NULL, 
  InspectorName NVARCHAR(100) NULL, 
  HazardConfirmed BIT NOT NULL DEFAULT 0, 
  RepairRequired BIT NOT NULL DEFAULT 0, 
  RepairScheduledDate DATE NULL, 
  RepairCompletedDate DATE NULL, 
  SLABreachFlag BIT NOT NULL DEFAULT 0, 
  EscalationStatusID INT NOT NULL, 
  NotificationSentToTenant BIT NOT NULL DEFAULT 0, 
  investigationNotes NVARCHAR(500) NULL, 
  CONSTRAINT fk_investigation_property FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID), 
  CONSTRAINT fk_investigation_tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID), 
  CONSTRAINT fk_investigation_tenancy FOREIGN KEY (TenancyID) REFERENCES Tenancy(TenancyID), 
  CONSTRAINT fk_investigation_triggersource FOREIGN KEY (TriggerSourceID) REFERENCES TriggerSource(TriggerSourceID), 
  CONSTRAINT fk_investigation_escalationstatus FOREIGN KEY (EscalationStatusID) REFERENCES EscalationStatus(EscalationStatusID), 
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
  CONSTRAINT chk_investigation_scheduled_date CHECK (
    investigationScheduledDate IS NULL 
    OR investigationScheduledDate >= HazardReportedDate
  ), 
  CONSTRAINT chk_investigation_completed_date CHECK (
    investigationCompletedDate IS NULL 
    OR investigationScheduledDate IS NULL 
    OR investigationCompletedDate >= investigationScheduledDate
  )
);
-- Create investigationHazard table
-- Table mapping investigations to hazards found.
CREATE TABLE investigationHazard (
  investigationHazardID INT PRIMARY KEY IDENTITY(1, 1), 
  HazardTypeID INT NOT NULL, 
  investigationID INT NOT NULL, 
  HazardReportID INT NOT NULL, 
  SeverityID INT NOT NULL, 
  Notes NVARCHAR(500) NULL, 
  CONSTRAINT fk_investigationhazard_hazardtype FOREIGN KEY (HazardTypeID) REFERENCES HazardType(HazardTypeID), 
  CONSTRAINT fk_investigationhazard_investigation FOREIGN KEY (investigationID) REFERENCES investigation(investigationID), 
  CONSTRAINT fk_investigationhazard_hazardreport FOREIGN KEY (HazardReportID) REFERENCES HazardReport(HazardReportID), 
  CONSTRAINT fk_investigationhazard_severity FOREIGN KEY (SeverityID) REFERENCES Severity(SeverityID)
);
-- Create Notification table
-- Table storing notifications related to investigations.
CREATE TABLE Notification (
  NotificationID INT PRIMARY KEY IDENTITY(1, 1), 
  investigationID INT NOT NULL, 
  TenantID INT NOT NULL, 
  WorkOrderID INT NOT NULL, 
  NotificationTypeID INT NOT NULL, 
  DateSent DATE NOT NULL, 
  NotificationMethodID INT NOT NULL, 
  ContentSummary NVARCHAR(500) NULL, 
  CONSTRAINT fk_notification_investigation FOREIGN KEY (investigationID) REFERENCES investigation(investigationID), 
  CONSTRAINT fk_notification_tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID), 
  CONSTRAINT fk_notification_workorder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID), 
  CONSTRAINT fk_notification_notificationtype FOREIGN KEY (NotificationTypeID) REFERENCES NotificationType(NotificationTypeID), 
  CONSTRAINT fk_notification_notificationmethod FOREIGN KEY (NotificationMethodID) REFERENCES NotificationMethod(NotificationMethodID)
);
-- Create Escalation table
-- Table storing escalation actions and tracking.
CREATE TABLE Escalation (
  EscalationID INT PRIMARY KEY IDENTITY(1, 1), 
  investigationID INT NOT NULL, 
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
  CONSTRAINT fk_escalation_investigation FOREIGN KEY (investigationID) REFERENCES investigation(investigationID), 
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
CREATE TABLE Tenant (
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
  CONSTRAINT FK_Tenancy_Tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID)
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
  CONSTRAINT FK_HouseholdMember_Tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID),
  CONSTRAINT FK_HouseholdMember_Tenancy FOREIGN KEY (TenancyID) REFERENCES Tenancy(TenancyID)
);

----------------------------------------------------------------------------------------
-- Work Order Tables
----------------------------------------------------------------------------------------
-- --------------------------------------------------
-- WorkOrder Main Tables
-- --------------------------------------------------

-- Table: ContractorOrganisation
CREATE TABLE ContractorOrganisation (
    ContractorOrganisationID VARCHAR(50) PRIMARY KEY, -- Unique ID for the contractor organisation
    Name VARCHAR(100),                                -- Name of the contractor
    ContractorPortal VARCHAR(255),                    -- Portal used by the contractor
    Subcontractors TEXT                               -- List of subcontractors used
);

-- Table: WorkClass
CREATE TABLE WorkClass (
    WorkClassID VARCHAR(50) PRIMARY KEY,              -- Unique ID for the work class
    WorkClassCodeID VARCHAR(50),                      -- FK to work class code         
    WorkClassCode VARCHAR(100),                       -- Short code for work class
    WorkClassDescription TEXT                         -- Detailed description of the work class
    CONSTRAINT FK_WorkClass_WorkClassCode 
      FOREIGN KEY (WorkClassCodeID) REFERENCES WorkClassCodes(WorkClassCodeID)
);                     

-- Table: WorkPriority
CREATE TABLE WorkPriority (
    WorkPriorityID VARCHAR(50) PRIMARY KEY,           -- Unique ID for work priority
    WorkPriorityCodeID VARCHAR(50),                   -- FK to work priority code
    WorkPriorityCode VARCHAR(100),                    -- Code representing the priority
    WorkPriorityDescription TEXT,                     -- Description of the priority
    EffectiveDateTime TIMESTAMP,                      -- When this priority became effective
    NumberOfDays INTEGER,                             -- Number of days to resolve
    Comments TEXT,                                    -- Additional comments
    RequiredStartDateTime DATE,                       -- Required start date
    RequiredCompletionDateTime DATE                   -- Required completion date
    CONSTRAINT FK_WorkPriority_WorkPriorityCode 
      FOREIGN KEY (WorkPriorityCodeID) REFERENCES WorkPriorityCodes(WorkPriorityCodeID)
);
-- Table: RateScheduleItem
CREATE TABLE RateScheduleItem (
    RateScheduleItemID VARCHAR(50) PRIMARY KEY,       -- Unique ID for the rate schedule item
    RateScheduleItemCodeID VARCHAR(50),               -- FK to RateScheduleItemCode
    M3NHFSORCode VARCHAR(100),                        -- M3 NHF Schedule of Rates code
    Quantity DECIMAL(10, 2),                          -- Quantity required
    CustomCode VARCHAR(100),                          -- Custom rate code
    CustomName VARCHAR(255)                           -- Custom name for rate item
    CONSTRAINT FK_RateScheduleItem_RateScheduleItemCode 
      FOREIGN KEY (RateScheduleItemCodeID) REFERENCES RateScheduleItemCodes(RateScheduleItemCodeID)
);

-- Table: WorkElement
CREATE TABLE WorkElement (
    WorkElementID VARCHAR(50) PRIMARY KEY,            -- Unique ID for the work element
    WorkOrderID VARCHAR(50),                          -- FK to the associated work order
    RateScheduleItemID VARCHAR(255),                  -- FK to RateScheduleItem
    TradeCodeID VARCHAR(100),                         -- FK to TradeCode
    ServiceChargeSubject VARCHAR(255),                -- Subject to service charge?
    CONSTRAINT FK_WorkElement_WorkOrder 
      FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID),

    CONSTRAINT FK_WorkElement_RateScheduleItem 
      FOREIGN KEY (RateScheduleItemID) REFERENCES RateScheduleItem(RateScheduleItemID),
    
    CONSTRAINT FK_WorkElement_TradeCode 
      FOREIGN KEY (TradeCodeID) REFERENCES TradeCodes(TradeCodeID)
);

-- Table: WorkElementDependency
CREATE TABLE WorkElementDependency (
    WorkElementID VARCHAR(50) PRIMARY kEY,              -- Unique ID for the work element
    DependsOnWorkElementID VARCHAR(50),                 -- FK to the required previous element
    Type VARCHAR(100),                                  -- Type of dependency
    Timing VARCHAR(255),                                -- Timing constraint or information
    Description TEXT,                                   -- Description of the dependency
    CONSTRAINT FK_WorkElementDependency_WorkElement 
      FOREIGN KEY (WorkElementID) REFERENCES WorkElement(WorkElementID),

    CONSTRAINT FK_WorkElementDependency_DependsOn 
      FOREIGN KEY (DependsOnWorkElementID) REFERENCES WorkElement(WorkElementID)
);

-- Table: WorkOrder
CREATE TABLE WorkOrder (
    WorkOrderID VARCHAR(50) PRIMARY KEY,             -- Unique ID for the work order
    WorkElementID VARCHAR(50),                       -- Possibly a representative element (optional FK)
    AddressID VARCHAR(50),                           -- FK to address
    investigationID VARCHAR(50),                        -- FK to investigation
    EscalationID VARCHAR(50),                        -- FK to escalation event
    TenancyID VARCHAR(50),                           -- FK to tenancy
    TenantID VARCHAR(50),                            -- FK to tenant
    HazardReportID VARCHAR(50),                      -- FK to hazard report
    WorkClassID VARCHAR(50),                         -- FK to WorkClass
    LocationAlerdID VARCHAR(50),                     -- FK to location alert
    PersonAlertID VARCHAR(50),                       -- FK to person alert
    WorkPriorityID VARCHAR(50),                      -- FK to WorkPriority
    ContractorOrganisationID VARCHAR(50),            -- FK to ContractorOrganisation
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
    CONSTRAINT fk_WorkOrder_WorkClassID
      FOREIGN KEY (WorkClassID) REFERENCES WorkClass(WorkClassID),

    CONSTRAINT fk_WorkOrder_WorkPriorityID
      FOREIGN KEY (WorkPriorityID) REFERENCES WorkPriority(WorkPriorityID),

    CONSTRAINT fk_WorkOrder_ContractorOrganisationID
      FOREIGN KEY (ContractorOrganisationID) REFERENCES ContractorOrganisation(ContractorOrganisationID),

    CONSTRAINT fk_WorkOrder_LocationAlertID
      FOREIGN KEY (LocationAlertID) REFERENCES AlertRegardingLocation(LocationAlertID),

    CONSTRAINT fk_WorkOrder_PersonAlertID
      FOREIGN KEY (PersonAlertID) REFERENCES AlertRegardingPerson(PersonAlertID),

    CONSTRAINT fk_WorkOrder_AddressID
      FOREIGN KEY (AddressID) REFERENCES address(address_id),

    CONSTRAINT fk_WorkOrder_investigationID
      FOREIGN KEY (investigationID) REFERENCES investigation(investigationID),

    CONSTRAINT fk_WorkOrder_EscalationID
      FOREIGN KEY (EscalationID) REFERENCES Escalation(EscalationID),

    CONSTRAINT fk_WorkOrder_TenancyID
     FOREIGN KEY (TenancyID) REFERENCES Tenancy(TenancyID),

    CONSTRAINT fk_WorkOrder_TenantID
      FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID),

    CONSTRAINT fk_WorkOrder_HazardReportID
      FOREIGN KEY (HazardReportID) REFERENCES HazardReport(HazardReportID)

);

-- Table: WorkOrderStatusHistory
CREATE TABLE WorkOrderStatusHistory (
    WorkOrderStatusHistoryID VARCHAR(50) PRIMARY KEY, -- Unique ID for each status update
    WorkOrderID VARCHAR(50),                          -- FK to the related work order
    StatusCode VARCHAR(100),                           -- Code of the current status
    UpdatedBy VARCHAR(255),                            -- Who updated it
    Reason TEXT,                                       -- Reason for this status
    ReasonCode VARCHAR(100),                           -- Code representing reason
    CreatedDateTime TIMESTAMP,                         -- When status was created
    EnteredDateTime TIMESTAMP,                         -- When status was entered
    ExistedDateTime TIMESTAMP,                         -- When status ended
    Comments TEXT,                                     -- Any extra comments
    CONSTRAINT FK_WorkOrderStatusHistory_WorkOrder 
      FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- Table: WorkOrderComplete
CREATE TABLE WorkOrderComplete (
    WorkOrderCompleteID VARCHAR(50) PRIMARY KEY,      -- Unique ID for completion record
    WorkOrderID VARCHAR(50),                          -- FK to completed work order
    BillOfMeterialItem VARCHAR(255),                   -- Bill of materials
    CompletedWorkElements TEXT,                        -- Description of completed elements
    OperativesUsed TEXT,                               -- Who completed the work
    JosStatusUpdate VARCHAR(255),                      -- Status update
    FollowOnWork VARCHAR(255),                         -- Follow-on work needed
    CONSTRAINT FK_WorkOrderComplete_WorkOrder 
      FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- Table: WorkOrderAccessInformation
CREATE TABLE WorkOrderAccessInformation (
    WorkOrderAccessInformationID VARCHAR(50) PRIMARY KEY,      -- Unique ID for access record
    WorkOrderID VARCHAR(50),                                   -- FK to work order
    Description VARCHAR(100),                                   -- Type of access (e.g. key, presence)
    KeySafe TEXT,                                                -- Detailed access info
    CONSTRAINT FK_WorkOrderAccess_WorkOrder 
      FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

-- Table: AlertRegardingLocation
CREATE TABLE AlertRegardingLocation (
    LocationAlertID VARCHAR(50) PRIMARY KEY,                  -- Unique alert ID
    LocationAlertCodeID VARCHAR(50),                           -- FK to location alert code
    AlertType VARCHAR(100),                                    -- Type of location alert
    Attachments TEXT,                                          -- Attachments related to the alert
    Comments TEXT,                                             -- Description of the alert
    CONSTRAINT FK_AlertLocation_LocationAlertCode 
      FOREIGN KEY (LocationAlertCodeID) REFERENCES LocationAlertTypeCodes(LocationAlertCodeID)  
);

-- Table: AlertRegardingPerson
CREATE TABLE AlertRegardingPerson (
    PersonAlertID VARCHAR(50) PRIMARY KEY,                     -- Unique alert ID
    PersonAlertCodeID VARCHAR(50),                           -- FK to personal alert code
    AlertType VARCHAR(100),                                    -- Type of person alert
    Comments TEXT,                                             -- Description of the alert
    CONSTRAINT FK_AlertPerson_PersonAlertCode 
      FOREIGN KEY (PersonAlertCodeID) REFERENCES PersonAlertTypeCodes(PersonAlertCodeID)
);

-- --------------------------------------------------
-- WorkOrder Lookup Codes Tables
-- --------------------------------------------------
CREATE TABLE WorkClassCodes (
  WorkClassCodeID VARCHAR (50) PRIMARY KEY,
  WorkClassCode VARCHAR(50) NOT NULL UNIQUE,
  Description TEXT NOT NULL
);

INSERT INTO WorkClassCodes (WorkClassCodeID, WorkClassCode, Description) 
VALUES
  -- Immediate / Urgent Response
  (1, 'Emergency', 'Immediate response required to prevent danger to life or significant property damage'),
  (2, 'Defect', 'A defect that is to be repaired/corrected under warranty (either original builder''s warranty, manufacturer''s warranty, or seller''s warranty)'), -- UKHDS
  (3, 'Urgent', 'Work that requires immediate attention but is not classified as an emergency'),
  (3, 'Remedial', 'Follow-up work to address issues identified during a previous investigation or audit'),

  -- Statutory & Regulatory
  (4, 'Statutory', 'Work undertaken to comply with statutory or regulatory obligations'),
  (5, 'EnvironmentalHealthOrder', 'Repairs mandated by a local authority or environmental health enforcement'),
  (6, 'InsuranceClaim', 'Work triggered by a damage claim under property insurance'),

  -- Planned & Preventative
  (7, 'PreventativePlanned', 'Scheduled or in response to instrumented testing and analysis'), -- UKHDS
  (8, 'Routine', 'Regularly scheduled work not classified as preventative or emergency'),
  (9, 'Upgrade', 'Planned work to improve existing systems or components, not repair'),
  (10, 'TenantRequestedUpgrade', 'Enhancements or non-essential work requested by the tenant'),

  -- Property Lifecycle & Major Works
  (11, 'MaintenanceProject', 'Multi-faceted facility repair or renewal project'), -- UKHDS
  (12, 'VoidWork', 'Work required to bring a property up to standard between tenancies'),
  (13, 'DecantSupport', 'Work related to supporting tenant relocation due to major repairs or redevelopment'),
  (14, 'MoveManagement', 'Personnel relocation'), -- UKHDS

  -- Assessment & Diagnostics
  (15, 'Assessment', 'An investigation that would likely result in either a Demand or Maintenance Project work order'), -- UKHDS
  (16, 'investigation', 'Routine or ad-hoc investigation that may or may not result in further work'),
  (17, 'Survey', 'Technical assessment such as stock condition, energy performance, or asbestos'),

  -- Demand-Based
  (18, 'Demand', 'In response to a request'), -- UKHDS

  -- Fallback
  (19, 'Other', 'Work Classification items not covered by a specific code'); -- UKHDS

  
CREATE TABLE WorkPriorityCodes (
  WorkPriorityCodeID VARCHAR (50) PRIMARY KEY,
  WorkPriortityCode VARCHAR(20) NOT NULL UNIQUE,
  description TEXT NOT NULL
);

INSERT INTO WorkPriorityCodes (WorkPriorityCodeID, WorkPriorityCode, Description) 
VALUES
  (1, 'Immediate', 'Critical safety issue requiring response within hours'),
  (2, 'Emergency', 'Emergency - immediate, maximum 1 day'), -- UKHDS
  (3, 'High', 'High - as soon as possible, typically within 1 day, maximum 2 days'), -- UKHDS
  (4, 'Medium', 'Medium - plan and schedule with other priorities, typically maximum 7 days'), -- UKHDS
  (5, 'Low', 'Low - as fits into schedule, typically a maximum 30 days'), -- UKHDS
  (6, 'Deferred', 'Deferred - typically will not fit into the work schedule, maximum e.g. 1 year'), -- UKHDS
  (7, 'Routine', 'Routine task - no urgency but should be completed'),
  (8, 'Scheduled', 'Scheduled - maintenance or works planned for a specific date range'),
  (9, 'Statutory', 'Statutory - required for compliance with legal regulations'),
  (10, 'Reactive', 'Reactive - unplanned work in response to faults or failures');

CREATE TABLE TradeCodes (
  TradeCodeID VARCHAR (50) PRIMARY KEY,
  TradeCode VARCHAR(100) NOT NULL UNIQUE,
  CustomCode VARCHAR(100),                          -- Custom code used by provider
  CustomName VARCHAR(255)                           -- Custom name for the trade
  Description VARCHAR(100) NOT NULL
);

INSERT INTO TradeCodes (TradeCodeID, TradeCode, Description) 
VALUES
-- all from UKHDS
  (1, 'Asphalter', 'Asphalter'),
  (2, 'Bricklayer', 'Bricklayer'),
  (3, 'BricklayingGang', 'Bricklaying gang'),
  (4, 'CarpenterJoiner', 'Carpenter and joiner'),
  (5, 'CarpentryGang', 'Carpentry gang'),
  (6, 'CleanTeam', 'Cleaning or clearance team'),
  (7, 'CleanVoid', 'Cleaning and clearing - void property'),
  (8, 'CleanGang', 'Cleaning gang'),
  (9, 'CleanOperative', 'Cleaning operative'),
  (10, 'DisabledAdaptation', 'Disabled adaptation multi-skilled operative'),
  (11, 'DrainLayer', 'Drainlayer'),
  (12, 'ELECENG', 'Electrical engineer'),
  (13, 'ELEC', 'Electrician'),
  (14, 'ELECGANG', 'Electrician gang'),
  (15, 'ELECOP', 'Electrician operative'),
  (16, 'Fencer', 'Fencer'),
  (17, 'FloorLayer', 'Floorlayer'),
  (18, 'Glazier', 'Glazier'),
  (19, 'GroundWorker', 'Ground worker'),
  (20, 'GroundsMGardener', 'Grounds maintenance - gardener'),
  (21, 'MOWGRASS', 'Grounds maintenance - mow/cut grass'),
  (22, 'REMGRASS', 'Grounds maintenance - remove grass by hand'),
  (23, 'REMLIT', 'Grounds maintenance - remove litter'),
  (24, 'GRAVEL', 'Grounds maintenance - replace gravel margins'),
  (25, 'RUBBISH', 'Grounds maintenance - rubbish/refuse'),
  (26, 'GRNDGRP', 'Grounds maintenance gang'),
  (27, 'GRNDOP', 'Grounds maintenance operative'),
  (28, 'HEATENG', 'Heating engineer'),
  (29, 'HEATGASENG', 'Heating/Gas engineer'),
  (30, 'MECHENG', 'Mechanical engineer'),
  (31, 'MECHLIFT', 'Mechanical engineer - lift contract/care'),
  (32, 'MULTISKILLOP', 'Multi-skilled operative'),
  (33, 'MULTSKILLOPGEN', 'Multi-skilled operative - general'),
  (34, 'MULTSKILLOPHANDY', 'Multi-skilled operative - handyman'),
  (35, 'Painter', 'Painter and decorator'),
  (36, 'PaintGang', 'Painting/Decorator gang'),
  (37, 'Plasterer', 'Plasterer'),
  (38, 'Plumber', 'Plumber'),
  (39, 'PlumberDrain', 'Plumber - plumbing/drainage'),
  (40, 'PlumberWaterStorage', 'Plumber - water storage'),
  (41, 'PlumberGang', 'Plumber gang'),
  (42, 'Roofer', 'Roofer'),
  (43, 'RooferFlat', 'Roofer - roofing flat'),
  (44, 'RooferPitch', 'Roofer - roofing pitched'),
  (45, 'RoofGang', 'Roofing gang'),
  (46, 'SPEC', 'Specialist'),
  (47, 'SPECASBT', 'Specialist - asbestos'),
  (48, 'SPECCCTV', 'Specialist - CCTV'),
  (49, 'SPECDIGI', 'Specialist - digital aerials'),
  (50, 'SPECDOOR', 'Specialist - door entry'),
  (51, 'SPECELPL', 'Specialist - electrician/plumber'),
  (52, 'SPECEMLIGHT', 'Specialist - emergency lighting'),
  (53, 'SPECFIRE', 'Specialist - fire safety'),
  (54, 'SPECLIGHTCOND', 'Specialist - lightning conductors'),
  (55, 'SPECPEST', 'Specialist - pest control'),
  (56, 'SPECRENEW', 'Specialist - renewables'),
  (57, 'SPECSCAFF', 'Specialist - scaffolding'),
  (58, 'SPECSEC', 'Specialist - security'),
  (59, 'SPECUPVC', 'Specialist - UPVC'),
  (60, 'StoneMason', 'Stone mason'),
  (61, 'TILER', 'Tiler wall and floor');

CREATE TABLE RateScheduleItemCodes (
  RateScheduleItemCodeID VARCHAR (50) PRIMARY KEY,
  RateScheduleItemCode VARCHAR(10) NOT NULL UNIQUE,
  Description VARCHAR(100) NOT NULL
);
-- need to add the actual codes --

CREATE TABLE PersonAlertTypeCodes (
  PersonAlertCodeID VARCHAR (50) PRIMARY KEY,
  PersonAlertCode VARCHAR(50) NOT NULL UNIQUE,
  Description TEXT NOT NULL
);

INSERT INTO PersonAlertTypeCodes (PersonAlertCodeID, PersonAlertCode, Description) 
VALUES
-- From UKHDS
  (1, 'NoVisitAlone', 'Do not visit alone'),
  (2, 'ASBNoVisitAlone', 'Do not visit alone: anti-social behaviour'),
  (3, 'DisablityVulnerablity', 'Disability, vulnerability'),
  (4, 'HearingDifficult', 'Person has hearing difficulties'),
  (5, 'VisionImpaired', 'Person has impaired vision'),
  (6, 'Illness', 'Person has illness'),
  (7, 'PhysicalSupport', 'Person requires physical support'),
  (8, 'Wheelchair', 'Person requires wheelchair'),
  (9, 'Elderly', 'Person is elderly'),
  (10, 'SafeguardOther', 'Other safeguarding alert'),
  (11, 'MissesAppointments', 'Person regularly misses appointments'),
  (12, 'LanguageSupport', 'Person may not be fluent in English'),
  (13, 'LimitedCapacity', 'This person does not have the capacity to make all decisions themselves due to the existence of one or more registered Lasting Power of Attorney'),
 -- New codes
  (14, 'Respiratory', 'Person has a diagnosed respiratory condition (e.g. asthma, COPD)'),
  (15, 'ImmunoCompromise', 'Person has a weakened immune system (e.g. cancer treatment, autoimmune diseases)'),
  (16, 'Infant', 'Infant or very young child in the household'),
  (17, 'Pregnant', 'Pregnant person resides at the property'),
  (18, 'MentalHealth', 'Person has mental health conditions that may be worsened by poor housing'),
  (19, 'LowIncome', 'Household is on low income and may face barriers to heating or ventilation'),
  (20, 'ChildProtection', 'Child at risk or under child protection services'),
  (21, 'DomesticViolence', 'Person is a victim of domestic violence or abuse'),
  (22, 'RefusedAccess', 'Tenant has refused property access for repairs or investigations'),

CREATE TABLE LocationAlertTypeCodes (
  LocationAlertCodeID VARCHAR (50) PRIMARY KEY,
  LocationAlertCode VARCHAR(50) NOT NULL UNIQUE,
  Description TEXT NOT NULL
);
-- from UKHDS
  INSERT INTO LocationAlertTypeCodes (LocationAlertCodeID, LocationAlertCode, Description)
VALUES
  (1, 'Warranty', 'There may be a warranty applicable to this location'),
  (2, 'NonMainsSewage', 'The sewage does not go to a main sewer - for example there is a septic tank or mini-treatment plant'),
  (3, 'Comments', 'Please see comments included for details of alert'),
  (4, 'ContactForDetails', 'Please contact the instructing party/client contact to obtain details of alerts regarding this location'),
  (5, 'OperativeGenderRestriction', 'This location has restrictions on the gender of the operative(s) who may attend. See the AlertRegardingLocation comments for details of this restriction.'),
  (6, 'HeritageBuilding', 'Information about Heritage or Listed Building status of this location'),
 -- New codes
  (7, 'RecurringDamp', 'Property has a history of recurring damp and mould issues'),
  (8, 'HealthRiskOccupants', 'One or more occupants are at high health risk from damp or poor air quality'),
  (9, 'PoorVentilation', 'Location has inadequate natural or mechanical ventilation'),
  (10, 'StructuralIssues', 'Structural conditions (e.g. cracks, leaks) increase damp/mould risk'),
  (11, 'PastHHSRSFailure', 'Property has previously failed an HHSRS investigation'),
  (12, 'ColdProperty', 'Property struggles to retain heat, contributing to condensation and mould'),
  (13, 'VoidMouldRemediation', 'Void property requires mould remediation before re-letting'),
  (14, 'AsbestosPresent', 'Asbestos materials present — additional precautions required'),
  (15, 'RestrictedAccess', 'Restricted physical or legal access to parts of the property'),
  (16, 'FireRiskZone', 'Property is in a fire-sensitive zone or has elevated fire risk profile'),
  (17, 'AwaabsLawMonitoring', 'This location is subject to special monitoring under Awaab’s Law due to prior compliance failure');









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
-- Code list for what triggered investigations.
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


