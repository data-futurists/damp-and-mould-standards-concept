# Introducing the damp and mould data model

## Table of contents

— [What’s included in the data model](#whats-included-in-the-data-model)  
— [Key features of the data model](#key-features-of-the-data-model)   
— [How the data model can help you in future](#how-the-data-model-can-help-you-in-future)

The damp and mould data model allows you to record, track and respond to health and safety issues caused by damp and mould in social-rented homes.

It structures the way data is stored and validated, and it includes some embedded standards such as code lists and binary checks.

## It brings together key pieces of information to help you meet the requirements of Awaab’s Law

### What the issue is 

Structures data as a case file showing hazard reports and the various repair work to solve them.

### Where it’s happening

Specifies rooms or areas affected by hazards.

### Who it affects

Logs tenants’ vulnerabilities and helps you assess repair hazards with reference to those vulnerabilities.

### What’s been done about it

Manages investigations, repairs and escalation processes within the required timescales.

## What’s included in the data model

We’ve built this data model using [HACT’s UK Housing Data Standards](https://hact.org.uk/) to stay aligned with sector best practices. This means we’re following common definitions and processes for things like properties, tenants and repairs.

The data model is made up of 4 components:

### [Investigation component]()

* Records property inspections triggered by hazard reports.   
* Captures data such as property ID, tenant information and reporting date.  
* Maintains historical records of previous inspections and defines the relationships between inspections and other entities in the system, such as properties and work orders.

### [Property component]()

* Used to link hazards to the properties they relate to.  
* Serves as a central reference for other processes in the data model.  
* Tracks hierarchical data related to a property, including property ID and address ID.  
* Includes attributes like construction type — for example, timber frame or steel frame.

### [Work order component]()

* Records maintenance and repair tasks, as well as a schedule of rates (SoR) — a document that lists predefined unit costs for various construction tasks and elements.  
* Allows tracking of multiple work orders within a single case.  
* Includes various attributes such as work order ID, date, type and status.

### [Tenant component]()

* Captures tenant and household member details, including attributes such as vulnerabilities.  
* Includes various attributes such as person ID, name and contact information.  
* Links to person alert codes to identify specific vulnerabilities.

[Read more about how Awaab’s Law data model works]()

## Key features of the data model

### It’s designed to work with your current data model

The model follows the principle of [separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns). Rather than forcing you to adopt a full, all-or-nothing system, its modular structure lets you pick and choose the components you need.

This makes it easier to integrate with your existing data models.

The data model comes with suggested options for things like risk levels and investigation types. However, you can customise these code lists and entities to match your own classifications.

| For example, if your team uses a rating like “Extremely High Risk” or has specific investigation types that aren’t included by default, you can add them in. |
| :---- |

The same applies to the [tenant component](), allowing for the inclusion of additional vulnerability details or classifications. You can extend these with input from domain-specific experts, such as health professionals.

### It’s easy to maintain, manage and query

We’ve designed the data model to reduce duplication and keep things efficient. If the same piece of data appears in multiple places, it’s stored in its own table. Then, tables are linked using integer ID fields, which helps keep the database storage size smaller, easier to manage and query.

We’ve also implemented constraints that help maintain data integrity, including:

* Binary checks (for example, ensuring values are 0 or 1).  
* Date checks (for example, ensuring the end date comes after the start date).  
* Logical checks (for example, compensation amount must exist if compensation is offered).

The model also supports querying. For example, you could identify tenants with respiratory issues using a query like:

```sql

SELECT tp.full_name, pat.code
FROM tenant_person tp
LEFT JOIN person_alert_type pat on tp.person_alert_type_id = pat.person_alert_type_id
WHERE pat.code LIKE '%condition%' 
   OR pat.code LIKE '%disability%'
   OR pat.code LIKE '%vulnerable%';
```

### It isn’t just for damp and mould

By 2027, Awaab’s Law is expected to cover more types of housing hazards listed under the [Housing Health and Safety Rating System](https://www.staffordbc.gov.uk/housing-health-and-safety-rating-system-the-29-hazards). The model can easily adapt to include other types of hazards without changing the overall structure of the model.

We’ve designed it so future hazards can be added as additional entries in the hazard type code list.

[Explore the investigation component entity relationship diagram (ERD).]()

## How the data model can help you in future

### Identify problems earlier

Our data model makes it easier to spot patterns in your properties. For example, if you notice recurring damp issues in homes built with concrete panels, you can quickly identify other properties that might have the same risk.

This allows you to take preventative action, plan inspections and prioritise maintenance based on the patterns you identify.

### Prepare for artificial intelligence (AI) and automation

Structured data is essential if you want to use AI or automation tools in the future. This data model gives you the solid foundation you need.

Whether it's predicting maintenance issues or scheduling routine inspections, well-organised data helps AI and automated systems understand and manage your housing stock effectively.

