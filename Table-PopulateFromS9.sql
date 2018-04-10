-- TABLE POPULATOR
-- By: Benjamin D. Sykes
-- DESC: Used to copy data from the S9 Schema in order to populate tables in
--       Your own schema with the data from the S9 Schema

-- Populate Customer Table --
INSERT INTO customer (SELECT * FROM s9.customer);

-- Populate Car Table --
INSERT INTO car (SELECT * FROM s9.car);

-- Populate Employee Table --
INSERT INTO employee (SELECT * FROM s9.employee);

-- Populate Sales Invoice Table --
INSERT INTO saleinv (SELECT * FROM s9.saleinv);

-- Populate Service Invoice Table --
INSERT INTO servinv (SELECT * FROM s9.servinv);

-- Populate Service Work Table --
INSERT INTO servwork (SELECT * FROM s9.servwork);

-- Populate Base Option Table --
INSERT INTO baseoption (SELECT * FROM s9.baseoption);

-- Populate options table --
INSERT INTO options (SELECT * FROM s9.options);

-- Populate Prospect Table --
INSERT INTO prospect (SELECT * FROM s9.prospect);

-- Populate Invoice Option Table --
INSERT INTO invoption (SELECT * FROM s9.invoption);
-- >
-- >
-- >
-- >
-- TEST IMPORTING (UNCOMMENT TO USE) --

/*

SELECT * FROM baseoption;
SELECT * FROM car;
SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM invoption;
SELECT * FROM options;
SELECT * FROM prospect;
SELECT * FROM saleinv;
SELECT * FROM servinv;
SELECT * FROM servwork;

*/