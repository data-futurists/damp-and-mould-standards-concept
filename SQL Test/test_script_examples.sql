----------------------------------------------------------------------------------------
-- Author: George Foster (TPXImpact)
-- Email: george.foster@tpximpact.com
--
-- Script below provides example queries to test the SQL code devloped for the Awaab's
-- data model including PK, FK and logic checks.
----------------------------------------------------------------------------------------

-- PRIMARY KEY CHECKS
-- This test confirms that the number of PKs in the table matches the number of rows
-- the result of this query should return 0 indicating that there is the same number
-- of rows as there are distinct primary keys.
-- The example is for the HazardReport table and should be replicated for each table
-- in the model.

SELECT COUNT(*) - COUNT(DISTINCT hazard_report_id) FROM hazard_report;

-- FOREIGN KEY CHECKS
-- This test confirms that the FKs used in the tables are contained in the parent table.
-- The result of this query should be blank if the FKs are used correctly. If any rows
-- are present then this shows that they should be added to the parent table.
-- The example is for the HazardReport table and the inspection_type table and should be 
-- replicated for each table in the model that contains FKs.

SELECT * FROM hazard_report_id WHERE investigation_type_id NOT IN (SELECT investigation_type_id FROM investigation_type);

-- DATE LOGIC CHECKS
-- This test ensures date fields are in the create order where a table contains two fields
-- relating to a similar event such as a repair schedule and a repair completion date.
-- The result of this query should be blank. Any results from this query indicates the
-- date fields are incorrect as a completion cannot happen before a scheduled date.
-- This test should be replicated for each set of dates where one must happen on or
-- before another. The example below is from the inspection table for the repair
-- completion and scheduled dates.

SELECT * FROM inspection WHERE repair_completed_date < repair_scheduled_date;

-- FIELD TYPE CHECKS
-- This test ensures that data entered respects the field types set in the tables.
-- The example below checks to make sure the emergency_Action field in the 
-- hazard_report table is either 0 or 1 (binary). The result should be empty if all
-- fields comply. Any rows shown in the output are where the field does not satisfy 
-- the data type. This test can be replicated for each data field/data type.

SELECT * FROM hazard_report WHERE emergency_action_taken NOT IN (0,1);

-- Another example testing the length of the description field in the hazard_report
-- table. Any rows shown in the output are where the description field is too long.

SELECT * FROM hazard_report WHERE LEN(description) > 500;

-- LOGIC CHECKS
-- This test ensures the data follows sensible logic and can be applied to a variety
-- of different scenarios depending on the tables and their contents.
-- The example below checks that when compensation if offered to the tenant, a
-- compensation amount greater than 0 is present. Any rows shown in the output are 
-- where the data fields do not satisfy the required logic.
-- This test can be replicated for any logic required across each table.

SELECT * FROM escalation WHERE compensation_offered = 1 AND (compensation_amount IS NULL OR compensation_amount < 0);

-- DUPLICATION CHECKS
-- This test ensures that the same combination of fields doesn't exist multiple times.
-- This test can be replicated with any combination of fields to check for duplicates.
-- The example below checks that there are not multiple entries for the same property_id,
-- tenant_id and date_reported in the hazard_report table. Any rows shown in the output are 
-- duplicated entries into the table and should be investigated to confirm they are suitable.

SELECT property_id, tenant_id, date_reported, COUNT(*) FROM hazard_report GROUP BY property_id, tenant_id, date_reported HAVING COUNT(*) > 1;