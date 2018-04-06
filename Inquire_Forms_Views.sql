-- User Interaction Script for database for Specialty Imports --
-- By: Benjamin D. Sykes (991487635) --
-- Desc: A Program to create views and Interaction from user --

-- TODO: Fix all numerical inputs to be converter, Fix summing of data, 
-- And fix ordering of data entry so no primary keys are missing, Finish Sales Invoice Data Entry

-- Create Entry Sales Invoice --


-- Sales Invoice View --
CREATE OR REPLACE VIEW sales_invoice AS
  SELECT SI.saleinvoice, SI.saledate, CUST.cname, CUST.cstreet, CUST.ccity, 
    CUST.cprov, CUST.cpostal, CUST.chphone, EMP.empname, CAR.serialno,
    CAR.carmake, CAR.carmodel, CAR.caryear, CAR.carcolor, SI.covfire, SI.covcollission,
    SI.covliability, SI.covproperty, OPT.ocode, OPT.odesc, OPT.olist, SI.tradeserial,
    TCAR.carmake AS trademake, TCAR.carmodel AS trademodel, TCAR.caryear AS tradeyear, 
    SI.tradeallowance, SI.totalprice, SI.discount, SI.net, 
    SI.tax, ((SI.net + SI.tax) - (SI.discount + SI.tradeallowance)) AS "Total Payable" 
  FROM tbl_sales_invoice SI
    JOIN tbl_customer CUST ON SI.cname = CUST.cname
    JOIN tbl_employee EMP ON SI.empname = EMP.empname
    JOIN tbl_car CAR ON SI.serialno = CAR.serialno
    JOIN tbl_base_option BO ON CAR.serialno = BO.serialno
    JOIN tbl_options OPT ON BO.ocode = OPT.ocode
    JOIN tbl_car TCAR ON SI.tradeserial = TCAR.serialno;

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


  INSERT INTO tbl_customer (cname, cstreet, ccity, cprov)
    VALUES('&p_name', '&p_street', '&p_city', '&p_prov');
      
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
  SELECT CAR.serialno, CAR.carmake, CAR.carmodel, CAR.caryear, CAR.carcolor, CAR.cartrim,
    CAR.purchasefrom, CAR.purchaseinvoice, CAR.purchasedate, CAR.purchasecost,
    CAR.listprice, OPT.ocode, OPT.odesc, OPT.olist
  FROM tbl_car CAR
    JOIN tbl_base_option BO ON CAR.serialno = BO.serialno
    JOIN tbl_options OPT ON BO.ocode = OPT.ocode;
    
-- Inquire Vehicle Inventory Record View --
ACCEPT p_serialno PROMPT 'Enter vehicle serial #: '
  SELECT *
  FROM vehicle_inventory_record
  WHERE UPPER(serialno) LIKE UPPER('&p_serialno%');

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
  SELECT SVC.svcinvoice, SVC.servicedate, CUST.cname, CUST.cstreet, CUST.ccity,
    CUST.cprov, CUST.cpostal, CUST.chphone, CUST.cbphone, SVC.serialno, CAR.carmake,
    CAR.carmodel, CAR.caryear, CAR.carcolor, WRK.workdesc, SVC.partcost,
    SVC.labourcost, SVC.tax, SVC.totalcost
  FROM tbl_service_invoice
    JOIN tbl_customer CUST ON SVC.cname = CUST.cname
    JOIN tbl_car CAR ON SVC.serialno = CAR.serialno
    JOIN tbl_service_work WRK ON SVC.svcinvoice = WRK.svcinvoice;
    
-- Inquire Service Invoice & Work Order --
ACCEPT p_svcinvoice PROMPT 'Enter your service invoice #: '
  SELECT *
  FROM service_work
  WHERE UPPER(svcinvoice) LIKE UPPER('&p_svcinvoice%');
  
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
CREATE OR REPLACE VIEW customer AS
  SELECT cname AS full_name, cstreet, ccity, cprov, cpostal, chphone, cbphone
  FROM tbl_customer;

-- Inquire Customer View --
ACCEPT p_name PROMPT 'Enter customers name: '
  SELECT *
  FROM customer
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
  SELECT cname, carmake, carmodel, caryear, carcolor, cartrim, OPT.odesc
  FROM tbl_prospect_list PLST
    JOIN tbl_options OPT ON PLST.ocode = OPT.ocode;
    
-- COMMIT CHANGES TO TABLES --
COMMIT;
  