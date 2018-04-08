-- User Interaction Script for database for Specialty Imports --
-- By: Benjamin D. Sykes (991487635) --
-- Desc: A Program to create views and Interaction from user --

-- TODO: Fix all numerical inputs to be converter, Fix summing of data, 
-- And fix ordering of data entry so no primary keys are missing, Finish Sales Invoice Data Entry
-- Rename all tables to their correct names

-- Create Entry Sales Invoice --
ACCEPT p_saleinv PROMPT 'Enter sales invoice #: '
-- SET SALE DATE AS SYSDATE
ACCEPT p_name PROMPT 'Enter customers name: '
ACCEPT p_street PROMPT 'Enter customers street: '
ACCEPT p_city PROMPT 'Enter customers city: '
ACCEPT p_prov PROMPT 'Enter customers province: '
ACCEPT p_postal PROMPT 'Enter customers postal code: '
ACCEPT p_hphone PROMPT 'Enter home phone #: '
ACCEPT p_bphone PROMPT 'Enter work phone #: '
ACCEPT p_empname PROMPT 'Enter name of salesman: '
ACCEPT p_carserial PROMPT 'Enter car serial #: '
ACCEPT p_carmake PROMPT 'Enter car make: '
ACCEPT p_carmodel PROMPT 'Enter car model: '
ACCEPT p_caryear PROMPT 'Enter car year: '
ACCEPT p_carcolor PROMPT 'Enter car color: '
ACCEPT p_cartrim PROMPT 'Enter car trim: '
ACCEPT p_carengine PROMPT 'Enter engine type: '
ACCEPT p_salescovFire PROMPT 'Fire damage coverage? [Y/N]: '
ACCEPT p_salescovCol PROMPT 'Collision damage coverage? [Y/N]: '
ACCEPT p_salescovLiab PROMPT 'Liability damage coverage? [Y/N]: '
ACCEPT p_salescovProp PROMPT 'Property damage coverage? [Y/N]: '
ACCEPT p_optioncode PROMPT 'Enter options code: '
ACCEPT p_optiondesc PROMPT 'Enter description of option: '
ACCEPT p_optionprice PROMPT 'Enter list price of option: '
ACCEPT p_optioncost PROMPT 'Enter cost to us for option: '
ACCEPT p_tradeserial PROMPT 'Enter trade-in-car serial: '
ACCEPT p_trademake PROMPT 'Enter trade-in-car make: '
ACCEPT p_trademodel PROMPT 'Enter trade-in-car model: '
ACCEPT p_tradeyear PROMPT 'Enter trade-in-car year: '
ACCEPT p_tradecolor PROMPT 'Enter trade-in-car color: '
ACCEPT p_tradetrim PROMPT 'Enter trade-in-car trim: '
ACCEPT p_salestallow PROMPT 'Enter trade-in-car allowance: '
ACCEPT p_salesdiscount PROMPT 'Enter Discount on car: '
ACCEPT p_salestax PROMPT 'Enter sales tax: '
  -- FOLLOW WITH INSERT STATEMENTS --


-- Sales Invoice View --
CREATE OR REPLACE VIEW sales_invoice AS
  SELECT SI.saleinv, SI.saledate, CUST.cname, CUST.cstreet, CUST.ccity, 
    CUST.cprov, CUST.cpostal, CUST.chphone, EMP.empname, CAR.serial,
    CAR.make, CAR.model, CAR.cyear, CAR.color, SI.fire, SI.collision,
    SI.liability, SI.property, OPT.ocode, OPT.odesc, OPT.olist, SI.tradeserial,
    TCAR.make AS trademake, TCAR.model AS trademodel, TCAR.cyear AS tradeyear, 
    SI.tradeallow, SI.totalprice, SI.discount, SI.net, 
    SI.tax, ((SI.net + SI.tax) - (SI.discount + SI.tradeallow)) AS "Total Payable" 
  FROM saleinv SI
    JOIN customer CUST ON SI.cname = CUST.cname
    JOIN employee EMP ON SI.salesman = EMP.empname
    JOIN car CAR ON SI.serial = CAR.serial
    JOIN baseoption BO ON CAR.serial = BO.serial
    JOIN options OPT ON BO.ocode = OPT.ocode
    JOIN car TCAR ON SI.tradeserial = TCAR.serial;

-- Inquire Sales Invoice View --
ACCEPT p_invoiceno PROMPT 'Enter an invoice number: '
  SELECT * 
  FROM sales_invoice
  WHERE UPPER(saleinv) LIKE UPPER('&p_invoiceno%');

