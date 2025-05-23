-- TenantPerson Table
CREATE TABLE TenantPerson (
  TenantID VARCHAR(50) PRIMARY KEY,
  FullName VARCHAR(255) NOT NULL,
  DateOfBirth DATE,
  ContactDetails TEXT,
  VulnerabilityFlag BOOLEAN DEFAULT FALSE,
  PersonAlertCode VARCHAR(50)
);

-- Tenancy Table
CREATE TABLE Tenancy (
  TenancyID VARCHAR(50) PRIMARY KEY,
  TenantID VARCHAR(50) NOT NULL,
  AddressID VARCHAR(50) NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE,
  TenancyType VARCHAR(100),
  TenancyStatus VARCHAR(100),
  CONSTRAINT FK_Tenancy_Tenant FOREIGN KEY (TenantID) REFERENCES TenantPerson(TenantID)
);

-- HouseholdMemberPerson Table
CREATE TABLE HouseholdMemberPerson (
  HouseholdMemberID VARCHAR(50) PRIMARY KEY,
  TenantID VARCHAR(50) NOT NULL,
  TenancyID VARCHAR(50) NOT NULL,
  FullName VARCHAR(255) NOT NULL,
  DateOfBirth DATE,
  RelationshipToTenant VARCHAR(100),
  IsContractHolder BOOLEAN DEFAULT FALSE,
  VulnerabilityDetails TEXT,
  PersonAlertCode VARCHAR(50),
  RiskAssessmentStatus VARCHAR(100),
  RiskAssessmentDate DATE,
  CONSTRAINT FK_HouseholdMember_Tenant FOREIGN KEY (TenantID) REFERENCES TenantPerson(TenantID),
  CONSTRAINT FK_HouseholdMember_Tenancy FOREIGN KEY (TenancyID) REFERENCES Tenancy(TenancyID)
);
