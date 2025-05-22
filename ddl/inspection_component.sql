----------------------------------------------------------------------------------------
-- Author: George Foster (TPXImpact)
-- Email: george.foster@tpximpact.com
--
-- Scripts below create the required tables in the Inspection Module
-- 
-- HazardType
-- InspectionHazard
-- HazardReport
-- Inspection
-- Notification
-- Escalation
----------------------------------------------------------------------------------------
-- NOTES
-- On delete or on update behaviour for the FKs? Leave for now
----------------------------------------------------------------------------------------

-- Create HazardType table
CREATE TABLE HazardType (
    HazardTypeID INT PRIMARY KEY IDENTITY(1,1),
    HazardType NVARCHAR(100) NOT NULL,
    HealthRiskRatingID INT NOT NULL,
    Category NVARCHAR(500) NULL,
    CONSTRAINT FK_HazardType_HealthRiskRating FOREIGN KEY (HealthRiskRatingID) REFERENCES HealthRiskRating(HealthRiskRatingID)
);

-- Create HazardReport table
CREATE TABLE HazardReport (
    HazardReportID INT PRIMARY KEY IDENTITY(1,1),
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
    CONSTRAINT FK_HazardReport_Property FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    CONSTRAINT FK_HazardReport_Tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID),
    CONSTRAINT FK_HazardReport_InvestigationType FOREIGN KEY (InvestigationTypeID) REFERENCES InvestigationType(InvestigationTypeID),
    CONSTRAINT FK_HazardReport_ReportStatus FOREIGN KEY (ReportStatusID) REFERENCES ReportStatus(ReportStatusID)
);

-- Create Inspection table
CREATE TABLE Inspection (
    InspectionID INT PRIMARY KEY IDENTITY(1,1),
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
    CONSTRAINT FK_Inspection_Property FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    CONSTRAINT FK_Inspection_Tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID),
    CONSTRAINT FK_Inspection_Tenancy FOREIGN KEY (TenancyID) REFERENCES Tenancy(TenancyID),
    CONSTRAINT FK_Inspection_TriggerSource FOREIGN KEY (TriggerSourceID) REFERENCES TriggerSource(TriggerSourceID),
    CONSTRAINT FK_Inspection_EscalationStatus FOREIGN KEY (EscalationStatusID) REFERENCES EscalationStatus(EscalationStatusID)
);

-- Create InspectionHazard table
CREATE TABLE InspectionHazard (
    InspectionHazardID INT PRIMARY KEY IDENTITY(1,1),
    HazardTypeID INT NOT NULL,
    InspectionID INT NOT NULL,
    HazardReportID INT NOT NULL,
    SeverityID INT NOT NULL,
    Notes NVARCHAR(500) NULL,
    CONSTRAINT FK_InspectionHazard_HazardType FOREIGN KEY (HazardTypeID) REFERENCES HazardType(HazardTypeID),
    CONSTRAINT FK_InspectionHazard_Inspection FOREIGN KEY (InspectionID) REFERENCES Inspection(InspectionID),
    CONSTRAINT FK_InspectionHazard_HazardReport FOREIGN KEY (HazardReportID) REFERENCES HazardReport(HazardReportID),
    CONSTRAINT FK_InspectionHazard_Severity FOREIGN KEY (SeverityID) REFERENCES Severity(SeverityID)
);

-- Create Notification table
CREATE TABLE Notification (
    NotificationID INT PRIMARY KEY IDENTITY(1,1),
    InspectionID INT NOT NULL,
    TenantID INT NOT NULL,
    WorkOrderID INT NOT NULL,
    NotificationTypeID INT NOT NULL,
    DateSent DATE NOT NULL,
    NotificationMethodID INT NOT NULL,
    ContentSummary NVARCHAR(500) NULL,
    CONSTRAINT FK_Notification_Inspection FOREIGN KEY (InspectionID) REFERENCES Inspection(InspectionID),
    CONSTRAINT FK_Notification_Tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID),
    CONSTRAINT FK_Notification_WorkOrder FOREIGN KEY (WorkOrderID) REFERENCES WorkOrder(WorkOrderID),
    CONSTRAINT FK_Notification_NotificationType FOREIGN KEY (NotificationTypeID) REFERENCES NotificationType(NotificationTypeID),
    CONSTRAINT FK_Notification_NotificationMethod FOREIGN KEY (NotificationMethodID) REFERENCES NotificationMethod(NotificationMethodID)
);

