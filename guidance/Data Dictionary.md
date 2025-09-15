# Damp and Mould Data Dictionary

This data dictionary explains the attributes in the Damp and Mould Data Model in **plain English**.  
It is designed for housing staff, managers, and partners who are not technical users.  
---

## How to use this document
- **Attribute Name** → the technical name used in the database/model.  
- **Plain English Definition** → what it means in everyday language.  
- **Example Value** → a realistic sample to make it clear.  
- **Notes** → extra context, e.g. format, options, or links to other entities.  

---

# Investigation Component – Damp and Mould Data Model

The **Investigation component** of the Damp and Mould data model captures all activities related to identifying, assessing, and managing hazards reported in properties.  
It provides a clear, structured way to track investigations, the hazards found, any escalations, notifications sent, and the staff involved.  

## Purpose

The Investigation component ensures that all hazards are properly investigated and managed, enabling housing teams to:  

- Record and track each hazard reported by tenants or staff.  
- Link investigations to specific properties, tenancies, and hazard reports.  
- Capture details about the type and severity of hazards discovered.  
- Monitor the progress and outcome of investigations.  
- Record escalations when additional actions or approvals are needed.  
- Track notifications sent to tenants regarding investigations, work, or escalations.  
- Maintain a record of staff or contractors responsible for carrying out investigations.  

## Key Features

1. **Hazard Report Tracking:** Each investigation links to the original hazard report to ensure traceability.  
2. **Investigation Details:** Dates, type, investigator, and confirmation of hazards are recorded.  
3. **Hazard Classification:** Specific hazards found are linked to standardized hazard types and severity ratings.  
4. **Escalation Management:** Escalation records capture stages, reasons, actions taken, and tenant communication.  
5. **Notification Management:** Notifications sent to tenants or staff are tracked, including type, method, and content summary.  
6. **Code Lists:** Standardized lists (e.g., hazard severity, investigation types, escalation stages) ensure consistency across the system.  
7. **Investigator Records:** Stores the names of staff or contractors conducting investigations for accountability and reporting.  

## How it Supports Housing Teams

The Investigation component allows non-technical staff to quickly understand the status of hazards, prioritize urgent cases, communicate effectively with tenants, and ensure compliance with safety and regulatory standards.  

It also integrates with other components of the Damp and Mould model (e.g., Work Orders, Person Alerts) to provide a full picture of property safety and repair activity.

---

# Entities and Attributes Descriptions
---

## hazard_report

This table stores details of reported hazards related to damp and mould.  
Each record represents one hazard report raised by a tenant, staff member, or other party.  

| Attribute Name           | Plain English Definition                                                                 | Example Value         | Notes |
|--------------------------|------------------------------------------------------------------------------------------|-----------------------|-------|
| `hazard_report_id`       | Unique system ID for the hazard report                                                   | 101                   | Automatically generated (system use only) |
| `hazard_report_reference`| Reference code for the hazard report (used in communications and tracking)               | HR-2025-00123         | Human-readable identifier |
| `uprn`                   | Unique Property Reference Number for the address where the hazard is located             | 123456789012          | Links to property/address records |
| `tenancy_id`             | ID of the tenancy linked to the hazard report                                            | TEN-56789             | Links to tenancy records |
| `date_reported`          | Date the hazard was first reported                                                       | 2025-01-12            | Format: YYYY-MM-DD |
| `reported_by`            | Name (or id) of the person who reported the hazard                                               | Jane Smith            | Could be tenant, contractor, or staff |
| `description`            | Free-text description of the hazard                                                      | "Black mould in kitchen ceiling" | Optional |
| `photo_evidence`         | Link or reference to photo evidence provided                                             | `photo123.jpg`        | Could be stored in document system |
| `location_details`       | Extra details about where the hazard is located in the property                          | "North wall of bedroom" | Optional |
| `emergency_action_taken` | Whether emergency action was taken immediately                                           | 1 (Yes)               | 0 = No, 1 = Yes |
| `made_safe_date`         | Date the property was made safe (if emergency action was taken)                          | 2025-01-13            | Must be same or after `date_reported` |
| `further_work_required`  | Whether further work is needed beyond initial safety measures                            | 1 (Yes)               | 0 = No, 1 = Yes |
| `further_work_due_date`  | Date when further work must be completed                                                 | 2025-01-20            | Must be same or after investigation due date |
| `report_status_id`       | Status of the hazard report                                                              | 3                     | Links to `report_status` (e.g. New, In Progress, Closed) |

