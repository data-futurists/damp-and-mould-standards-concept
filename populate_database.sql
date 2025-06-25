-- --------------------------------------------------
-- Dummy Data: Sites & Properties & Units
-- --------------------------------------------------

INSERT INTO site (site_id, site_name) VALUES
  (1, 'Site Alpha'),
  (2, 'Site Beta');

INSERT INTO property (property_id, property_name, site_id) VALUES
  (1, 'Alpha Tower',    1),
  (2, 'Alpha Annex',    1),
  (3, 'Beta Residence', 2);

INSERT INTO unit (unit_id, property_id, alert_type_id, lease) VALUES
  -- original 6 units
  (1, 1,  3,    'Leasehold'),
  (2, 1,  8,    'Freehold'),
  (3, 2,  2,    'Leasehold'),
  (4, 2, NULL,  'Tenancy'),
  (5, 3,  5,    'Freehold'),
  (6, 3,  6,    'Tenancy'),
  -- extra units to match 10 addresses
  (7, 1, NULL,  'Tenancy'),
  (8, 2,  1,    'Leasehold'),
  (9, 3,  4,    'Freehold'),
  (10,1,  5,    'Tenancy');

-- --------------------------------------------------
-- Dummy Data: 10 Addresses
-- --------------------------------------------------

INSERT INTO address (
  address_id, unit_id, uprn, address_line, building_name,
  street_name, building_number, floor, city_name, country, post_code
) VALUES
  ( 1,  1, 100000001, 'Flat 1A, Rosewood Court',  'Rosewood Court', 'Rose Street',   '12',  1, 'London',     'UK', 'SW1A 2AA'),
  ( 2,  2, 100000002, 'Flat 2B, Rosewood Court',  'Rosewood Court', 'Rose Street',   '12',  2, 'London',     'UK', 'SW1A 2AA'),
  ( 3,  3, 100000003, 'Apt 3, Maple Heights',     'Maple Heights',  'Maple Road',    '5',   1, 'Manchester', 'UK', 'M1 1AB'),
  ( 4,  4, 100000004, 'Apt 7, Maple Heights',     'Maple Heights',  'Maple Road',    '5',   2, 'Manchester', 'UK', 'M1 1AB'),
  ( 5,  5, 100000005, 'Suite 10, Elm Plaza',      'Elm Plaza',      'Elm Street',    '20',  3, 'Birmingham', 'UK', 'B1 2CD'),
  ( 6,  6, 100000006, 'Office 4, Elm Plaza',      'Elm Plaza',      'Elm Street',    '20',  1, 'Birmingham', 'UK', 'B1 2CD'),
  ( 7,  7, 100000007, 'Penthouse, Oak Tower',     'Oak Tower',      'Oak Avenue',    '1',  10, 'Liverpool',  'UK', 'L1 3EF'),
  ( 8,  8, 100000008, 'Flat 2, Pine Court',       'Pine Court',     'Pine Crescent', '8',   2, 'Glasgow',    'UK', 'G1 4GH'),
  ( 9,  9, 100000009, 'Studio, Birch House',      'Birch House',    'Birch Lane',    '15',  1, 'Cardiff',    'UK', 'CF10 1SP'),
  (10, 10, 100000010, 'Loft 5, Cedar Lofts',      'Cedar Lofts',    'Cedar Street',  '3',   2, 'Leeds',      'UK', 'LS1 2TE');

-- --------------------------------------------------
-- Dummy Data: Physical Characteristics
-- --------------------------------------------------

INSERT INTO physical_characteristics (
  physical_char_id, property_id,
  window_glazing_type_id, wall_insulation_type_id, roof_insulation_type_id,
  ventilation_type, built_year, construction_type_id, last_updated_date
) VALUES
  (1, 1, 4, 3, 2, 'Natural Ventilation', 1995, 2, '2023-07-01'),
  (2, 2, 5, 4, 1, 'Mechanical Ventilation', 2005, 1, '2023-07-10'),
  (3, 3, 2, 2, 3, 'Natural Ventilation', 2010, 3, '2023-07-15');

-- --------------------------------------------------
-- Dummy Data: Heating Systems
-- --------------------------------------------------

INSERT INTO heating_system (
  heating_system_id, property_id, energy_control,
  heat_conversion_method, purpose, is_smart_system,
  installation_date, manufacturer, model_number,
  last_serviced_date, notes
) VALUES
  (1, 1, 'Thermostat',        'Gas Boiler',       'Heating', FALSE, '2010-05-20', 'HeatCo',     'HB-100', '2023-06-15', 'No issues'),
  (2, 2, 'Smart Thermostat',  'Electric Radiator','Heating', TRUE,  '2015-09-12', 'ElectroHeat','ER-200', '2023-05-10', 'Battery replaced'),
  (3, 3, 'Dial Control',      'Heat Pump',        'Heating', TRUE,  '2018-11-05', 'PumpMaster', 'PM-300', '2023-04-20', 'Firmware updated');