-- Create new VIR Entry -- (TEMP TOTAL COST/PRICE NUMBERS)
ACCEPT p_name PROMPT 'Enter customers name: '
ACCEPT p_street PROMPT 'Enter customers street: '
ACCEPT p_city PROMPT 'Enter customers city: '
ACCEPT p_prov PROMPT 'Enter customers province: '
ACCEPT p_carserial PROMPT 'Enter car serial #: '
ACCEPT p_carmake PROMPT 'Enter car make: '
ACCEPT p_carmodel PROMPT 'Enter car model: '
ACCEPT p_caryear PROMPT 'Enter car year: '
ACCEPT p_carcolor PROMPT 'Enter car color: '
ACCEPT p_cartrim PROMPT 'Enter car trim: '
ACCEPT p_carengine PROMPT 'Enter engine type: '
ACCEPT p_purchaseinv PROMPT 'Enter purchase invoice #: '
ACCEPT p_purchasedate PROMPT 'Enter date of purchase: '
ACCEPT p_purchasefrom PROMPT 'Enter who vehicle purchased from: '
ACCEPT p_purchasecost PROMPT 'Enter cost of vehicle for us: '
ACCEPT p_freightcost PROMPT 'Enter freight cost: '
ACCEPT p_listprice PROMPT 'Enter car list price: '
ACCEPT p_optioncode PROMPT 'Enter options code: '
ACCEPT p_optiondesc PROMPT 'Enter description of option: '
ACCEPT p_optionprice PROMPT 'Enter list price of option: '
ACCEPT p_optioncost PROMPT 'Enter cost to us for option: '
  INSERT INTO tbl_customer (cname, cstreet, ccity, cprov)
      VALUES('&p_name', '&p_street', '&p_city', '&p_prov');
  INSERT INTO tbl_car (serialno, cname, carmake, carmodel, caryear, carcolor,
    cartrim, enginetype, purchaseinvoice, purchasedate, purchasefrom, purchasecost,
    freightcost, totalcost, listprice)
      VALUES ('&p_carserial', '&p_name', '&p_carmake', '&p_carmodel', 
        '&p_caryear', '&p_carcolor', '&p_cartrim', '&p_carengine', '&p_purchaseinv',
        TO_DATE('&p_purchasedate'), '&p_purchasefrom', TO_NUMBER('&p_purchasecost'), TO_NUMBER('&p_freightcost'),
        (TO_NUMBER('&p_purchasecost') + TO_NUMBER('&p_freightcost')), TO_NUMBER('&p_listprice'));
   INSERT INTO tbl_options (ocode, odesc, olist, ocost)
      VALUES ('&p_optioncode', '&p_optiondesc', TO_NUMBER('&p_optionprice'), 
          TO_NUMBER('&p_optioncost'));

-- Vehicle Inventory Record View --
CREATE OR REPLACE VIEW vehicle_inventory_record AS
  SELECT CAR.serial, CAR.make, CAR.model, CAR.cyear, CAR.color, CAR.trim,
    CAR.purchfrom, CAR.purchinv, CAR.purchdate, CAR.purchcost,
    CAR.listprice, OPT.ocode, OPT.odesc, OPT.olist
  FROM car CAR
    JOIN baseoption BO ON CAR.serial = BO.serial
    JOIN options OPT ON BO.ocode = OPT.ocode;
    
-- Inquire Vehicle Inventory Record View --
ACCEPT p_serial PROMPT 'Enter vehicle serial #: '
  SELECT *
  FROM vehicle_inventory_record
  WHERE UPPER(serial) LIKE UPPER('&p_serial%');

-- Create new Service Entry --
ACCEPT p_invno PROMPT 'Enter Service Invoice #: '
ACCEPT p_name PROMPT 'Enter customers name: '
ACCEPT p_street PROMPT 'Enter customers street: '
ACCEPT p_city PROMPT 'Enter customers city: '
ACCEPT p_prov PROMPT 'Enter customers province: '
ACCEPT p_postal PROMPT 'Enter customers postal code: '
ACCEPT p_hphone PROMPT 'Enter home phone #: '
ACCEPT p_bphone PROMPT 'Enter work phone #: '
ACCEPT p_carserial PROMPT 'Enter car serial #: '
ACCEPT p_carmake PROMPT 'Enter car make: '
ACCEPT p_carmodel PROMPT 'Enter car model: '
ACCEPT p_caryear PROMPT 'Enter car year: '
ACCEPT p_carcolor PROMPT 'Enter car color: '
ACCEPT p_cartrim PROMPT 'Enter car trim: '
ACCEPT p_carengine PROMPT 'Enter engine type: '
ACCEPT p_purchaseinv PROMPT 'Enter purchase invoice #: '
ACCEPT p_purchasedate PROMPT 'Enter date of purchase: '
ACCEPT p_purchasefrom PROMPT 'Enter who vehicle purchased from: '
ACCEPT p_purchasecost PROMPT 'Enter cost of vehicle for us: '
ACCEPT p_freightcost PROMPT 'Enter freight cost: '
ACCEPT p_listprice PROMPT 'Enter car list price: '
ACCEPT p_workdesc PROMPT 'Enter work to be done: '
ACCEPT p_partcost PROMPT 'Enter parts cost: '
ACCEPT p_labourcost PROMPT 'Enter labour cost: '
ACCEPT p_tax PROMPT 'Enter tax amount: '
  INSERT INTO tbl_service_invoice (svcinvoice, servicedate, cname, serialno,
    partcost, labourcost, tax, totalcost)
      VALUES ('&p_invno', SYSDATE, '&p_name', '&p_carserial', TO_NUMBER('&p_partcost'),
        TO_NUMBER('&p_labourcost'), TO_NUMBER('&p_tax'), SUM(TO_NUMBER('&p_partcost'), TO_NUMBER('&p_labourcost'),
        TO_NUMBER('&p_tax')));
  INSERT INTO tbl_customer (cname, cstreet, ccity, cprov, cpostal, chphone, cbphone)
    VALUES('&p_name', '&p_street', '&p_city', '&p_prov', '&p_postal',
      '&p_hphone', '&p_bphone');
  INSERT INTO tbl_car (serialno, cname, carmake, carmodel, caryear, carcolor,
    cartrim, enginetype, purchaseinvoice, purchasedate, purchasefrom, purchasecost,
    freightcost, totalcost, listprice)
      VALUES ('&p_carserial', '&p_name', '&p_carmake', '&p_carmodel', 
        '&p_caryear', '&p_carcolor', '&p_cartrim', '&p_carengine', '&p_purchaseinv',
        '&p_purchasedate', '&p_purchasefrom', TO_NUMBER('&p_purchasecost'), TO_NUMBER('&p_freightcost'),
        SUM(TO_NUMBER('&p_purchasecost'), TO_NUMBER('&p_freightcost')), TO_NUMBER('&p_listprice'));
  INSERT INTO tbl_service_work (svcinvoice, workdesc)
    VALUES (p_invno, p_workdesc);


