-- Specialty Imports Table Creation --
-- By: Benjamin D. Sykes --
-- Desc: Builds the Specialty Imports DataBase Table Structure --

-- START by dropping all existing tables (if any) TOTAL: 10

SET serveroutput ON; -- Set DBMS Server output for console.

-- DROP SERVWORK
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE servwork';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped ServWork";

-- DROP SERVINV
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE servinv';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped ServInv";

-- DROP INVOPTION
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE invoption';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped InvOption";

-- DROP SALEINV
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE saleinv';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped SaleInv";

-- DROP EMPLOYEE
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE employee';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped Employee";

-- DROP PROSPECT
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE prospect';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped Prospect";

-- DROP BASEOPTION
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE baseoption';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped BaseOption";

-- DROP CAR
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE car';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped Car";

-- DROP CUSTOMER
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE customer';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped Customer";

-- DROP OPTIONS
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE options';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
PROMPT "Dropped Options";

-- Create the tables (again if needed) --

-- CUSTOMER TABLE --
CREATE TABLE customer (
  CName CHAR(20) NOT NULL, -- PK
  CStreet CHAR(20),
  CCity CHAR(20),
  CProv CHAR(20),
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

-- CAR TABLE --
CREATE TABLE car (
  Serial CHAR(8) NOT NULL, -- PK
  CName CHAR(20), -- FK
  Make CHAR(10) NOT NULL,
  Model CHAR(8) NOT NULL,
  CYear CHAR(4) NOT NULL,
  Color CHAR(12) NOT NULL,
  Trim CHAR(16) NOT NULL,
  EngineType CHAR(10) NOT NULL,
  Purchinv CHAR(6),
  Purchdate DATE,
  Purchfrom CHAR(12),
  Purchcost NUMBER(9,2),
  FreightCost NUMBER(9,2),
  TotalCost NUMBER(9,2),
  ListPrice NUMBER(9,2),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_car_serialno PRIMARY KEY(serial),
    CONSTRAINT fk_car_cname FOREIGN KEY(CName) REFERENCES customer(CName)
);

-- SERVICE INVOICE TABLE --
CREATE TABLE servinv (
  servinv CHAR(5) NOT NULL, -- PK
  serdate DATE NOT NULL,
  CName CHAR(20) NOT NULL, -- FK
  Serial CHAR(8), -- FK
  PartsCost NUMBER(7,2),
  LabourCost NUMBER(7,2),
  Tax NUMBER(6,2),
  TotalCost NUMBER(8,2),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_servInv_svcinvoice PRIMARY KEY(servinv),
    CONSTRAINT fk_servInv_cname FOREIGN KEY(CName) REFERENCES customer(CName),
    CONSTRAINT fk_servInv_carserialno FOREIGN KEY(serial) REFERENCES car(serial)
);

-- SERVICE WORK TABLE --
CREATE TABLE servwork (
  servinv CHAR(5) NOT NULL, -- FK
  workdesc CHAR(80) NOT NULL,
  -- ADD CONSTRAINTS --
    CONSTRAINT fk_servwork_servinv FOREIGN KEY(servinv) REFERENCES servinv(servinv)
);

-- EMPLOYEE TABLE --
CREATE TABLE employee (
  EMPName CHAR(20) NOT NULL, -- PK
  StartDate DATE,
  Manager CHAR(20),
  CommissionRate NUMBER(2,0),
  Title CHAR(26),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_employee_empname PRIMARY KEY(EMPName)
);

-- PROSPECT LIST TABLE --
CREATE TABLE prospect (
  CName CHAR(20) NOT NULL, -- PK
  Make CHAR(10) NOT NULL,
  Model CHAR(8),
  CYear CHAR(4),
  Color CHAR(12),
  Trim CHAR(16),
  OCode CHAR(4), -- FK
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_prosp_cname FOREIGN KEY(CName) REFERENCES customer(cname),
    CONSTRAINT fk_prosp_ocode FOREIGN KEY(OCode) REFERENCES options(OCode)
);

-- BASE OPTION TABLE --  (COMPOSITE PK)
CREATE TABLE baseoption (
  Serial CHAR(8) NOT NULL, -- PK
  OCode CHAR(4) NOT NULL, -- PK
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_base_carserialno PRIMARY KEY(Serial, OCode)
);

-- SALES INVOICE TABLE --
CREATE TABLE saleinv (
  saleinv CHAR(6) NOT NULL, -- PK
  CName CHAR(20) NOT NULL, -- FK
  salesman CHAR(20), -- FK
  SaleDate DATE NOT NULL,
  serial CHAR(8) NOT NULL, -- FK
  Discount NUMBER,
  Net NUMBER,
  Tax NUMBER,
  TotalPrice NUMBER,
  licfee NUMBER,
  Comission NUMBER,
  TradeSerial CHAR(8),
  TradeAllow NUMBER,
  Fire CHAR(1),
  Collision CHAR(1),
  Liability CHAR(1),
  Property CHAR(1),
  -- ADD CONSTRAINTS --
    CONSTRAINT pk_si_salesinvoice PRIMARY KEY(saleinv),
    CONSTRAINT fk_si_cname FOREIGN KEY(CName) REFERENCES customer(CName),
    CONSTRAINT fk_si_empname FOREIGN KEY(salesman) REFERENCES employee(EMPName),
    CONSTRAINT fk_si_carserialno FOREIGN KEY(serial) REFERENCES car(serial),
    CONSTRAINT chk_covfire CHECK(Fire IN('Y', 'N')),
    CONSTRAINT chk_covliab CHECK(Liability IN('Y', 'N')),
    CONSTRAINT chk_covcollission CHECK(Collision IN('Y', 'N')),
    CONSTRAINT chk_covproperty CHECK(Property IN('Y', 'N'))
);

-- INVOICE OPTION TABLE --
CREATE TABLE invoption (
  saleinv CHAR(6) NOT NULL, -- FK
  OCode CHAR(4) NOT NULL, -- FK
  SalePrice NUMBER(7,2) NOT NULL,
  -- ADD CONSTRAINTS --
    CONSTRAINT fk_invopt_saleinv FOREIGN KEY(saleinv) REFERENCES saleinv(saleinv),
    CONSTRAINT fk_invopt_ocode FOREIGN KEY(ocode) REFERENCES options(ocode)
);

