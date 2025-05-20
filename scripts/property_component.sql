-- Create the Site table
CREATE TABLE Site (
  siteID INTEGER PRIMARY KEY,
  siteName VARCHAR(255) NOT NULL,
  propertyID INTEGER NOT NULL
);

-- Create the Property table
CREATE TABLE Property (
  propertyID INTEGER PRIMARY KEY,
  siteID INTEGER NOT NULL,
  HierarchyElementID INTEGER,
  geographicalLocationID VARCHAR(255) NOT NULL,
  propertyName VARCHAR(255) NOT NULL,
  epcCertificationID VARCHAR(255) NOT NULL,
  FOREIGN KEY (siteID) REFERENCES Site(siteID)
);

-- Create the Unit table
CREATE TABLE Unit (
  unitID INTEGER PRIMARY KEY,
  propertyID INTEGER NOT NULL,
  alertRegardingLocationID INTEGER NOT NULL,
  lease VARCHAR(255) NOT NULL,
  FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
);

-- Create the Address table
CREATE TABLE Address (
  addressID INTEGER PRIMARY KEY,
  unitID INTEGER NOT NULL,
  propertyID INTEGER NOT NULL,
  AddressLine VARCHAR(255) NOT NULL,
  BuildingName VARCHAR(255),
  BuildingNumber VARCHAR(50),
  StreetName VARCHAR(255) NOT NULL,
  PostCode VARCHAR(20) NOT NULL,
  FOREIGN KEY (unitID) REFERENCES Unit(unitID),
  FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
);

-- Add foreign key constraint to Site table after Property table is created
ALTER TABLE Site
ADD CONSTRAINT fk_site_property
FOREIGN KEY (propertyID) REFERENCES Property(propertyID);
