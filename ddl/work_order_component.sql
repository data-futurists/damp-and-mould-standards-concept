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
    CONSTRAINT FK_WorkClass_WorkClassCode FOREIGN KEY (WorkClassCodeID) 
      REFERENCES WorkClassCodes(WorkClassCodeID)
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
    CONSTRAINT FK_WorkPriority_WorkPriorityCode FOREIGN KEY (WorkPriorityCodeID) 
      REFERENCES WorkPriorityCodes(WorkPriorityCodeID)
);

-- Table: TradeCode
CREATE TABLE TradeCode (
    TradeID VARCHAR (50) PRIMARY KEY,                  -- Unique ID for the trade code
    TradeCodeID VARCHAR(50) NOT NULL,                 -- FK to trade code
    TradeCode VARCHAR(100),                           -- Standard trade code
    CustomCode VARCHAR(100),                          -- Custom code used by provider
    CustomName VARCHAR(255)                           -- Custom name for the trade
    CONSTRAINT FK_TradeCode_TradeCode FOREIGN KEY (TradeCodeID) 
      REFERENCES TradeCodes(TradeCodeID)
);

-- Table: RateScheduleItem
CREATE TABLE RateScheduleItem (
    RateScheduleItemID VARCHAR(50) PRIMARY KEY,       -- Unique ID for the rate schedule item
    RateScheduleItemCodeID VARCHAR(50),               -- FK to RateScheduleItemCode
    M3NHFSORCode VARCHAR(100),                        -- M3 NHF Schedule of Rates code
    Quantity DECIMAL(10, 2),                          -- Quantity required
    CustomCode VARCHAR(100),                          -- Custom rate code
    CustomName VARCHAR(255)                           -- Custom name for rate item
    CONSTRAINT FK_RateScheduleItem_RateScheduleItemCode FOREIGN KEY (RateScheduleItemCodeID) 
      REFERENCES RateScheduleItemCodes(RateScheduleItemCodeID)
);

-- Table: WorkElement
CREATE TABLE WorkElement (
    WorkElementID VARCHAR(50) PRIMARY KEY,            -- Unique ID for the work element
    WorkOrderID VARCHAR(50),                          -- FK to the associated work order
    RateScheduleItemID VARCHAR(255),                  -- FK to RateScheduleItem
    TradeCodeID VARCHAR(100),                         -- FK to TradeCode
    ServiceChargeSubject VARCHAR(255),                -- Subject to service charge?
    CONSTRAINT FK_WorkElement_WorkOrder FOREIGN KEY (WorkOrderID) 
      REFERENCES WorkOrder(WorkOrderID),
    CONSTRAINT FK_WorkElement_RateScheduleItem FOREIGN KEY (RateScheduleItemID) 
      REFERENCES RateScheduleItem(RateScheduleItemID),
    CONSTRAINT FK_WorkElement_TradeCode FOREIGN KEY (TradeCodeID) 
      REFERENCES TradeCodes(TradeCodeIDCode)
);

-- Table: WorkElementDependency
CREATE TABLE WorkElementDependency (
    WorkElementID VARCHAR(50) PRIMARY kEY,              -- Unique ID for the work element
    DependsOnWorkElementID VARCHAR(50),                 -- FK to the required previous element
    Type VARCHAR(100),                                  -- Type of dependency
    Timing VARCHAR(255),                                -- Timing constraint or information
    Description TEXT,                                   -- Description of the dependency
    CONSTRAINT FK_WorkElementDependency_WorkElement FOREIGN KEY (WorkElementID) 
      REFERENCES WorkElement(WorkElementID),
    CONSTRAINT FK_WorkElementDependency_DependsOn FOREIGN KEY (DependsOnWorkElementID) 
      REFERENCES WorkElement(WorkElementID)
);

