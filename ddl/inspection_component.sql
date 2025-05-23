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
  CONSTRAINT fk_inspection_tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID), 
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
  CONSTRAINT fk_notification_tenant FOREIGN KEY (TenantID) REFERENCES Tenant(TenantID), 
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
