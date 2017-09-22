--<ScriptOptions statementTerminator=";"/>

-- THIS IS A TEST
-- THIS IS ANOTHER TEST

CREATE SCHEMA "Schema";

CREATE TABLE "Schema"."CUSTOMER" (
		"CUSTOMER_CODE" INTEGER NOT NULL, 
		"CUSTOMER_FIRST_NAME" VARCHAR(128), 
		"CUSTOMER_LAST_NAME" VARCHAR(128), 
		"CUSTOMER_ADDRESS1" VARCHAR(128), 
		"CUSTOMER_CITY" VARCHAR(128), 
		"CUSTOMER_POSTAL_ZONE" VARCHAR(100), 
		"CUSTOMER_COUNTRY_CODE" VARCHAR(128), 
		"CUSTOMER_PHONE_NUMBER" VARCHAR(120), 
		"CUSTOMER_INFO" CLOB(32768), 
		"CUSTOMER_EMAIL" VARCHAR(128), 
		"CUSTOMER_GENDER_CODE" DECIMAL(3 , 0), 
		"CUSTOMER_PROVINCE_STATE" VARCHAR(128)
	)
	DATA CAPTURE NONE 
	COMPRESS NO;

CREATE TABLE "Schema"."CUSTOMER_CREDITCARD" (
		"CREDITCARD_ID" INTEGER NOT NULL, 
		"CUSTOMER_CODE" INTEGER NOT NULL, 
		"CREDITCARD_PRIMARY_ACCOUNT_NUMBER" INTEGER, 
		"CREDITCARD_SERVICE_CODE" INTEGER, 
		"CREDITCARD_EXP_DATE" DATE
	)
	DATA CAPTURE NONE 
	COMPRESS NO;

CREATE TABLE "Schema"."CUSTOMER_INVOICE" (
		"ORDER_NUMBER" INTEGER NOT NULL, 
		"ORDER_INVOICE" XML, 
		"CUSTOMER_CODE" INTEGER NOT NULL
	)
	DATA CAPTURE NONE 
	COMPRESS NO;

CREATE TABLE "Schema"."CUSTOMER_ORDER" (
		"ORDER_NUMBER" INTEGER NOT NULL, 
		"ORDER_DATE" DATE, 
		"ORDER_NUMBER_OF_ITEMS" INTEGER, 
		"ORDER_NUMBER_OF_PRODUCTS" INTEGER, 
		"ORDER_SUBTOTAL_COST" DECIMAL(30 , 2), 
		"ORDER_SHIPPING_COST" DECIMAL(30 , 2), 
		"ORDER_TAX_COST" DECIMAL(30 , 2), 
		"ORDER_TOTAL_COST" DECIMAL(30 , 2), 
		"ORDER_PAYMENT_METHOD" VARCHAR(128), 
		"ORDER_STATUS" VARCHAR(128), 
		"ORDER_METHOD_CODE" INTEGER NOT NULL, 
		"CUSTOMER_CREDITCARD_ID" INTEGER NOT NULL, 
		"CUSTOMER_CODE" INTEGER NOT NULL
	)
	DATA CAPTURE NONE 
	COMPRESS NO;

CREATE TABLE "Schema"."PARTNER_ACTIVITY" (
		"PARTNER_CODE" INTEGER NOT NULL, 
		"ORDER_NUMBER" INTEGER NOT NULL, 
		"ORDER_SUBTOTAL_COST" DECIMAL(30 , 2), 
		"ORDER_SHIPPING_COST" DECIMAL(30 , 2), 
		"ORDER_TAX_COST" DECIMAL(30 , 2), 
		"ORDER_TOTAL_COST" DECIMAL(30 , 2), 
		"ORDER_STATUS" VARCHAR(128), 
		"PARTNER_INVOICE" XML, 
		"CUSTOMER_CODE" INTEGER NOT NULL, 
		"PARTNER_CUSTOMER_CODE" VARCHAR(10)
	)
	DATA CAPTURE NONE 
	COMPRESS NO;

CREATE TABLE "Schema"."PARTNER_CONTACT" (
		"PARTNER_CODE" INTEGER NOT NULL, 
		"PARTNER_COMPANY_NAME" VARCHAR(128), 
		"PARTNER_FIRST_NAME" VARCHAR(128), 
		"PARTNER_LAST_NAME" VARCHAR(128), 
		"PARTNER_ADDRESS1" VARCHAR(128), 
		"PARTNER_PROVINCE_STATE" VARCHAR(128), 
		"PARTNER_POSTAL_ZONE" VARCHAR(100), 
		"PARTNER_COUNTRY_CODE" VARCHAR(128), 
		"PARTNER_CITY" VARCHAR(128), 
		"PARTNER_INFO" XML, 
		"ORDER_NUMBER" INTEGER NOT NULL, 
		"PARTNER_SALES" DECIMAL(30 , 2)
	)
	DATA CAPTURE NONE 
	COMPRESS NO;

