-- 1. SITE
CREATE TABLE Site (
  siteID       INT,
  siteName     VARCHAR(255),
  propertyID   INT
);

-- 2. PROPERTY
CREATE TABLE Property (
  propertyID             INT,
  propertyName           VARCHAR(255),
  HierarchyElementID     INT,
  siteID                 INT,
  geographicalLocationID VARCHAR(255),
  epcCertificationID     VARCHAR(255)
);

-- 3. UNIT
CREATE TABLE Unit (
  unitID                  INT,
  propertyID              INT,
  alertRegardingLocationID INT,
  lease                   VARCHAR(255)
);

-- 4. ADDRESS
CREATE TABLE Address (
  addressID     INT,
  unitID        INT,
  propertyID   INT,
  addressLine   VARCHAR(255),
  buildingName  VARCHAR(255),
  streetName    VARCHAR(255),
  buildingNumber INT,
  floor         INT,
  room          INT,
  country       VARCHAR(100),
  postalCode    VARCHAR(20)
);