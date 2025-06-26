# How the Awaab's Law data model works

## Contents

— [How data flows though the model](#how-data-flows-though-the-model)

1. [Someone reports a hazard](#1.-someone-reports-a-hazard)  
2. [The information is stored in your database](#2.-the-information-is-stored-in-your-database)  
   1. [You check for vulnerabilities](#2a.-you-check-for-vulnerabilities)  
3. [An investigation is scheduled](#3.-an-investigation-is-scheduled)  
4. [A work order is created](#4.-a-work-order-is-created)  
5. [Issues may be escalated](#5.-issues-may-be-escalated)

This guide explains how data flows through the data model, specifically:

* how it’s collected  
* how it’s structured  
* how it moves between components

It describes the ideal way the model is designed to work.

| For example, using a form is the most efficient way to ensure the data you collect aligns with the model. Fields in the form can be mapped directly to the relevant tables, supporting consistent and accurate reporting. |
| :---- |

You may record and manage data differently, depending on your systems and processes. However, the data model is built to be modular, allowing you to pick and choose the components you need.

[Read more about the key features of the Awaab’s Law data model](http://keyfeat).

## How data flows though the model {#how-data-flows-though-the-model}

### 1\. Someone reports a hazard {#1.-someone-reports-a-hazard}

A tenant, household member or staff member raises an issue related to damp and mould. Key details should be captured at this stage, including:

* type of issue, description and date reported  
* address or unique property ID

Once a hazard is reported, logic can be applied to determine the required response timeframe under Awaab’s Law:

* Emergency hazards must be investigated and made safe within 24 hours.  
* Significant hazards must be investigated within 10 working days and, if necessary, be made safe within 5 working days after the investigation.

### 2\. The information is stored in your database {#2.-the-information-is-stored-in-your-database}

The information is captured and stored in your database using the structure provided by the data model. That information is then used to populate the relevant tables, such as tenant, property and HazardReport.

This process includes:

* assigning a unique hazard ID  
* looking up and linking related data, such as property details  
* storing the information in the hazard\_report table  
* setting an initial status — for example, under review

As you respond to the issue, the process assumes you have a system that updates the records.

For example:

* The inspection table can only be populated after someone visits the property.  
* The work order table is filled in once repair work is identified.  
  * There may be more than one work order depending on what’s needed.

### 2a. You check for vulnerabilities {#2a.-you-check-for-vulnerabilities}

The data model sets out how information about tenants and household members should be structured.

Someone in your organisation will need to check if a tenant or household member has a recorded vulnerability after a hazard is reported.

To support this process, the model includes:

* a vulnerability flag to indicate whether a person is vulnerable  
* code lists to help define different types of vulnerability

| In future, this step could be automated. With the right pipelines and stored procedures, your systems could check for vulnerabilities automatically and determine whether a new report is an emergency or a significant hazard. |
| :---- |

### 3\. An investigation is scheduled {#3.-an-investigation-is-scheduled}

The investigation must be completed within a set timeframe, depending on the priority of the hazard:

* Emergency hazards must be investigated and made safe within 24 hours.  
* Significant hazards must be investigated within 10 working days and, if necessary, be made safe within 5 working days after the investigation.

The data model doesn’t schedule investigations itself, but it provides a clear structure for storing investigation data once it’s been collected. This includes:

* Hazard report information (what, when, where and who it affects)  
* Type of investigation (whether that’s an emergency, a standard, a renewed or further investigation)  
* Investigation information (dates and if further work required)  
* Notifications sent to tenants

### 4\. A work order is created {#4.-a-work-order-is-created}

A work order is created to initiate and track the repair process. The data model helps you track the status of each work order to monitor progress.

This is a process already defined in the [HACT UK Housing Data Standards](https://hact.org.uk/tools-and-services/uk-housing-data-standards/) and part of the reactive repairs module. 

If repairs aren’t completed within the expected timeframe, you may need to:

* follow up with another inspection  
* create an additional work order, depending on what’s needed  
* take further action if the tenant is not satisfied with the outcome

### 5\. Issues may be escalated {#5.-issues-may-be-escalated}

You may need to take further action when a hazard has not been resolved within the expected timeframe.

Escalations may be initiated if:

* a tenant rejects the proposed resolution  
* the issue remains unresolved after a work order has been completed

The data model includes an escalation table to capture and manage all relevant information, and it includes:

* the reason for escalation and current status  
* actions taken, such as offering alternative accommodation or compensation  
  * if compensation was offered, it includes the amount and whether the tenant accepted it

This step helps you track how unresolved issues are being handled and gives you a clear audit trail.

