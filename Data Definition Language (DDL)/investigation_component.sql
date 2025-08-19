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
  hazard_type VARCHAR(100) NOT NULL,
  health_risk_rating_id INTEGER NOT NULL,
  category VARCHAR(500),
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
  hazard_type_id INTEGER NOT NULL,
  date_reported DATE NOT NULL,
  reported_by_id INTEGER NOT NULL,
  description VARCHAR(500),
  location_details VARCHAR(500),
  emergency_action_taken INTEGER NOT NULL DEFAULT 0,
  made_safe_date DATE,
  report_status_id INTEGER NOT NULL,
  CONSTRAINT fk_hazard_report_reference FOREIGN KEY (hazard_report_reference) REFERENCES reference(id),
  CONSTRAINT fk_hazard_report_property FOREIGN KEY (uprn) REFERENCES address(uprn),
  CONSTRAINT fk_hazard_report_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_hazard_report_investigation_type FOREIGN KEY (investigation_type_id) REFERENCES investigation_type(investigation_type_id),
  CONSTRAINT fk_hazard_report_status FOREIGN KEY (report_status_id) REFERENCES report_status(report_status_id),
  CONSTRAINT chk_emergency_action CHECK (emergency_action_taken IN (0,1)),
  CONSTRAINT chk_made_safe_date CHECK (made_safe_date IS NULL OR made_safe_date >= date_reported)
  CONSTRAINT fk_hazard_report_hazard_type FOREIGN KEY (hazard_type_id) REFERENCES hazard_type(hazard_type_id),
  CONSTRAINT fk_reported_by FOREIGN KEY (reported_by_id) REFERENCES person(person_id),
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
  repair_required INTEGER NOT NULL DEFAULT 0,
  sla_breach_flag INTEGER NOT NULL DEFAULT 0,
  notification_sent_to_tenant INTEGER NOT NULL DEFAULT 0,
  investigation_notes VARCHAR(500),
  CONSTRAINT fk_investigation_reference FOREIGN KEY (investigation_reference) REFERENCES reference(id),
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
  notes VARCHAR(500),
  CONSTRAINT fk_investigation_hazard_type FOREIGN KEY (hazard_type_id) REFERENCES hazard_type(hazard_type_id),
  CONSTRAINT fk_investigation_hazard_investigation FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id),
  CONSTRAINT fk_investigation_hazard_report FOREIGN KEY (hazard_report_id) REFERENCES hazard_report(hazard_report_id),
  CONSTRAINT fk_investigation_hazard_severity FOREIGN KEY (severity_id) REFERENCES severity(severity_id)
);
-- Create Notification table
-- Table storing notifications related to investigations.
CREATE TABLE notification (
  notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
  investigation_id INTEGER NULL,
  tenancy_id INTEGER NOT NULL,
  work_order_id INTEGER NULL,
  notification_type_id INTEGER NOT NULL,
  escalation_id INTEGER NULL,
  date_sent DATE NOT NULL,
  communication_method_id INTEGER NOT NULL,
  content_summary VARCHAR(500),
  CONSTRAINT fk_notification_investigation FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id),
  CONSTRAINT fk_notification_tenancy FOREIGN KEY (tenancy_id) REFERENCES tenancy(tenancy_id),
  CONSTRAINT fk_notification_work_order FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id),
  CONSTRAINT fk_notification_type FOREIGN KEY (notification_type_id) REFERENCES notification_type(notification_type_id),
  CONSTRAINT fk_notification_escalation FOREIGN KEY (escalation_id) REFERENCES escalation(escalation_id),
  CONSTRAINT fk_notification_method FOREIGN KEY (notification_method_id) REFERENCES communication_method(notification_method_id)
);

