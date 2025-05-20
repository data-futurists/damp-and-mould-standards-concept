-- --------------------------------------------------
-- Table: Site
-- --------------------------------------------------
CREATE TABLE Site (
  SiteID INTEGER PRIMARY KEY,
  SiteName VARCHAR(255) NOT NULL,
  ShapeID INTEGER
);

-- --------------------------------------------------
-- Table: Property
-- --------------------------------------------------
CREATE TABLE Property (
  PropertyID INTEGER PRIMARY KEY,
  PropertyName VARCHAR(255),
  HierarchyElementID INTEGER,
  SiteID INTEGER,
  GeographicalLocationID VARCHAR(255),
  epcCertificationID VARCHAR(255),
  CONSTRAINT fk_property_site
    FOREIGN KEY(SiteID)
      REFERENCES Site(SiteID)
);

-- --------------------------------------------------
-- Table: Unit
-- --------------------------------------------------
CREATE TABLE Unit (
  UnitID INTEGER PRIMARY KEY,
  PropertyID INTEGER,
  AlertRegardingLocationID VARCHAR(255),
  Lease VARCHAR(255),
  CONSTRAINT fk_unit_property
    FOREIGN KEY(PropertyID)
      REFERENCES Property(PropertyID)
);

-- --------------------------------------------------
-- Table: Address
-- --------------------------------------------------
CREATE TABLE Address (
  AddressID INTEGER PRIMARY KEY,
  UnitID INTEGER,
  AddressLine VARCHAR(255),
  BuildingName VARCHAR(255),
  StreetName VARCHAR(255),
  BuildingNumber VARCHAR(255),
  Floor INTEGER,
  Room INTEGER,
  Country VARCHAR(255),
  PostalCode VARCHAR(255),
  CONSTRAINT fk_address_unit
    FOREIGN KEY(UnitID)
      REFERENCES Unit(UnitID)
);

-- --------------------------------------------------
-- Table: PhysicalCharacteristics
-- --------------------------------------------------
CREATE TABLE PhysicalCharacteristics (
  PhysicalCharacteristicsID INTEGER PRIMARY KEY,
  PropertyID INTEGER,
  WindowGlazing VARCHAR(255),
  PrincipalWallInsulation VARCHAR(255),
  PrincipalRoofInsulation VARCHAR(255),
  VentilationType VARCHAR(255),
  BuiltYear INTEGER,
  ConstructionType VARCHAR(255),
  LastUpdatedDate DATE,
  CONSTRAINT fk_phys_property
    FOREIGN KEY(PropertyID)
      REFERENCES Property(PropertyID)
);

-- --------------------------------------------------
-- Table: HeatingSystemTypeBuildingSystemType
-- --------------------------------------------------
CREATE TABLE HeatingSystemTypeBuildingSystemType (
  HeatingSystemTypeID INTEGER PRIMARY KEY,
  PropertyID INTEGER,
  EnergyUseControl VARCHAR(255),
  HeatConversionMethod VARCHAR(255),
  For VARCHAR(255),
  SmartSystem INTEGER,
  InstallationDate DATE,
  Manufacturer VARCHAR(255),
  ModelNumber VARCHAR(255),
  LastServicedDate DATE,
  Notes VARCHAR(255),
  CONSTRAINT fk_heat_property
    FOREIGN KEY(PropertyID)
      REFERENCES Property(PropertyID)
);

-- --------------------------------------------------
-- Table: ThermalTransmittance
-- --------------------------------------------------
CREATE TABLE ThermalTransmittance (
  ThermalTransmittanceID INTEGER PRIMARY KEY,
  PhysicalCharacteristicsID INTEGER,
  UValue NUMERIC(5,3),
  Element VARCHAR(255),
  MeasurementDate DATE,
  Notes VARCHAR(255),
  CONSTRAINT fk_thermal_phys
    FOREIGN KEY(PhysicalCharacteristicsID)
      REFERENCES PhysicalCharacteristics(PhysicalCharacteristicsID)
);

-- --------------------------------------------------
-- Table: EnergyPerformanceCertificationComponentCertification
-- --------------------------------------------------
CREATE TABLE EnergyPerformanceCertificationComponentCertification (
  EPCID INTEGER PRIMARY KEY,
  UnitID INTEGER,
  CertificateNumber VARCHAR(255),
  CurrentEnergyEfficiencyRating VARCHAR(255),
  CurrentEnergyEfficiencyBand VARCHAR(255),
  PotentialEnergyEfficiencyRating VARCHAR(255),
  PotentialEnergyEfficiencyBand VARCHAR(255),
  CurrentEnvironmentalImpactRating VARCHAR(255),
  CurrentEnvironmentalImpactBand VARCHAR(255),
  PotentialEnvironmentalImpactRating VARCHAR(255),
  PotentialEnvironmentalImpactBand VARCHAR(255),
  CO2PerYear INTEGER,
  SpaceHeatingCostPerYear NUMERIC(10,2),
  WaterHeatingCostPerYear NUMERIC(10,2),
  LightingCostPerYear NUMERIC(10,2),
  TotalEstimatedEnergyCostPerYear NUMERIC(12,2),
  EnergyUsePerSquareMeterPerYear INTEGER,
  RecommendationSummary VARCHAR(255),
  CONSTRAINT fk_epc_unit
    FOREIGN KEY(UnitID)
      REFERENCES Unit(UnitID)
);

-- --------------------------------------------------
-- Table: Certification
-- --------------------------------------------------
CREATE TABLE Certification (
  CertificationID INTEGER PRIMARY KEY,
  UnitID INTEGER,
  CertificationType VARCHAR(255),
  IssueDate DATE,
  ExpiryDate DATE,
  IssuedBy VARCHAR(255),
  Status VARCHAR(255),
  AttachmentURL VARCHAR(2048),
  CONSTRAINT fk_cert_unit
    FOREIGN KEY(UnitID)
      REFERENCES Unit(UnitID)
);