-- Service Invoice & Work Order View --
CREATE OR REPLACE VIEW service_work AS
  SELECT SVC.servinv, SVC.serdate, CUST.cname, CUST.cstreet, CUST.ccity,
    CUST.cprov, CUST.cpostal, CUST.chphone, CUST.cbphone, SVC.serial, CAR.make,
    CAR.model, CAR.cyear, CAR.color, WRK.workdesc, SVC.partscost,
    SVC.labourcost, SVC.tax, SVC.totalcost
  FROM servinv SVC
    JOIN customer CUST ON SVC.cname = CUST.cname
    JOIN car CAR ON SVC.serial = CAR.serial
    JOIN servwork WRK ON SVC.servinv = WRK.servinv;
    
-- Inquire Service Invoice & Work Order --
ACCEPT p_svcinvoice PROMPT 'Enter your service invoice #: '
  SELECT *
  FROM service_work
  WHERE UPPER(servinv) LIKE UPPER('&p_svcinvoice%');
  
-- Enter data for new customer --
ACCEPT p_name PROMPT 'Enter customers name: '
ACCEPT p_street PROMPT 'Enter customers street: '
ACCEPT p_city PROMPT 'Enter customers city: '
ACCEPT p_prov PROMPT 'Enter customers province: '
ACCEPT p_postal PROMPT 'Enter customers postal code: '
ACCEPT p_hphone PROMPT 'Enter home phone #: '
ACCEPT p_bphone PROMPT 'Enter work phone #: '
  INSERT INTO tbl_customer (cname, cstreet, ccity, cprov, cpostal, chphone, cbphone)
    VALUES('&p_name', '&p_street', '&p_city', '&p_prov', '&p_postal',
      '&p_hphone', '&p_bphone');
      
-- Customer View --
CREATE OR REPLACE VIEW customer_view AS
  SELECT cname AS full_name, cstreet, ccity, cprov, cpostal, chphone, cbphone
  FROM customer;

-- Inquire Customer View --
ACCEPT p_name PROMPT 'Enter customers name: '
  SELECT *
  FROM customer_view
  WHERE UPPER(full_name) LIKE UPPER('&p_name%');

-- Create new Prospect Entry --
ACCEPT p_name PROMPT 'Enter customer name: '
ACCEPT p_carmake PROMPT 'Enter car make: '
ACCEPT p_carmodel PROMPT 'Enter car model: '
ACCEPT p_caryear PROMPT 'Enter car year: '
ACCEPT p_carcolor PROMPT 'Enter car color: '
ACCEPT p_cartrim PROMPT 'Enter car trim: '
ACCEPT p_optioncode PROMPT 'Enter options code: '
ACCEPT p_optiondesc PROMPT 'Enter description of option: '
ACCEPT p_optionprice PROMPT 'Enter list price of option: '
ACCEPT p_optioncost PROMPT 'Enter cost to us for option: '
  INSERT INTO tbl_options (ocode, odesc, olist, ocost)
    VALUES ('&p_optioncode', '&p_optiondesc', TO_NUMBER('&p_optionprice'), 
      TO_NUMBER('&p_optioncost'));
  INSERT INTO tbl_prospect_list (cname, carmake, carmodel, caryear, carcolor, 
    cartrim, ocode)
      VALUES ('&p_name', '&p_carmake', '&p_carmodel', '&p_caryear',
        '&p_carcolor', '&p_cartrim', '&p_optioncode');

-- Prospect List View --
CREATE OR REPLACE VIEW prospect_list AS
  SELECT cname, make, model, cyear, color, trim, OPT.odesc
  FROM prospect PLST
    JOIN options OPT ON PLST.ocode = OPT.ocode;
    
-- COMMIT CHANGES TO TABLES --
COMMIT;
  