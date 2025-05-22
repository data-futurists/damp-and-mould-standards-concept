-- SQL DDL Script for Damp and Mould Work Order Module with Keys, Comments, and Foreign Key Constraints

CREATE TABLE WorkPriority (
    ID VARCHAR PRIMARY KEY, -- Unique ID for the priority
    PriorityCode VARCHAR, -- Priority code (e.g., Emergency, Urgent)
    PriorityDescription VARCHAR, -- Description of the priority
    EffectiveDateTime INT, -- When the priority becomes effective
    NumberOfDays INT, -- Number of days allowed to resolve
    Comments TEXT, -- Additional notes
    RequiredStartDateTime TIMESTAMP, -- Required start time for the work
    RequiredCompletionDateTime TIMESTAMP -- Required finish time for the work
);

CREATE TABLE WorkElement (
    WorkElementID VARCHAR PRIMARY KEY, -- Unique ID for the element of work
    RateScheduleItem VARCHAR, -- FK to RateScheduleItem
    ImpactedAssetReference VARCHAR, -- Reference to affected asset
    Trade INT, -- FK to TradeCode
    ServiceChargeSubject VARCHAR, -- Subject to service charge
    DependsOn VARCHAR -- Dependency on another work element
);

CREATE TABLE WorkElementDependency (
    WorkElementID VARCHAR, -- FK to WorkElement
    DependsOnWorkElement VARCHAR, -- FK to WorkElement
    Type VARCHAR, -- Type of dependency
    Timing INTERVAL, -- Delay between tasks
    PRIMARY KEY (WorkElementID, DependsOnWorkElement),
    FOREIGN KEY (WorkElementID) REFERENCES WorkElement(WorkElementID),
    FOREIGN KEY (DependsOnWorkElement) REFERENCES WorkElement(WorkElementID)
);

CREATE TABLE WorkOrder (
    WorkOrderID INT PRIMARY KEY, -- Unique ID for the work order
    WorkElementID VARCHAR, -- FK to WorkElement
    AddressID INT, -- FK to address
    InspectionID INT, -- FK to inspection record
    EscalationID INT, -- Optional FK to escalation record
    TenancyID INT, -- FK to tenancy
    TenantID INT, -- FK to tenant
    LocationAlertID VARCHAR, -- FK to AlertRegardingLocation
    PersonAlertID VARCHAR, -- FK to AlertRegardingPerson
    WorkPriorityID VARCHAR, -- FK to WorkPriority
    HazardReportID VARCHAR, -- FK to hazard report
    DateRaised DATE, -- Date raised
    DateReported DATE, -- Date reported
    PlannedStartDate DATE, -- Expected start
    PlannedFinishDate DATE, -- Expected finish
    ActualCompletionDateTime TIMESTAMP, -- Actual finish
    DescriptionOfWork TEXT, -- Work description
    EstimatedCost DECIMAL, -- Forecasted cost
    EstimatedLabourHours INT, -- Forecasted labour
    LocationOfRepair TEXT, -- Repair site
    JobStatusUpdate TEXT, -- Latest update
    SpatialLocation TEXT, -- Geolocation data

    RepairSLABreachFlag TEXT, -- SLA breach indicator
    FOREIGN KEY (WorkElementID) REFERENCES WorkElement(WorkElementID)
);

CREATE TABLE WorkOrderStatusHistory (
    WorkOrderID INT, -- FK to WorkOrder
    Status TEXT, -- Status name
    UpdatedBy TEXT, -- Updated by whom
    Timestamp TIMESTAMP, -- Timestamp of update
    Comments TEXT, -- Any comments
    PRIMARY KEY (WorkOrderID, Timestamp),
    FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

CREATE TABLE WorkOrderComplete (
    WorkOrderID VARCHAR PRIMARY KEY, -- FK to WorkOrder
    BillOfMaterialItem TEXT, -- BOM used
    CompletedWorkElements TEXT, -- List of finished elements
    OperativesUsed TEXT, -- Staff involved
    JobStatusUpdate TEXT, -- Latest update
    FollowOnWork TEXT, -- Follow-up needed?
    FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

CREATE TABLE WorkOrderAccessInformation (
    WorkOrderID VARCHAR PRIMARY KEY, -- FK to WorkOrder
    KeySafe TEXT, -- Keysafe information
    Description TEXT, -- Extra access notes
    FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID)
);

CREATE TABLE AlertRegardingLocation (
    ID VARCHAR PRIMARY KEY,
    Type TEXT, -- Type of alert
    Attachment TEXT, -- Any supporting files
    Comments TEXT -- Further detail
);

CREATE TABLE AlertRegardingPerson (
    ID VARCHAR PRIMARY KEY,
    Type TEXT, -- Type of alert
    Comments TEXT -- Further detail
);

CREATE TABLE WorkClass (
    ID VARCHAR PRIMARY KEY, -- Unique identifier for work class
    WorkClassCode VARCHAR, -- Code for class
    WorkClassDescription VARCHAR -- Description of work class
);

CREATE TABLE ContractorOrganisation (
    ID VARCHAR PRIMARY KEY, -- Unique contractor ID
    Name TEXT, -- Contractor name
    ContractorPortal TEXT, -- Portal login
    Subcontractors TEXT -- Any subcontractors used
);

CREATE TABLE TradeCode (
    Code VARCHAR PRIMARY KEY, -- Unique trade code
    CustomCode VARCHAR, -- Custom trade code
    CustomName VARCHAR -- Custom trade name
);

CREATE TABLE RateScheduleItem (
    ID VARCHAR PRIMARY KEY, -- Unique rate ID
    M3NHFSORCode VARCHAR, -- M3 NHF SOR code
    CustomCode VARCHAR, -- Custom rate code
    CustomName VARCHAR -- Custom rate name
);