-- Create Escalation table
CREATE TABLE Escalation (
    EscalationID INT PRIMARY KEY IDENTITY(1,1),
    InspectionID INT NOT NULL,
    EscalationReason NVARCHAR(100) NULL,
    EscalationStageID INT NOT NULL,
    EscalationTypeID INT NOT NULL,
    EscalatedTo NVARCHAR(100) NOT NULL,
    EscalationStartDate DATE NOT NULL,
    EscalationEndDate DATE NULL,
    ActionTaken NVARCHAR(500) NULL,
    CompensationOffered BIT NOT NULL DEFAULT 0,
    CompensationAmount DECIMAL(10,2) NULL,
    AlternativeAccommodationOffered BIT NOT NULL DEFAULT 0,
    AlternativeAccommodationDetails NVARCHAR(500) NULL,
    TenantAcceptance BIT NOT NULL DEFAULT 0,
    EscalationNotes NVARCHAR(500) NULL,
    CONSTRAINT FK_Escalation_Inspection FOREIGN KEY (InspectionID) REFERENCES Inspection(InspectionID),
    CONSTRAINT FK_Escalation_EscalationStage FOREIGN KEY (EscalationStageID) REFERENCES EscalationStage(EscalationStageID),
    CONSTRAINT FK_Escalation_EscalationType FOREIGN KEY (EscalationTypeID) REFERENCES EscalationType(EscalationTypeID)
);


----------------------------------------------------------------------------------------
-- Code lists
-- Scripts below create the required code lists and populate the options
----------------------------------------------------------------------------------------

-- HealthRiskRating Table
CREATE TABLE HealthRiskRating (
    HealthRiskRatingID INT PRIMARY KEY IDENTITY(1,1),
    HealthRiskRating NVARCHAR(20) NOT NULL
);
INSERT INTO HealthRiskRating (HealthRiskRating)
VALUES ('High'), ('Medium'), ('Low');

-- Severity Table
CREATE TABLE Severity (
    SeverityID INT PRIMARY KEY IDENTITY(1,1),
    Severity NVARCHAR(20) NOT NULL
);
INSERT INTO Severity (Severity)
VALUES ('High'), ('Medium'), ('Low');

-- InvestigationType Table
CREATE TABLE InvestigationType (
    InvestigationTypeID INT PRIMARY KEY IDENTITY(1,1),
    InvestigationType NVARCHAR(20) NOT NULL
);
INSERT INTO InvestigationType (InvestigationType)
VALUES ('Standard'), ('Renewed'), ('Further'), ('Emergency');

-- ReportStatus Table
CREATE TABLE ReportStatus (
    ReportStatusID INT PRIMARY KEY IDENTITY(1,1),
    ReportStatus NVARCHAR(20) NOT NULL
);
INSERT INTO ReportStatus (ReportStatus)
VALUES ('Open'), ('Under Review'), ('Made Safe'), ('Closed');

-- TriggerSource Table
CREATE TABLE TriggerSource (
    TriggerSourceID INT PRIMARY KEY IDENTITY(1,1),
    TriggerSource NVARCHAR(20) NOT NULL
);
INSERT INTO TriggerSource (TriggerSource)
VALUES ('Tenant Report'), ('Routine Check'), ('Environmental Sensor'), ('Staff Report');

-- EscalationStatus Table
CREATE TABLE EscalationStatus (
    EscalationStatusID INT PRIMARY KEY IDENTITY(1,1),
    EscalationStatus NVARCHAR(20) NOT NULL
);
INSERT INTO EscalationStatus (EscalationStatus)
VALUES ('None'), ('In Progress'), ('Escalated');

-- NotificationType Table
CREATE TABLE NotificationType (
    NotificationTypeID INT PRIMARY KEY IDENTITY(1,1),
    NotificationType NVARCHAR(20) NOT NULL
);
INSERT INTO NotificationType (NotificationType)
VALUES ('Scheduled'), ('Result'), ('Advice'), ('Delay');

-- EscalationStage Table
CREATE TABLE EscalationStage (
    EscalationStageID INT PRIMARY KEY IDENTITY(1,1),
    EscalationStage NVARCHAR(20) NOT NULL
);
INSERT INTO EscalationStage (EscalationStage)
VALUES ('Open'), ('In Progress'), ('Resolved'), ('Rejected');

-- NotificationMethod Table
CREATE TABLE NotificationMethod (
    NotificationMethodID INT PRIMARY KEY IDENTITY(1,1),
    NotificationMethod NVARCHAR(20) NOT NULL
); 
INSERT INTO NotificationMethod (NotificationMethod)
VALUES ('Email'), ('SMS'), ('Letter');

-- EscalationType Table
CREATE TABLE EscalationType (
    EscalationTypeID INT PRIMARY KEY IDENTITY(1,1),
    EscalationType NVARCHAR(30) NOT NULL
);
INSERT INTO EscalationType (EscalationType)
VALUES ('Senior Review'), ('Legal Action'), ('Compensation'), ('Alternative Accommodation');