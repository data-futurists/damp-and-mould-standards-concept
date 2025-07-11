-- WORKFLOW DIAGRAM (Text-based representation)
--
-- Tenant provides appointment preferences (customer_appointment_preference)
--          ↓
-- Landlord queries available slots (available_appointment) filtered by preferences
--          ↓
-- Landlord sends available appointment options (request_available_appointments)
--          ↓
-- Tenant selects/pre-approves appointment (request_appointment)
--          ↓
-- Landlord responds (request_appointment_response) - confirm or reject
--          ↓
-- If confirmed → Appointment scheduled for work_order or investigation
-- If rejected → Restart negotiation or propose new slots



-- SQL DDL -----------------------------

-- MAIN APPOINTMENT TABLES

CREATE TABLE request_appointment (
  request_appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
  work_order_id INTEGER NULL,
  investigation_id INTEGER NULL,
  notification_id INTEGER,
  appointment_type NVARCHAR(20) NOT NULL,
  requested_date DATETIME NOT NULL,
  requested_time_start DATETIME NOT NULL,
  requested_time_end DATETIME NOT NULL,
  notes NVARCHAR(255),

  CONSTRAINT fk_appointment_type FOREIGN KEY (appointment_type)
    REFERENCES appointment_type_code(code),
  CONSTRAINT fk_notification FOREIGN KEY (notification_id)
    REFERENCES notification(notification_id),

  CONSTRAINT chk_workorder_or_investigation CHECK (
    (work_order_id IS NOT NULL AND investigation_id IS NULL)
    OR (work_order_id IS NULL AND investigation_id IS NOT NULL)
  )
);

CREATE TABLE request_appointment_response (
  request_appointment_response_id INTEGER PRIMARY KEY AUTOINCREMENT,
  request_appointment_id INTEGER NOT NULL,
  notification_id INTEGER,
  response_status NVARCHAR(20) NOT NULL,
  response_date DATETIME NOT NULL,
  notes NVARCHAR(255),

  CONSTRAINT fk_request_appointment FOREIGN KEY (request_appointment_id)
    REFERENCES request_appointment(request_appointment_id),
  CONSTRAINT fk_notification_response FOREIGN KEY (notification_id) 
    REFERENCES notification(notification_id),

  CONSTRAINT fk_response_status FOREIGN KEY (response_status)
    REFERENCES response_status_code(code)
);

CREATE TABLE request_available_appointments (
  request_available_appointments_id INTEGER PRIMARY KEY AUTOINCREMENT,
  work_order_id INTEGER NULL,
  investigation_id INTEGER NULL,
  notification_id INTEGER,
  requested_from_date DATETIME NOT NULL,
  requested_to_date DATETIME NOT NULL,
  notes NVARCHAR(255),

  CONSTRAINT fk_notification_available FOREIGN KEY (notification_id)
    REFERENCES notification(notification_id),

  CONSTRAINT chk_workorder_or_investigation CHECK (
    (work_order_id IS NOT NULL AND investigation_id IS NULL)
    OR (work_order_id IS NULL AND investigation_id IS NOT NULL)
  )
);

CREATE TABLE available_appointment (
  available_appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
  request_available_appointments_id INTEGER NOT NULL,
  available_date DATETIME NOT NULL,
  available_time_start DATETIME NOT NULL,
  available_time_end DATETIME NOT NULL,
  notes NVARCHAR(255),

  CONSTRAINT fk_request_available_appointments FOREIGN KEY (request_available_appointments_id)
    REFERENCES request_available_appointments(request_available_appointments_id)
);

CREATE TABLE request_additional_work_approval (
  request_additional_work_approval_id INTEGER PRIMARY KEY AUTOINCREMENT,
  request_appointment_id INTEGER NOT NULL,
  approval_status NVARCHAR(20) NOT NULL,
  approval_date DATETIME NULL,
  notes NVARCHAR(255),

  CONSTRAINT fk_request_appointment FOREIGN KEY (request_appointment_id)
    REFERENCES request_appointment(request_appointment_id),

  CONSTRAINT fk_approval_status FOREIGN KEY (approval_status)
    REFERENCES approval_status_code(code)
);

CREATE TABLE customer_appointment_preference (
  customer_appointment_preference_id INTEGER PRIMARY KEY AUTOINCREMENT,
  tenant_id INTEGER NOT NULL,
  specific_date DATETIME NULL,
  excluded_period_start DATETIME NULL,
  excluded_period_end DATETIME NULL,
  degree_of_preference INTEGER NULL,
  time_of_day_start DATETIME NULL,
  time_of_day_end DATETIME NULL,
  notes NVARCHAR(255)
);

CREATE TABLE customer_appointment_preference_day_of_week (
  customer_appointment_preference_id INTEGER NOT NULL,
  days_of_week_code_id INTEGER NOT NULL,
  PRIMARY KEY (customer_appointment_preference_id, days_of_week_code_id),

  CONSTRAINT fk_customer_appointment_preference FOREIGN KEY (customer_appointment_preference_id)
    REFERENCES customer_appointment_preference(customer_appointment_preference_id),

  CONSTRAINT fk_days_of_week_code FOREIGN KEY (days_of_week_code_id)
    REFERENCES days_of_week_code(days_of_week_code_id)
)


-- CODE TABLES

CREATE TABLE appointment_type_code (
  appointment_type_code_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code NVARCHAR(20) NOT NULL UNIQUE,
  description NVARCHAR(100) NOT NULL
);

INSERT INTO appointment_type_code (appointment_type_code_id, code, description) VALUES
  ('1', 'EMERGENCY', 'Emergency appointment'),
  ('2', 'INVESTIGATION', 'Investigation appointment'),
  ('3', 'WORK_ORDER', 'Work order appointment'),
  ('4', 'REPAIR', 'Repair appointment'),
  ('5', 'INSPECTION', 'Inspection appointment'),
  ('6', 'MAINTENANCE', 'Maintenance appointment'),
  ('7','STANDARD', 'Standard appointment'),
  ('8','FOLLOWUP', 'Follow-up appointment');

CREATE TABLE response_status_code (
  response_status_code_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code NVARCHAR(20) NOT NULL UNIQUE,
  description NVARCHAR(100) NOT NULL
);

INSERT INTO response_status_code (code, description) VALUES
  ('ACCEPT', 'Appointment accepted'),
  ('REJECT', 'Appointment rejected'),
  ('PENDING', 'Awaiting response');

CREATE TABLE days_of_week_code (
  days_of_week_code_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code NVARCHAR(10) NOT NULL UNIQUE,
  description NVARCHAR(50) NOT NULL
);

INSERT INTO days_of_week_code (code, description) VALUES
  ('MON', 'Monday'),
  ('TUE', 'Tuesday'),
  ('WED', 'Wednesday'),
  ('THU', 'Thursday'),
  ('FRI', 'Friday'),
  ('SAT', 'Saturday'),
  ('SUN', 'Sunday'),
  ('WKD', 'Weekday (Mon-Fri)'),
  ('WKE', 'Weekend (Sat-Sun)');

CREATE TABLE approval_status_code (
  approval_status_code_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code NVARCHAR(20) NOT NULL UNIQUE,
  description NVARCHAR(100) NOT NULL
);

INSERT INTO approval_status_code (code, description) VALUES
  ('PENDING', 'Waiting decision'),
  ('APPROVED', 'Approved'),
  ('DENIED', 'Denied');