CREATE TABLE communication (
    communication_id INTEGER PRIMARY KEY AUTOINCREMENT,
    notification_id INTEGER NULL,  -- optional link to a system notification
    hazard_report_id INTEGER NULL, -- optional link to a hazard report
    investigation_id INTEGER NULL, -- optional link to an investigation
    tenancy_id VARCHAR(50) NOT NULL,
    sender_type VARCHAR(20) NOT NULL CHECK (sender_type IN ('Tenant', 'Landlord', 'System')),
    sender_id INTEGER NULL,        -- links to person table if applicable
    receiver_type VARCHAR(20) NOT NULL CHECK (receiver_type IN ('Tenant', 'Landlord', 'System')),
    receiver_id INTEGER NULL,      -- links to person table if applicable
    communication_method_id INTEGER NOT NULL, -- e.g., email, WhatsApp, call
    communication_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    content_summary VARCHAR(500),
    media_id INTEGER NULL,         -- optional link to media table
    CONSTRAINT fk_communication_notification FOREIGN KEY (notification_id)
        REFERENCES notification(notification_id),
    CONSTRAINT fk_communication_hazard_report FOREIGN KEY (hazard_report_id)
        REFERENCES hazard_report(hazard_report_id),
    CONSTRAINT fk_communication_investigation FOREIGN KEY (investigation_id)
        REFERENCES investigation(investigation_id),
    CONSTRAINT fk_communication_sender FOREIGN KEY (sender_id)
        REFERENCES person(person_id),
    CONSTRAINT fk_communication_receiver FOREIGN KEY (receiver_id)
        REFERENCES person(person_id),
    CONSTRAINT fk_communication_method FOREIGN KEY (communication_method_id)
        REFERENCES communication_method(communication_method_id),
    CONSTRAINT fk_communication_media FOREIGN KEY (media_id)
        REFERENCES media(media_id)
);

-- Create Escalation table
-- Table storing escalation actions and tracking.
CREATE TABLE escalation (
  escalation_id INTEGER PRIMARY KEY AUTOINCREMENT,
  escalation_reference VARCHAR(36) NOT NULL,
  investigation_id INTEGER NOT NULL,
  escalation_reason VARCHAR(100),
  escalation_stage_id INTEGER NOT NULL,
  escalation_type_id INTEGER NOT NULL,
  escalated_to VARCHAR(100) NOT NULL,
  escalation_start_date DATE NOT NULL,
  escalation_end_date DATE,
  action_taken VARCHAR(500),
  compensation_amount DECIMAL(10,2),
  alternative_accommodation_details VARCHAR(500),
  tenant_acceptance INTEGER NOT NULL DEFAULT 0,
  escalation_notes VARCHAR(500),
  CONSTRAINT fk_escalation_reference FOREIGN KEY (escalation_reference) REFERENCES reference(id),
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
    id INTEGER PRIMARY KEY AUTOINCREMENT,
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
  health_Risk_rating_id INTEGER PRIMARY  KEY AUTOINCREMENT, 
  health_risk_rating VARCHAR(20) NOT NULL
);
INSERT INTO health_risk_rating (health_risk_rating) 
VALUES 
  ('High'), 
  ('Medium'), 
  ('Low');
-- Severity Table
-- Code list for hazard severity levels.

CREATE TABLE severity (
  severity_id INTEGER PRIMARY  KEY AUTOINCREMENT, 
  severity VARCHAR(20) NOT NULL
);
INSERT INTO severity (severity) 
VALUES 
  ('High'), 
  ('Medium'), 
  ('Low');

-- New table to store media for hazard reports
CREATE TABLE media (
    media_id INTEGER PRIMARY KEY AUTOINCREMENT,
    hazard_report_id INTEGER NOT NULL,
    media_type VARCHAR(10) NOT NULL CHECK (media_type IN ('photo', 'video')),
    media_attachment ATTACHMENT NOT NULL,
    uploaded_by_id INTEGER NOT NULL,
    date_uploaded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_media_hazard_report FOREIGN KEY (hazard_report_id)
        REFERENCES hazard_report(hazard_report_id),
    CONSTRAINT fk_media_uploaded_by FOREIGN KEY (uploaded_by_id)
        REFERENCES person(person_id)
);


-- InvestigationType Table
-- Code list for types of investigation.

CREATE TABLE investigation_type (
  investigation_type_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  investigation_type VARCHAR(20) NOT NULL
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
  report_status_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  report_status VARCHAR(20) NOT NULL
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
  trigger_source_id INTEGER PRIMARY  KEY AUTOINCREMENT, 
  trigger_source VARCHAR(20) NOT NULL
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
  escalation_status_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  escalation_status VARCHAR(20) NOT NULL
);
INSERT INTO escalation_status (escalation_status) 
VALUES 
  ('None'), 
  ('In Progress'), 
  ('Escalated');
