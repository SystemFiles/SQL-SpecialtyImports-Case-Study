-- Specialty Imports Table Creation --
-- By: Benjamin D. Sykes --
-- Desc: Builds the Specialty Imports DataBase Table Structure --

-- START by dropping all existing tables (if any) TOTAL: 10
DROP TABLE saleinv;
DROP TABLE servinv;
DROP TABLE servwork;
DROP TABLE employee;
DROP TABLE invoption;
DROP TABLE prospect;
DROP TABLE baseoption;
DROP TABLE car;
DROP TABLE customer;
DROP TABLE options;

-- Create the tables (again if needed) --

-- CUSTOMER TABLE --
CREATE TABLE customer (
  CName CHAR(20) NOT NULL, -- PK
  CStreet CHAR(20) NOT NULL,
  CCity CHAR(20) NOT NULL,
  CProv CHAR(20) NOT NULL,
  CPostal CHAR(10),
  CHPhone CHAR(13),
  CBPhone CHAR(13),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_customer_cname PRIMARY KEY(CName)
);

-- OPTIONS TABLE --
CREATE TABLE options (
  OCode CHAR(4) NOT NULL, -- PK
  ODesc CHAR(30),
  OList NUMBER(7,2),
  OCost NUMBER(7,2),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_options_ocode PRIMARY KEY(OCode)
);

-- SERVICE WORK TABLE --
CREATE TABLE servwork (
  SvcInvoice CHAR(5) NOT NULL, -- PK
  WorkDesc CHAR(80) NOT NULL,
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_svcwork_svcinvoice PRIMARY KEY(SvcInvoice)
);

-- EMPLOYEE TABLE --
CREATE TABLE employee (
  EMPName CHAR(20) NOT NULL, -- PK
  StartDate DATE NOT NULL,
  Manager CHAR(20),
  CommissionRate NUMBER(2,0),
  Title CHAR(26),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_employee_empname PRIMARY KEY(EMPName)
);

-- INVOICE OPTION TABLE --
CREATE TABLE invoption (
  SaleInvoice CHAR(6) NOT NULL, -- PK
  OCode CHAR(4) NOT NULL, -- FK
  SalePrice NUMBER(7,2) NOT NULL,
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_invopt_saleinvoice PRIMARY KEY(SaleInvoice),
    CONSTRAINT fk_invopt_ocode FOREIGN KEY(OCode) REFERENCES options(OCode)
);

-- PROSPECT LIST TABLE --
CREATE TABLE prospect (
  CName CHAR(20) NOT NULL, -- PK
  CarMake CHAR(10) NOT NULL,
  CarModel CHAR(8),
  CarYear CHAR(4),
  CarColor CHAR(12),
  CarTrim CHAR(16),
  OCode CHAR(4) NOT NULL, -- FK
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_prosp_cname PRIMARY KEY(CName),
    CONSTRAINT fk_prosp_ocode FOREIGN KEY(OCode) REFERENCES options(OCode)
);

-- BASE OPTION TABLE --  (COMPOSITE PK)
CREATE TABLE baseoption (
  SerialNo CHAR(8) NOT NULL, -- PK
  OCode CHAR(4) NOT NULL, -- PK
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_base_carserialno PRIMARY KEY(SerialNo, OCode)
);

-- CAR TABLE --
CREATE TABLE car (
  SerialNo CHAR(8) NOT NULL, -- PK
  CName CHAR(20), -- FK
  CarMake CHAR(10) NOT NULL,
  CarModel CHAR(8) NOT NULL,
  CarYear CHAR(4) NOT NULL,
  CarColor CHAR(12) NOT NULL,
  CarTrim CHAR(16) NOT NULL,
  EngineType CHAR(10) NOT NULL,
  PurchaseInvoice CHAR(6),
  PurchaseDate DATE,
  PurchaseFrom CHAR(12),
  PurchaseCost NUMBER(9,2),
  FreightCost NUMBER(9,2),
  TotalCost NUMBER(9,2),
  ListPrice NUMBER(9,2),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_car_serialno PRIMARY KEY(SerialNo),
    CONSTRAINT fk_car_cname FOREIGN KEY(CName) REFERENCES customer(CName)
);

-- SERVICE INVOICE TABLE --
CREATE TABLE servinv (
  SvcInvoice CHAR(5) NOT NULL, -- PK
  ServiceDate DATE NOT NULL,
  CName CHAR(20) NOT NULL, -- FK
  SerialNo CHAR(8), -- FK
  PartCost NUMBER(7,2),
  LabourCost NUMBER(7,2),
  Tax NUMBER(6,2),
  TotalCost NUMBER(8,2),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_servInv_svcinvoice PRIMARY KEY(SvcInvoice),
    CONSTRAINT fk_servInv_cname FOREIGN KEY(CName) REFERENCES customer(CName),
    CONSTRAINT fk_servInv_carserialno FOREIGN KEY(SerialNo) REFERENCES car(SerialNo)
);

-- SALES INVOICE TABLE --
CREATE TABLE saleinv (
  SaleInvoice CHAR(6) NOT NULL, -- PK
  CName CHAR(20) NOT NULL, -- FK
  EMPName CHAR(20) NOT NULL, -- FK
  SaleDate DATE NOT NULL,
  SerialNo CHAR(8) NOT NULL, -- FK
  Discount NUMBER(8,2),
  Net NUMBER(9,2),
  Tax NUMBER(8,2),
  TotalPrice NUMBER(9,2),
  LicenseFee NUMBER(6,2),
  Comission NUMBER(8,2),
  TradeSerial CHAR(8),
  TradeAllowance NUMBER(9,2),
  CovFire CHAR(1),
  CovCollission CHAR(1),
  CovLiability CHAR(1),
  CovProperty CHAR(1),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_si_salesinvoice PRIMARY KEY(SaleInvoice),
    CONSTRAINT fk_si_cname FOREIGN KEY(CName) REFERENCES customer(CName),
    CONSTRAINT fk_si_empname FOREIGN KEY(EMPName) REFERENCES employee(EMPName),
    CONSTRAINT fk_si_carserialno FOREIGN KEY(SerialNo) REFERENCES car(SerialNo),
    CONSTRAINT chk_covfire CHECK(CovFire IN('Y', 'N')),
    CONSTRAINT chk_covliab CHECK(CovLiability IN('Y', 'N')),
    CONSTRAINT chk_covcollission CHECK(CovCollission IN('Y', 'N')),
    CONSTRAINT chk_covproperty CHECK(CovProperty IN('Y', 'N'))
);