### Notes
- This table links to other reference data:  
  - `reference(id)` for hazard reference  
  - `address(uprn)` for property details  
  - `tenancy(tenancy_id)` for tenancy details  
  - `investigation_type(investigation_type_id)` for type of investigation  
  - `report_status(report_status_id)` for current status  
- Boolean-style fields (`emergency_action_taken`, `further_work_required`) use `0 = No`, `1 = Yes`.

---

## investigation

This table stores details of investigations carried out following a reported hazard.  
Each record represents one investigation linked to a hazard report.  

| Attribute Name                | Plain English Definition                                                                 | Example Value         | Notes |
|--------------------------------|------------------------------------------------------------------------------------------|-----------------------|-------|
| `investigation_id`             | Unique system ID for the investigation                                                   | 2001                  | Automatically generated (system use only) |
| `investigation_reference`      | Reference code for the investigation (used in communications and tracking)               | INV-2025-00045        | Human-readable identifier |
| `uprn`                         | Unique Property Reference Number for the address where the investigation took place      | 123456789012          | Links to property/address records |
| `tenancy_id`                   | ID of the tenancy linked to the investigation                                            | TEN-56789             | Links to tenancy records |
| `hazard_report_id`             | ID of the hazard report that triggered the investigation                                 | 101                   | Links to `hazard_report` table |
| `trigger_source_id`            | The source that triggered the investigation (e.g. tenant complaint, routine inspection)  | 2                     | Links to `trigger_source` table |
| `investigation_type_id`        | Type of investigation carried out                                                        | 1                     | Links to `investigation_type` table |
| `investigation_scheduled_date` | Date the investigation was scheduled                                                     | 2025-01-15            | Must be same or after the hazard was reported |
| `investigation_completed_date` | Date the investigation was completed                                                     | 2025-01-20            | Must be same or after scheduled date |
| `investigator_id`              | ID of the person who carried out the investigation                                       | 3001                  | Links to `investigator` table |
| `hazard_confirmed`             | Whether the investigation confirmed the presence of a hazard                            | 1 (Yes)               | 0 = No, 1 = Yes |
| `sla_breach_flag`              | Whether the investigation breached service level agreements (deadlines)                  | 0 (No)                | 0 = No, 1 = Yes |
| `notification_sent_to_tenant`  | Whether a notification/letter was sent to the tenant                                     | 1 (Yes)               | 0 = No, 1 = Yes |
| `investigation_notes`          | Free-text notes recorded by the investigator                                             | "Mould confirmed in bedroom" | Optional |

### Notes
- This table links to other reference data:  
  - `reference(id)` for investigation reference  
  - `address(uprn)` for property details  
  - `tenancy(tenancy_id)` for tenancy details  
  - `hazard_report(hazard_report_id)` for related hazard  
  - `trigger_source(trigger_source_id)` for what triggered the investigation  
  - `investigation_type(investigation_type_id)` for type of investigation  
  - `investigator(investigator_id)` for staff/contractor carrying out the work  
- Boolean-style fields (`hazard_confirmed`, `sla_breach_flag`, `notification_sent_to_tenant`) use `0 = No`, `1 = Yes`.

---

## hazard_type

This table stores the different types of hazards that can be reported, along with their category and associated health risk.  

| Attribute Name            | Plain English Definition                                             | Example Value         | Notes |
|----------------------------|----------------------------------------------------------------------|----------------------|-------|
| `hazard_type_id`           | Unique system ID for the hazard type                                 | 1                    | Automatically generated (system use only) |
| `hazard_type`              | Name of the hazard type                                              | "Mould"              | Free text; describes the kind of hazard |
| `health_risk_rating_id`    | Reference to the health risk rating associated with this hazard type | 2                    | Links to `health_risk_rating` table; indicates severity for tenant safety |
| `category`                 | Group or category for the hazard type                                | "Environmental"      | Optional; e.g., Environmental, Structural, Electrical |

### Notes
- This table is used to classify hazards reported in the system.  
- Health risk ratings help staff prioritize investigations and repairs based on severity.  
- Categories provide an optional way to group hazard types for reporting or filtering.  

---

## investigation_hazard

This table records the specific hazards that were identified during an investigation.  
Each record links an investigation to a hazard type found on a property.  