-- --------------------------------------------------
-- Dummy Data: Thermal Transmittance
-- --------------------------------------------------

INSERT INTO thermal_transmittance (
  thermal_trans_id, physical_char_id,
  u_value, element, measurement_date, notes
) VALUES
  (1, 1, 0.250, 'Wall',   '2023-07-01', 'Measured after retrofit'),
  (2, 1, 1.800, 'Window', '2023-07-02', 'Single glazed'),
  (3, 2, 0.300, 'Roof',   '2023-07-08', 'Insulated underboards'),
  (4, 3, 0.200, 'Wall',   '2023-07-15', 'External insulation');

-- --------------------------------------------------
-- Dummy Data: Energy Performance Certifications
-- --------------------------------------------------

INSERT INTO energy_performance_certification (
  epc_id, unit_id, certificate_number,
  current_energy_rating, current_energy_band,
  potential_energy_rating, potential_energy_band,
  current_env_impact_rating, current_env_impact_band,
  potential_env_impact_rating, potential_env_impact_band,
  co2_per_year,
  space_heating_cost_year,
  water_heating_cost_year,
  lighting_cost_year,
  total_energy_cost_year,
  energy_use_per_sqm_year,
  recommendation_summary
) VALUES
  (1, 1, 'EPC0001', 65, '3', 75, '2', 60, '3', 70, '2', 1200, 350.50, 150.75,  75.25, 576.50, 120, 'Upgrade windows to double glazing'),
  (2, 2, 'EPC0002', 80, '2', 85, '1', 70, '2', 80, '1',  900, 300.00, 100.00,  60.00, 460.00, 100, 'Improve roof insulation'),
  (3, 3, 'EPC0003', 55, '4', 70, '2', 50, '4', 65, '2', 1500, 400.00, 200.00, 100.00, 700.00, 140, 'Install smart heating control'),
  (4, 4, 'EPC0004', 72, '3', 78, '2', 68, '3', 75, '2', 1100, 330.00, 120.00,  65.00, 515.00, 115, 'Add loft insulation'),
  (5, 5, 'EPC0005', 90, '2', 95, '1', 85, '2', 92, '1',  700, 250.00,  80.00,  50.00, 380.00,  90, 'No immediate actions'),
  (6, 6, 'EPC0006', 45, '5', 65, '3', 40, '5', 60, '3', 1800, 450.00, 250.00, 120.00, 820.00, 150, 'Full cavity wall insulation');

-- --------------------------------------------------
-- Dummy Data: Other Certifications
-- --------------------------------------------------

INSERT INTO certification (
  certification_id, unit_id, certification_type_id,
  issue_date, expiry_date, issued_by, status, attachment_url
) VALUES
  (1, 1, 1, '2022-01-15', '2023-01-15', 'Inspector A', 'Expired', 'http://example.com/eicr1.pdf'),
  (2, 1, 3, '2023-02-01', '2024-02-01', 'GasSafe Ltd','Active',  'http://example.com/lgsr1.pdf'),
  (3, 2, 4, '2023-03-10', '2024-03-10', 'FireWatch Co','Active', 'http://example.com/fra2.pdf'),
  (4, 3, 7, '2023-04-12', '2024-04-12', 'EnergyCert', 'Active',  'http://example.com/epc3.pdf'),
  (5, 5, 2, '2022-06-20', '2023-06-20', 'Inspector B','Expired', 'http://example.com/eic2.pdf'),
  (6, 6, 5, '2023-05-05', '2024-05-05', 'PATTesters', 'Active',  'http://example.com/pat6.pdf');

-- --------------------------------------------------
-- Dummy Data: tenant_person
-- --------------------------------------------------

 INSERT INTO tenant_person (tenant_id, full_name, person_alert_type_id, date_of_birth, phone_number, email, vulnerability_flag) VALUES
  (1, 'Paul Hall', '15.0', '2004-01-19', '44335014151', 'paul.hall@housingexample.co.uk', 'False'),
  (2, 'Mohamed Davies', 'nan', '1939-05-27', '44915395029', 'mohamed.davies@housingexample.co.uk', 'True'),
  (3, 'Geoffrey Jordan', 'nan', '2004-01-04', '44800538116', 'geoffrey.jordan@housingexample.co.uk', 'False'),
  (4, 'Beth James', '6.0', '2001-01-28', '44485483217', 'beth.james@housingexample.co.uk', 'False'),
  (5, 'Natalie Davies', 'nan', '1951-01-28', '44034537410', 'natalie.davies@housingexample.co.uk', 'True'),
  (6, 'Sam Marsh', 'nan', '1977-02-05', '44688609179', 'sam.marsh@housingexample.co.uk', 'False'),
  (7, 'Arthur Stevenson', 'nan', '1967-11-30', '44123872011', 'arthur.stevenson@housingexample.co.uk', 'True'),
  (8, 'Brett Stephens', 'nan', '1990-12-25', '44167605158', 'brett.stephens@housingexample.co.uk', 'True'),
  (9, 'Ashley Jackson', 'nan', '1977-08-26', '44166189702', 'ashley.jackson@housingexample.co.uk', 'False'),
  (10, 'Pauline Harding', 'nan', '1989-06-14', '44129522312', 'pauline.harding@housingexample.co.uk', 'False');

