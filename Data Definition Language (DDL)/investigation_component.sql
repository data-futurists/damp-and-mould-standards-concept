----------------------------------------------------------------------------------------
-- Author: George Foster (TPXImpact)
-- Email: george.foster@tpximpact.com
-- Updated by: Elena Iurco (Data Futurists)
-- Email: elena.iurco@datafuturists.com
-- Scripts below create the required tables in the investigation Module
-- 
-- HazardType
-- investigationHazard
-- HazardReport
-- investigation
-- Notification
-- Escalation
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
  hazard_report_reference VARCHAR(36) NOT NULL,
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
-- Create investigation table
-- Table storing investigation details.
CREATE TABLE investigation (
  investigation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  investigation_reference VARCHAR(36) NOT NULL,
  uprn VARCHAR(50) NOT NULL,
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
-- Create Reference table
-- Table storing all references for hazard reports, investigations and escalations.
CREATE TABLE reference (
    id VARCHAR(36) NOT NULL PRIMARY KEY,
    allocated_by_code INTEGER NOT NULL,
    allocated_by_description VARCHAR(50) NOT NULL,
    description VARCHAR(200) NULL,
    allocated_by VARCHAR(50) NOT NULL
);

----------------------------------------------------------------------------------------
-- Code lists
-- Scripts below create the required code lists and populate the options
-- Additional values can be added to the codelists in the values sections
----------------------------------------------------------------------------------------
-- HealthRiskRating Table
-- Code list for health risk rating levels.
CREATE TABLE health_risk_rating (
  health_Risk_rating_id INT PRIMARY KEY IDENTITY(1, 1), 
  health_risk_rating NVARCHAR(20) NOT NULL
);
INSERT INTO health_risk_rating (health_risk_rating) 
VALUES 
  ('High'), 
  ('Medium'), 
  ('Low');
-- Severity Table
-- Code list for hazard severity levels.
CREATE TABLE severity (
  severity_id INT PRIMARY KEY IDENTITY(1, 1), 
  severity NVARCHAR(20) NOT NULL
);
INSERT INTO severity (severity) 
VALUES 
  ('High'), 
  ('Medium'), 
  ('Low');
-- InvestigationType Table
-- Code list for types of investigation.
CREATE TABLE investigation_type (
  investigation_type_id INT PRIMARY KEY IDENTITY(1, 1), 
  investigation_type NVARCHAR(20) NOT NULL
);
INSERT INTO investigation_type (investigation_type) 
VALUES 
  ('Standard'), 
  ('Renewed'), 
  ('Further'), 
  ('Emergency');
-- ReportStatus Table
-- Code list for report statuses.
CREATE TABLE report_status (
  report_status_id INT PRIMARY KEY IDENTITY(1, 1), 
  report_status NVARCHAR(20) NOT NULL
);
INSERT INTO report_status (report_status) 
VALUES 
  ('Open'), 
  ('Under Review'), 
  ('Made Safe'), 
  ('Closed');
-- TriggerSource Table
-- Code list for what triggered investigations.
CREATE TABLE trigger_source (
  trigger_source_id INT PRIMARY KEY IDENTITY(1, 1), 
  trigger_source NVARCHAR(20) NOT NULL
);
INSERT INTO trigger_source (trigger_Source) 
VALUES 
  ('Tenant Report'), 
  ('Routine Check'), 
  ('Environmental Sensor'), 
  ('Staff Report');
-- EscalationStatus Table
-- Code list for escalation statuses.
CREATE TABLE escalation_status (
  escalation_status_id INT PRIMARY KEY IDENTITY(1, 1), 
  escalation_status NVARCHAR(20) NOT NULL
);
INSERT INTO escalation_status (escalation_status) 
VALUES 
  ('None'), 
  ('In Progress'), 
  ('Escalated');
-- NotificationType Table
-- Code list for types of notifications.
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
-- EscalationStage Table
-- Code list for stages in escalation lifecycle.
CREATE TABLE escalation_stage (
  escalation_stage_id INT PRIMARY KEY IDENTITY(1, 1), 
  escalation_stage NVARCHAR(20) NOT NULL
);
INSERT INTO escalation_stage (escalation_stage) 
VALUES 
  ('Open'), 
  ('In Progress'), 
  ('Resolved'), 
  ('Rejected');
-- NotificationMethod Table
-- Code list for notification methods.
CREATE TABLE notification_method (
  notification_method_id INT PRIMARY KEY IDENTITY(1, 1), 
  notification_method NVARCHAR(20) NOT NULL
);
INSERT INTO notification_method (notification_method) 
VALUES 
  ('Email'), 
  ('SMS'), 
  ('Letter');
-- EscalationType Table
-- Code list for types of escalations.
CREATE TABLE escalation_type (
  escalation_type_id INT PRIMARY KEY IDENTITY(1, 1), 
  escalation_type NVARCHAR(30) NOT NULL
);
INSERT INTO escalation_type (escalation_type) 
VALUES 
  ('Senior Review'), 
  ('Legal Action'), 
  ('Compensation'), 
  ('Alternative Accommodation');
-- Create investigator table
-- Table storing investigator details.
CREATE TABLE investigator (
  investigator_id INT PRIMARY KEY IDENTITY(1, 1), 
  investigator_name NVARCHAR(100) NOT NULL, 
);