| Attribute Name              | Plain English Definition                                                    | Example Value                | Notes |
|------------------------------|----------------------------------------------------------------------------|------------------------------|-------|
| `investigation_hazard_id`    | Unique system ID for the record                                            | 5001                         | Automatically generated (system use only) |
| `hazard_type_id`             | The type of hazard that was found                                          | 1                             | Links to `hazard_type` table (e.g., Mould, Damp) |
| `investigation_id`           | The investigation during which this hazard was found                       | 2001                         | Links to `investigation` table |
| `hazard_report_id`           | The original hazard report linked to this finding                           | 101                          | Links to `hazard_report` table |
| `severity_id`                | Severity rating of the hazard identified                                     | 3                             | Links to `severity` table; indicates how serious the hazard is |
| `notes`                      | Free-text notes or observations made by the investigator                    | "Mould concentrated on ceiling near window" | Optional; context about the hazard |

### Notes
- This table is used to capture all hazards discovered during an investigation, along with their severity.  
- It allows multiple hazards to be linked to a single investigation and hazard report.  
- The `severity_id` helps prioritize follow-up work and repairs.  

---

## escalation

This table stores details of escalation actions taken when an investigation or hazard report requires additional attention.  
Each record represents one escalation event linked to an investigation.  

| Attribute Name                     | Plain English Definition                                                    | Example Value                        | Notes |
|-----------------------------------|----------------------------------------------------------------------------|--------------------------------------|-------|
| `escalation_id`                    | Unique system ID for the escalation record                                  | 7001                                 | Automatically generated (system use only) |
| `escalation_reference`             | Reference code for the escalation                                           | ESC-2025-002                         | Human-readable identifier |
| `investigation_id`                 | Investigation linked to this escalation                                     | 2001                                 | Links to `investigation` table |
| `escalation_reason`                | Reason why the escalation was raised                                        | "Hazard unresolved after initial visit" | Optional |
| `escalation_stage_id`              | Stage of the escalation                                                    | 2                                     | Links to `escalation_stage` table (e.g., Stage 1, Stage 2) |
| `escalation_type_id`               | Type of escalation action                                                  | 1                                     | Links to `escalation_type` table (e.g., Management, Legal, Emergency) |
| `escalated_to`                     | Person or team the escalation was sent to                                   | "Senior Housing Officer"             | Mandatory |
| `escalation_start_date`            | Date the escalation was initiated                                          | 2025-01-25                            | Format: YYYY-MM-DD |
| `escalation_end_date`              | Date the escalation was resolved or closed                                   | 2025-02-01                            | Must be same or after start date; optional if still open |
| `action_taken`                     | Notes on the action taken as part of the escalation                         | "Contractor instructed to repair ceiling" | Optional |
| `compensation_amount`              | Amount of compensation offered to the tenant, if any                        | 250.00                                | Optional; must be ≥ 0 |
| `alternative_accommodation_details`| Details of any temporary accommodation provided                              | "Hotel room for 3 nights"             | Optional |
| `tenant_acceptance`                | Whether the tenant accepted the proposed action or compensation             | 1 (Yes)                               | 0 = No, 1 = Yes |
| `escalation_notes`                 | Free-text notes about the escalation                                         | "Tenant satisfied with outcome"       | Optional |

### Notes
- This table tracks escalations to ensure follow-up and accountability.  
- Boolean-style field `tenant_acceptance` uses `0 = No`, `1 = Yes`.  
- Compensation amounts cannot be negative.  
- Escalation dates are used to track how long the escalation remained open.  

---

## notification

This table stores notifications sent related to investigations, work orders, or escalations.  
Each record represents one notification sent to a tenant or other relevant party.  

| Attribute Name           | Plain English Definition                                               | Example Value                       | Notes |
|---------------------------|------------------------------------------------------------------------|-------------------------------------|-------|
| `notification_id`         | Unique system ID for the notification                                   | 9001                                | Automatically generated (system use only) |
| `investigation_id`        | Investigation linked to this notification                               | 2001                                | Links to `investigation` table |
| `tenancy_id`              | Tenancy the notification is related to                                   | TEN-56789                           | Links to `tenancy` table |
| `work_order_id`           | Work order linked to this notification                                    | WO-123456                            | Links to `work_order` table |
| `notification_type_id`    | Type of notification sent                                                | 1                                   | Links to `notification_type` table (e.g., Email, Letter, SMS) |
| `escalation_id`           | Escalation linked to this notification (if applicable)                  | 7001                                | Optional; links to `escalation` table |
| `date_sent`               | Date the notification was sent                                           | 2025-02-01                          | Format: YYYY-MM-DD |
| `notification_method_id`  | Method used to send the notification                                     | 2                                   | Links to `notification_method` table |
| `content_summary`         | Summary of the notification content                                      | "Tenant informed that repair scheduled for 15 Jan" | Optional; free text |