-- --------------------------------------------------
-- Dummy Data: tenancy
-- -------------------------------------------------- 

INSERT INTO tenancy (tenancy_id, tenant_id, address_id, tenancy_start_date, tenancy_end_date, tenancy_type, tenancy_status) VALUES
  (1, '1', '1', '2024-04-07', '2025-12-26', 'Secure', 'Active'),
  (2, '2', '2', '2018-01-17', '2027-01-18', 'Fixed-Term', 'Active'),
  (3, '3', '3', '2023-03-02', '2025-10-22', 'Fixed-Term', 'Active'),
  (4, '4', '4', '2017-07-16', '2027-06-17', 'Fixed-Term', 'Active'),
  (5, '5', '5', '2020-12-22', '2022-10-19', 'Fixed-Term', 'Ended'),
  (6, '6', '6', '2020-10-25', '2025-07-10', 'Introductory', 'Active'),
  (7, '7', '7', '2019-03-08', '2028-06-07', 'Secure', 'Active'),
  (8, '8', '8', '2024-09-05', '2029-03-26', 'Demoted', 'Active'),
  (9, '9', '9', '2018-11-06', '2024-03-15', 'Assured', 'Ended'),
  (10, '10', '10', '2018-12-28', '2020-02-27', 'Secure', 'Ended');

-- --------------------------------------------------
-- Dummy Data: household_member_person 
-- --------------------------------------------------

INSERT INTO household_member_person (
  household_member_id, tenant_id, tenancy_id, person_alert_type_id, full_name, date_of_birth, 
  relationship_to_tenant, is_contract_holder, vulnerability_details, risk_assessment_status, risk_assessment_date
) VALUES
  (1, '2', '2', '11.0', 'Eleanor Dean', '2016-12-20', 'Grandchild', 'False', 'RegularMissingAppointments', 'nan', 'nan'),
  (2, '3', '3', 'nan', 'Scott Roberts', '2024-12-10', 'Grandchild', 'False', 'nan', 'nan', 'nan'),
  (3, '4', '4', '22.0', 'Sandra Wood', '2021-08-24', 'Child', 'False', 'FinancialHardship', 'Low', '2024-02-02'),
  (4, '4', '4', 'nan', 'Katy Rose', '1998-12-06', 'Spouse', 'False', 'nan', 'nan', 'nan'),
  (5, '4', '4', '6.0', 'Geoffrey Murphy', '1989-03-28', 'Lodger', 'False', 'Illness', 'nan', 'nan'),
  (6, '5', '5', '27.0', 'Georgina Nolan', '1944-01-30', 'Friend', 'False', 'SensoryImpairment', 'Medium', '2023-12-24'),
  (7, '5', '5', 'nan', 'Kelly Davison', '2005-01-27', 'Friend', 'False', 'nan', 'Low', '2023-06-05'),
  (8, '5', '5', 'nan', 'Jason Jones', '1930-08-11', 'Parent', 'False', 'nan', 'High', '2024-10-31'),
  (9, '7', '7', '22.0', 'Irene Little', '1915-08-02', 'Friend', 'False', 'FinancialHardship', 'nan', 'nan'),
  (10, '7', '7', 'nan', 'Rachel Baldwin', '1978-12-23', 'Friend', 'True', 'nan', 'nan', 'nan'),
  (11, '7', '7', '9.0', 'Bradley Ward', '1957-10-26', 'Spouse', 'False', 'Elderly', 'Medium', '2024-02-20'),
  (12, '9', '9', 'nan', 'Angela Walker', '1993-10-26', 'Sibling', 'True', 'nan', 'High', '2024-11-24'),
  (13, '9', '9', 'nan', 'Jodie Holland', '1990-12-14', 'Friend', 'False', 'nan', 'Medium', '2024-03-05'),
  (14, '10', '10', '27.0', 'Lewis Johnson', '2025-03-02', 'Grandchild', 'False', 'SensoryImpairment', 'Low', '2024-10-01'),
  (15, '10', '10', 'nan', 'Kimberley Clements', '1981-07-25', 'Spouse', 'False', 'nan', 'nan', 'nan'),
  (16, '10', '10', 'nan', 'Damian Johnson', '2019-09-03', 'Child', 'False', 'nan', 'Medium', '2023-06-12');