-- Table: WorkOrder
CREATE TABLE WorkOrder (
    WorkOrderID VARCHAR(50) PRIMARY KEY,             -- Unique ID for the work order
    WorkElementID VARCHAR(50),                       -- Possibly a representative element (optional FK)
    AddressID VARCHAR(50),                           -- FK to address
    InspectionID VARCHAR(50),                        -- FK to inspection
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
    CONSTRAINT FK_WorkOrder_WorkClass FOREIGN KEY (WorkClassID) 
      REFERENCES WorkClass(WorkClassID),
    CONSTRAINT FK_WorkOrder_WorkPriority FOREIGN KEY (WorkPriorityID) 
      REFERENCES WorkPriority(WorkPriorityID),
    CONSTRAINT FK_WorkOrder_ContractorOrg FOREIGN KEY (ContractorOrganisationID) 
      REFERENCES ContractorOrganisation(ContractorOrganisationID)
    CONSTRAINT FK_WorkOrder_PersonAlert FOREIGN KEY (PersonAlertID) 
      REFERENCES AlertRegardingPerson(PersonAlertID),
    CONSTRAINT FK_WorkOrder_LocationAlert FOREIGN KEY (LocationAlerdID) 
      REFERENCES AlertRegardingLocation(LocationAlertID)
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
    CONSTRAINT FK_WorkOrderStatusHistory_WorkOrder FOREIGN KEY (WorkOrderID) 
      REFERENCES WorkOrder(WorkOrderID)
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
    CONSTRAINT FK_WorkOrderComplete_WorkOrder FOREIGN KEY (WorkOrderID) 
      REFERENCES WorkOrder(WorkOrderID)
);

-- Table: WorkOrderAccessInformation
CREATE TABLE WorkOrderAccessInformation (
    WorkOrderAccessInformationID VARCHAR(50) PRIMARY KEY,      -- Unique ID for access record
    WorkOrderID VARCHAR(50),                                   -- FK to work order
    Description VARCHAR(100),                                   -- Type of access (e.g. key, presence)
    KeySafe TEXT,                                                -- Detailed access info
    CONSTRAINT FK_WorkOrderAccess_WorkOrder FOREIGN KEY (WorkOrderID) 
      REFERENCES WorkOrder(WorkOrderID)
);

-- Table: AlertRegardingLocation
CREATE TABLE AlertRegardingLocation (
    LocationAlertID VARCHAR(50) PRIMARY KEY,                  -- Unique alert ID
    LocationAlertCodeID VARCHAR(50),                           -- FK to location alert code
    AlertType VARCHAR(100),                                    -- Type of location alert
    Attachments TEXT,                                          -- Attachments related to the alert
    Comments TEXT,                                             -- Description of the alert
    CONSTRAINT FK_AlertLocation_LocationAlertCode FOREIGN KEY (LocationAlertCodeID)
      REFERENCES LocationAlertTypeCodes(LocationAlertCodeID)  
);

-- Table: AlertRegardingPerson
CREATE TABLE AlertRegardingPerson (
    PersonAlertID VARCHAR(50) PRIMARY KEY,                     -- Unique alert ID
    PersonalAlertCodeID VARCHAR(50),                           -- FK to personal alert code
    AlertType VARCHAR(100),                                    -- Type of person alert
    Comments TEXT,                                             -- Description of the alert
    CONSTRAINT FK_AlertPerson_PersonalAlertCode FOREIGN KEY (PersonalAlertCodeID) 
      REFERENCES PersonalAlertTypeCodes(PersonalAlertCodeID)
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
  (3, 'Remedial', 'Follow-up work to address issues identified during a previous inspection or audit'),

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
  (15, 'Assessment', 'An inspection that would likely result in either a Demand or Maintenance Project work order'), -- UKHDS
  (16, 'Inspection', 'Routine or ad-hoc inspection that may or may not result in further work'),
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

CREATE TABLE PersonalAlertTypeCodes (
  PersonalAlertCodeID VARCHAR (50) PRIMARY KEY,
  PersonalAlertCode VARCHAR(50) NOT NULL UNIQUE,
  Description TEXT NOT NULL
);

INSERT INTO PersonAlertTypeCodes (PersonalAlertCodeID, PersonalAlertCode, Description) 
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
  (22, 'RefusedAccess', 'Tenant has refused property access for repairs or inspections'),

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
  (11, 'PastHHSRSFailure', 'Property has previously failed an HHSRS inspection'),
  (12, 'ColdProperty', 'Property struggles to retain heat, contributing to condensation and mould'),
  (13, 'VoidMouldRemediation', 'Void property requires mould remediation before re-letting'),
  (14, 'AsbestosPresent', 'Asbestos materials present — additional precautions required'),
  (15, 'RestrictedAccess', 'Restricted physical or legal access to parts of the property'),
  (16, 'FireRiskZone', 'Property is in a fire-sensitive zone or has elevated fire risk profile'),
  (17, 'AwaabsLawMonitoring', 'This location is subject to special monitoring under Awaab’s Law due to prior compliance failure');