ALTER TABLE "Schema"."CUSTOMER" ADD CONSTRAINT "CUSTOMER_PK" PRIMARY KEY
	("CUSTOMER_CODE");

ALTER TABLE "Schema"."CUSTOMER_CREDITCARD" ADD CONSTRAINT "CUSTOMER_CREDITCARD_PK" PRIMARY KEY
	("CREDITCARD_ID", 
	 "CUSTOMER_CODE");

ALTER TABLE "Schema"."CUSTOMER_INVOICE" ADD CONSTRAINT "CUSTOMER_INVOICE_PK" PRIMARY KEY
	("ORDER_NUMBER");

ALTER TABLE "Schema"."CUSTOMER_ORDER" ADD CONSTRAINT "CUSTOMER_ORDER_PK" PRIMARY KEY
	("CUSTOMER_CODE", 
	 "ORDER_NUMBER");

ALTER TABLE "Schema"."PARTNER_ACTIVITY" ADD CONSTRAINT "PARTNER_ACTIVITY_PK" PRIMARY KEY
	("ORDER_NUMBER", 
	 "PARTNER_CODE", 
	 "CUSTOMER_CODE");

ALTER TABLE "Schema"."PARTNER_CONTACT" ADD CONSTRAINT "PARTNER_CONTACT_PK" PRIMARY KEY
	("ORDER_NUMBER", 
	 "PARTNER_CODE");

ALTER TABLE "Schema"."CUSTOMER_CREDITCARD" ADD CONSTRAINT "CUSTOMER_CREDITCARD_CUSTOMER_FK" FOREIGN KEY
	("CUSTOMER_CODE")
	REFERENCES "Schema"."CUSTOMER"
	("CUSTOMER_CODE")
	ON DELETE RESTRICT;

ALTER TABLE "Schema"."CUSTOMER_INVOICE" ADD CONSTRAINT "CUSTOMER_INVOICE_CUSTOMER_ORDER_FK" FOREIGN KEY
	("CUSTOMER_CODE", 
	 "ORDER_NUMBER")
	REFERENCES "Schema"."CUSTOMER_ORDER"
	("CUSTOMER_CODE", 
	 "ORDER_NUMBER");

ALTER TABLE "Schema"."CUSTOMER_ORDER" ADD CONSTRAINT "CUSTOMER_ORDER_CUSTOMER_CREDITCARD_FK" FOREIGN KEY
	("CUSTOMER_CREDITCARD_ID", 
	 "CUSTOMER_CODE")
	REFERENCES "Schema"."CUSTOMER_CREDITCARD"
	("CREDITCARD_ID", 
	 "CUSTOMER_CODE");

ALTER TABLE "Schema"."CUSTOMER_ORDER" ADD CONSTRAINT "CUSTOMER_ORDER_CUSTOMER_FK" FOREIGN KEY
	("CUSTOMER_CODE")
	REFERENCES "Schema"."CUSTOMER"
	("CUSTOMER_CODE");

ALTER TABLE "Schema"."PARTNER_ACTIVITY" ADD CONSTRAINT "PARTNER_ACTIVITY_CUSTOMER_FK" FOREIGN KEY
	("CUSTOMER_CODE")
	REFERENCES "Schema"."CUSTOMER"
	("CUSTOMER_CODE");

ALTER TABLE "Schema"."PARTNER_ACTIVITY" ADD CONSTRAINT "PARTNER_ACTIVITY_CUSTOMER_ORDER_FK" FOREIGN KEY
	("CUSTOMER_CODE", 
	 "ORDER_NUMBER")
	REFERENCES "Schema"."CUSTOMER_ORDER"
	("CUSTOMER_CODE", 
	 "ORDER_NUMBER");

ALTER TABLE "Schema"."PARTNER_ACTIVITY" ADD CONSTRAINT "PARTNER_ACTIVITY_PARTNER_CONTACT_FK" FOREIGN KEY
	("ORDER_NUMBER", 
	 "PARTNER_CODE")
	REFERENCES "Schema"."PARTNER_CONTACT"
	("ORDER_NUMBER", 
	 "PARTNER_CODE")
	ON DELETE RESTRICT;

