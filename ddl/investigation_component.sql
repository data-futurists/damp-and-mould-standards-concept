----------------------------------------------------------------------------------------
-- Author: George Foster (TPXImpact)
-- Email: george.foster@tpximpact.com
--
-- Scripts below create the required tables in the investigation Module
-- 
-- HazardType
-- investigationHazard
-- HazardReport
-- investigation
-- Notification
-- Escalation
----------------------------------------------------------------------------------------
-- NOTES
-- On delete or on update behaviour for the FKs? Leave for now
--
-- search todo to find rows to modify
----------------------------------------------------------------------------------------
-- Create HazardType table
-- Table storing types of hazards.
CREATE TABLE hazard_type (
  hazard_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
  hazard_type NVARCHAR(100) NOT NULL,
  health_risk_rating_id INTEGER NOT NULL,
  category NVARCHAR(500),
  CONSTRAINT fk_hazard_type_health_risk_rating FOREIGN KEY (health_risk_rating_id) REFERENCES health_risk_rating(health_risk_rating_id)
);
-- Create HazardReport table
-- Table storing hazard reports submitted.

-- how do we do communal areas
-- GIS field
CREATE TABLE hazard_report (
  hazard_report_id INTEGER PRIMARY KEY AUTOINCREMENT,
  uprn VARCHAR(50) NOT NULL,
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
  CONSTRAINT fk_hazard_report_property FOREIGN KEY (uprn) REFERENCES address(uprn),
  CONSTRAINT fk_hazard_report_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_hazard_report_investigation_type FOREIGN KEY (investigation_type_id) REFERENCES investigation_type(investigation_type_id),
  CONSTRAINT fk_hazard_report_status FOREIGN KEY (report_status_id) REFERENCES report_status(report_status_id),
  CONSTRAINT chk_emergency_action CHECK (emergency_action_taken IN (0,1)),
  CONSTRAINT chk_further_work_required CHECK (further_work_required IN (0,1)),
  CONSTRAINT chk_further_work_due_date CHECK (further_work_due_date IS NULL OR further_work_due_date >= investigation_due_date),
  CONSTRAINT chk_made_safe_date CHECK (made_safe_date IS NULL OR made_safe_date >= date_reported)
);
-- Create investigation table
-- Table storing investigation details.
CREATE TABLE investigation (
  investigation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  uprn VARCHAR(50) NOT NULL,
  tenancy_id VARCHAR(50) NOT NULL,
  hazard_report_id INTEGER NOT NULL,
  trigger_source_id INTEGER NOT NULL,
  investigation_type_id INTEGER NOT NULL,
  investigation_scheduled_date DATE,
  investigation_completed_date DATE,
  inspector_name NVARCHAR(100),
  hazard_confirmed INTEGER NOT NULL DEFAULT 0,
  repair_required INTEGER NOT NULL DEFAULT 0,
  sla_breach_flag INTEGER NOT NULL DEFAULT 0,
  notification_sent_to_tenant INTEGER NOT NULL DEFAULT 0,
  investigation_notes NVARCHAR(500),
  CONSTRAINT fk_investigation_property FOREIGN KEY (uprn) REFERENCES address(uprn),
  CONSTRAINT fk_investigation_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_investigation_hazard_report FOREIGN KEY (hazard_report_id) REFERENCES hazard_report(hazard_report_id),
  CONSTRAINT fk_investigation_trigger_source FOREIGN KEY (trigger_source_id) REFERENCES trigger_source(trigger_source_id),
  CONSTRAINT chk_hazard_confirmed CHECK (hazard_confirmed IN (0,1)),
  CONSTRAINT chk_repair_required CHECK (repair_required IN (0,1)),
  CONSTRAINT chk_sla_breach CHECK (sla_breach_flag IN (0,1)),
  CONSTRAINT chk_notification_sent_to_tenant CHECK (notification_sent_to_tenant IN (0,1)),,
  CONSTRAINT chk_investigation_scheduled_date CHECK (investigation_scheduled_date IS NULL OR investigation_scheduled_date >= hazard_reported_date),
  CONSTRAINT chk_investigation_completed_date CHECK (investigation_completed_date IS NULL OR investigation_scheduled_date IS NULL OR investigation_completed_date >= investigation_scheduled_date)
);
-- Create investigationHazard table
-- Table mapping investigations to hazards found.
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
-- Create Notification table
-- Table storing notifications related to investigations.
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
-- Create Escalation table
-- Table storing escalation actions and tracking.
CREATE TABLE escalation (
  escalation_id INTEGER PRIMARY KEY AUTOINCREMENT,
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
  CONSTRAINT fk_escalation_investigation FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id),
  CONSTRAINT fk_escalation_stage FOREIGN KEY (escalation_stage_id) REFERENCES escalation_stage(escalation_stage_id),
  CONSTRAINT fk_escalation_type FOREIGN KEY (escalation_type_id) REFERENCES escalation_type(escalation_type_id),
  CONSTRAINT chk_tenant_acceptance CHECK (tenant_acceptance IN (0,1)),
  CONSTRAINT chk_compensation_amount CHECK (compensation_amount IS NULL OR compensation_amount >= 0),
  CONSTRAINT chk_escalation_end_date CHECK (escalation_end_date IS NULL OR escalation_end_date >= escalation_start_date)
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
  ('Delay'),
  ('Escalation');
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
-- Create Inspector table
-- Table storing inspector details.
CREATE TABLE Inspector (
  InspectorID INT PRIMARY KEY IDENTITY(1, 1), 
  InspectorName NVARCHAR(100) NOT NULL, 
);