### Notes
- This table allows tracking of all tenant communications related to investigations and escalations.  
- Links to both the work order and investigation ensure traceability.  
- Optional `escalation_id` allows notifications to be tied to escalation events if relevant.  

---

## Code Lists

Code lists are predefined sets of options used in the system to standardize values.  
They are referenced by other tables through foreign keys.  

---

### health_risk_rating

| Attribute Name            | Plain English Definition                | Example Value | Notes |
|----------------------------|----------------------------------------|---------------|-------|
| `health_risk_rating_id`    | Unique system ID for the health risk rating | 1             | Automatically generated |
| `health_risk_rating`       | Level of health risk associated with a hazard | High         | Options: High, Medium, Low |

---

### severity

| Attribute Name   | Plain English Definition                    | Example Value | Notes |
|-----------------|--------------------------------------------|---------------|-------|
| `severity_id`     | Unique system ID for hazard severity        | 1             | Automatically generated |
| `severity`        | How severe the hazard is                    | High          | Options: High, Medium, Low |

---

### investigation_type

| Attribute Name          | Plain English Definition                    | Example Value | Notes |
|-------------------------|--------------------------------------------|---------------|-------|
| `investigation_type_id` | Unique system ID for investigation type    | 1             | Automatically generated |
| `investigation_type`    | Type of investigation being carried out     | Standard      | Options: Standard, Renewed, Further, Emergency |

---

### report_status

| Attribute Name          | Plain English Definition                     | Example Value | Notes |
|-------------------------|---------------------------------------------|---------------|-------|
| `report_status_id`      | Unique system ID for report status           | 1             | Automatically generated |
| `report_status`         | Current status of a hazard report            | Open          | Options: Open, Under Review, Made Safe, Closed |

---

### trigger_source

| Attribute Name          | Plain English Definition                     | Example Value | Notes |
|-------------------------|---------------------------------------------|---------------|-------|
| `trigger_source_id`     | Unique system ID for the source of investigation | 1         | Automatically generated |
| `trigger_source`        | What caused the investigation to be triggered | Tenant Report | Options: Tenant Report, Routine Check, Environmental Sensor, Staff Report |

---

### notification_type

| Attribute Name          | Plain English Definition                     | Example Value | Notes |
|-------------------------|---------------------------------------------|---------------|-------|
| `notification_type_id`  | Unique system ID for notification type       | 1             | Automatically generated |
| `notification_type`     | Type of notification being sent             | Scheduled     | Options: Scheduled, Result, Advice, Delay, Escalation |

---

### notification_method

| Attribute Name           | Plain English Definition                     | Example Value | Notes |
|--------------------------|---------------------------------------------|---------------|-------|
| `notification_method_id` | Unique system ID for method                  | 1             | Automatically generated |
| `notification_method`    | How the notification was sent                | Email         | Options: Email, SMS, Letter |

---

### escalation_stage

| Attribute Name          | Plain English Definition                     | Example Value | Notes |
|-------------------------|---------------------------------------------|---------------|-------|
| `escalation_stage_id`   | Unique system ID for escalation stage        | 1             | Automatically generated |
| `escalation_stage`      | Stage of the escalation process             | Open          | Options: Open, In Progress, Resolved, Rejected |

---

### escalation_status

| Attribute Name          | Plain English Definition                     | Example Value | Notes |
|-------------------------|---------------------------------------------|---------------|-------|
| `escalation_status_id`  | Unique system ID for escalation status       | 1             | Automatically generated |
| `escalation_status`     | Current status of the escalation            | In Progress   | Options: None, In Progress, Escalated |

---

### escalation_type

| Attribute Name           | Plain English Definition                     | Example Value | Notes |
|--------------------------|---------------------------------------------|---------------|-------|
| `escalation_type_id`     | Unique system ID for escalation type         | 1             | Automatically generated |
| `escalation_type`        | Type of escalation action                    | Senior Review | Options: Senior Review, Legal Action, Compensation, Alternative Accommodation |

---

## investigator

This table stores details of staff or contractors who carry out investigations.  

| Attribute Name        | Plain English Definition                     | Example Value       | Notes |
|-----------------------|---------------------------------------------|-------------------|-------|
| `investigator_id`     | Unique system ID for the investigator       | 3001              | Automatically generated |
| `investigator_name`   | Name of the investigator                     | John Smith        | Full name of staff or contractor |

---

### Notes
- All code lists are referenced by other tables through foreign keys.  
- Adding new options should be coordinated with system administrators to maintain consistency.  


