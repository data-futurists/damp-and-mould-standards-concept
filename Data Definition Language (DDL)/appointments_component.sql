-- WORKFLOW DIAGRAM (Text-based representation)
--
-- [AvailableAppointment] <-- created by landlord or contractor
--          |
--          v
-- [RequestAvailableAppointments] <-- triggered to query available slots
--          |
--          v
-- [CustomerAppointmentPreference] <-- tenant preferences (date, time, excluded periods)
--          |
--          v
-- [RequestAppointment] <-- appointment requested, linked to WorkOrder OR Investigation
--          |
--          v
-- [RequestAppointmentResponse] <-- appointment confirmed/declined/rescheduled


-- SQL DDL -----------------------------

-- MAIN APPOINTMENT TABLES

CREATE TABLE request_appointment (
  request_appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
  work_order_id INTEGER NULL,
  investigation_id INTEGER NULL,
  appointment_type NVARCHAR(20) NOT NULL,
  requested_date DATETIME NOT NULL,
  requested_time_start DATETIME NOT NULL,
  requested_time_end DATETIME NOT NULL,
  notes NVARCHAR(255),

  CONSTRAINT fk_appointment_type FOREIGN KEY (appointment_type)
    REFERENCES appointment_type_code(code),

  CONSTRAINT chk_workorder_or_investigation CHECK (
    (work_order_id IS NOT NULL AND investigation_id IS NULL)
    OR (work_order_id IS NULL AND investigation_id IS NOT NULL)
  )
);

CREATE TABLE request_appointment_response (
  request_appointment_response_id INTEGER PRIMARY KEY AUTOINCREMENT,
  request_appointment_id INTEGER NOT NULL,
  response_status NVARCHAR(20) NOT NULL,
  response_date DATETIME NOT NULL,
  notes NVARCHAR(255),

  CONSTRAINT fk_request_appointment FOREIGN KEY (request_appointment_id)
    REFERENCES request_appointment(request_appointment_id),

  CONSTRAINT fk_response_status FOREIGN KEY (response_status)
    REFERENCES response_status_code(code)
);

CREATE TABLE request_available_appointments (
  request_available_appointments_id INTEGER PRIMARY KEY AUTOINCREMENT,
  work_order_id INTEGER NULL,
  investigation_id INTEGER NULL,
  requested_from_date DATETIME NOT NULL,
  requested_to_date DATETIME NOT NULL,
  notes NVARCHAR(255),

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
);
Full DBML Script (including codes and relations)
dbml
Copy
Edit
Table appointment_type_code {
  appointment_type_code_id integer [pk, increment]
  code varchar(20) [unique, not null]
  description varchar(100) [not null]
}

Table response_status_code {
  response_status_code_id integer [pk, increment]
  code varchar(20) [unique, not null]
  description varchar(100) [not null]
}

Table days_of_week_code {
  days_of_week_code_id integer [pk, increment]
  code varchar(10) [unique, not null]
  description varchar(50) [not null]
}

Table approval_status_code {
  approval_status_code_id integer [pk, increment]
  code varchar(20) [unique, not null]
  description varchar(100) [not null]
}

Table request_appointment {
  request_appointment_id integer [pk, increment]
  work_order_id integer [null]
  investigation_id integer [null]
  appointment_type varchar(20) [not null, ref: > appointment_type_code.code]
  requested_date datetime [not null]
  requested_time_start datetime [not null]
  requested_time_end datetime [not null]
  notes varchar(255) [null]

  Note: "CHECK constraint: either work_order_id or investigation_id must be present, but not both"
}

Table request_appointment_response {
  request_appointment_response_id integer [pk, increment]
  request_appointment_id integer [not null, ref: > request_appointment.request_appointment_id]
  response_status varchar(20) [not null, ref: > response_status_code.code]
  response_date datetime [not null]
  notes varchar(255) [null]
}

Table request_available_appointments {
  request_available_appointments_id integer [pk, increment]
  work_order_id integer [null]
  investigation_id integer [null]
  requested_from_date datetime [not null]
  requested_to_date datetime [not null]
  notes varchar(255) [null]

  Note: "CHECK constraint: either work_order_id or investigation_id must be present, but not both"
}

Table available_appointment {
  available_appointment_id integer [pk, increment]
  request_available_appointments_id integer [not null, ref: > request_available_appointments.request_available_appointments_id]
  available_date datetime [not null]
  available_time_start datetime [not null]
  available_time_end datetime [not null]
  notes varchar(255) [null]
}

Table request_additional_work_approval {
  request_additional_work_approval_id integer [pk, increment]
  request_appointment_id integer [not null, ref: > request_appointment.request_appointment_id]
  approval_status varchar(20) [not null, ref: > approval_status_code.code]
  approval_date datetime [null]
  notes varchar(255) [null]
}

Table customer_appointment_preference {
  customer_appointment_preference_id integer [pk, increment]
  tenant_id integer [not null]
  specific_date datetime [null]
  excluded_period_start datetime [null]
  excluded_period_end datetime [null]
  degree_of_preference integer [null]
  time_of_day_start datetime [null]
  time_of_day_end datetime [null]
  notes varchar(255) [null]
}

Table customer_appointment_preference_day_of_week {
  customer_appointment_preference_id integer [not null, ref: > customer_appointment_preference.customer_appointment_preference_id]
  days_of_week_code_id integer [not null, ref: > days_of_week_code.days_of_week_code_id]
  indexes {
    (customer_appointment_preference_id, days_of_week_code_id) [pk]
  }
}

-- CODE TABLES

CREATE TABLE appointment_type_code (
  appointment_type_code_id INTEGER PRIMARY KEY AUTOINCREMENT,
  code NVARCHAR(20) NOT NULL UNIQUE,
  description NVARCHAR(100) NOT NULL
);

INSERT INTO appointment_type_code (code, description) VALUES
  ('STANDARD', 'Standard appointment'),
  ('EMERGENCY', 'Emergency appointment'),
  ('FOLLOWUP', 'Follow-up appointment');

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