-- NotificationType Table
-- Code list for types of notifications.
CREATE TABLE notification_type (
  notification_type_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  notification_type VARCHAR(20) NOT NULL
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
  escalation_stage_id INTEGER PRIMARY  KEY AUTOINCREMENT, 
  escalation_stage VARCHAR(20) NOT NULL
);
INSERT INTO escalation_stage (escalation_stage) 
VALUES 
  ('Open'), 
  ('In Progress'), 
  ('Resolved'), 
  ('Rejected');
-- NotificationMethod Table
-- Code list for notification methods.
CREATE TABLE communication_method (
  communicaiton_method_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  communicaiton_method VARCHAR(20) NOT NULL
);
INSERT INTO communication_method (communication_method) 
VALUES 
  ('Email'), 
  ('SMS'), 
  ('Letter');
-- EscalationType Table
-- Code list for types of escalations.
CREATE TABLE escalation_type (
  escalation_type_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  escalation_type VARCHAR(30) NOT NULL
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
  investigator_id INTEGER PRIMARY KEY AUTOINCREMENT, 
  investigator_name VARCHAR(100) NOT NULL
);


CREATE TABLE investigation_history (
    history_id INTEGER PRIMARY KEY AUTOINCREMENT,
    investigation_id INTEGER NOT NULL,
    
    -- Snapshot of related entities at the time
    hazard_id INTEGER NOT NULL,
    tenant_id INTEGER NOT NULL,
    property_id INTEGER NOT NULL,
  
    -- Previous vs new types
    previous_hazard_type_id INTEGER,
    new_hazard_type_id INTEGER,

    previous_investigation_type_id INTEGER,
    new_investigation_type_id INTEGER,

    previous_escalation_status_id INTEGER,
    new_escalation_status_id INTEGER,
    
    reason TEXT NOT NULL,
    action_taken TEXT NOT NULL,
    
    -- Audit metadata
    recorded_by INTEGER NOT NULL,  -- user who made the change
    recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT fk_investigation
        FOREIGN KEY (investigation_id) REFERENCES investigation(investigation_id),
    CONSTRAINT fk_hazard
        FOREIGN KEY (hazard_id) REFERENCES hazard(hazard_id),
    CONSTRAINT fk_tenant
        FOREIGN KEY (tenant_id) REFERENCES tenant(tenant_id),
    CONSTRAINT fk_property
        FOREIGN KEY (property_id) REFERENCES property(property_id),
    CONSTRAINT fk_work_order
        FOREIGN KEY (work_order_id) REFERENCES work_order(work_order_id),
    CONSTRAINT fk_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id),
    CONSTRAINT fk_prev_hazard_type
        FOREIGN KEY (previous_hazard_type_id) REFERENCES hazard_type(hazard_type_id),
    CONSTRAINT fk_new_hazard_type
        FOREIGN KEY (new_hazard_type_id) REFERENCES hazard_type(hazard_type_id),
    CONSTRAINT fk_prev_inv_type
        FOREIGN KEY (previous_investigation_type_id) REFERENCES investigation_type(investigation_type_id),
    CONSTRAINT fk_new_inv_type
        FOREIGN KEY (new_investigation_type_id) REFERENCES investigation_type(investigation_type_id),
    CONSTRAINT fk_recorded_by
        FOREIGN KEY (recorded_by) REFERENCES person(person_id),
        
    -- Prevent "changes" that are actually the same
    CONSTRAINT chk_hazard_type_change
        CHECK (
            previous_hazard_type_id IS NULL
            OR new_hazard_type_id IS NULL
            OR previous_hazard_type_id <> new_hazard_type_id
        ),
    CONSTRAINT chk_investigation_type_change
        CHECK (
            previous_investigation_type_id IS NULL
            OR new_investigation_type_id IS NULL
            OR previous_investigation_type_id <> new_investigation_type_id
        )
);
