CREATE DATABASE basedatos_proyectofinal_prueba;

USE basedatos_proyectofinal_prueba;

--tabla precios de compra

CREATE TABLE Purchase_Prices(
Brand INT IDENTITY PRIMARY KEY,
Description VARCHAR(255),
Price FLOAT,
Size VARCHAR(255),
Volume INT, 
Classification INT, 
PurchasePrice FLOAT,
VendorNumber INT,
VendorName VARCHAR(255)
);

--Tabla precio de compra sin modificar datos sucios del dataset. Volume esta en string

/*
CREATE TABLE Purchase_Prices(
Brand INT IDENTITY PRIMARY KEY,
Description VARCHAR(255),
Price FLOAT,
Size VARCHAR(255),
Volume VARCHAR(255), 
Classification INT, 
PurchasePrice FLOAT,
VendorNumber INT,
VendorName VARCHAR(255)
);
*/

-- Tabla de ventas final

CREATE TABLE Sales_Final(
InventoryId VARCHAR(255),
Store INT,
Brand INT IDENTITY PRIMARY KEY, 
Description VARCHAR(255),
Size VARCHAR(255),
SalesQuantity INT,
SalesDollars FLOAT,
SalesPrice FLOAT,
SalesDate DATE,
Volume INT,
Classification INT, 
ExciseTax FLOAT,
VendorNo INT,
VendorName VARCHAR(255),
);

--Se hace la conexion entre precios de compra y ventas final

ALTER TABLE Sales_Final
ADD CONSTRAINT FK_purchase_sales
FOREIGN KEY(Brand) REFERENCES Purchase_Prices(Brand)

--Tabla de entregas final

CREATE TABLE End_Inv(
InventoryId VARCHAR(255),
Store INT,
City VARCHAR(255),
Brand INT IDENTITY PRIMARY KEY, 
Description VARCHAR(255),
Size VARCHAR(255),
OnHand INT,
Price FLOAT,
endDate DATE,
);

--Se hace la conexion entre entregas final y ventas final

ALTER TABLE End_Inv
ADD CONSTRAINT FK_sales_endinv
FOREIGN KEY(Brand ) REFERENCES Sales_Final(Brand);

--Tabla de envios final

CREATE TABLE Begin_Final(
InventoryId VARCHAR(255),
Store INT,
City VARCHAR(255) NULL,
Brand INT IDENTITY PRIMARY KEY, 
Description VARCHAR(255),
Size VARCHAR(255),
OnHand INT,
Price FLOAT,
startDate DATE,
);

--Conexion entre envios final y entregas final

ALTER TABLE Begin_Final
ADD CONSTRAINT FK_endinv_beginv
FOREIGN KEY(brand) REFERENCES End_Inv(brand);

--Tabla de compras final

CREATE TABLE Purchases_Final(
InventoryId VARCHAR(255),
Store INT,
Brand INT IDENTITY PRIMARY KEY, 
Description VARCHAR(255),
Size VARCHAR(255),
VendorNumber INT,
VendorName VARCHAR(255),
PONumber INT,
PODate DATE,
ReceivingDate DATE,
InvoiceDate DATE,
PayDate DATE,
PurchasePrice FLOAT,
Quantity INT,
Dollars FLOAT, 
Classification INT, 
);

);
/*
--Tabla de compras final sin modificar datos sucios de dataset. Las 4 columnas de fechas son strings y PONumber es string
--al datset le pasa algo porque no carga los datos numericos de la columna PurchasePrice. Ya probe con float, int, numeric, decimal
-- y nada funciona. Visual dice que es float 

CREATE TABLE Purchases_Final(
InventoryId VARCHAR(255),
Store INT,
Brand INT IDENTITY PRIMARY KEY, 
Description VARCHAR(255),
Size VARCHAR(255),
VendorNumber INT,
VendorName VARCHAR(255),
PONumber INT,
PODate VARCHAR(255),
ReceivingDate VARCHAR(255),
InvoiceDate VARCHAR(255),
PayDate VARCHAR(255),
PurchasePrice FLOAT,   -- esta columna es el problema
Quantity INT,
Dollars INT, 
Classification INT, 
);

*/

--Conexion entre compras final y envios final

ALTER TABLE Purchases_Final
ADD CONSTRAINT FK_beginv_purchase
FOREIGN KEY(brand) REFERENCES Begin_Final(brand);

--Tabla de facturas de compras

CREATE TABLE Invoice_Purchases(
VendorNumber INT,
VendorName VARCHAR(255),
InvoiceDate VARCHAR(255),
PONumber INT IDENTITY PRIMARY KEY,
PODate DATE, 
PayDate DATE, 
Quantity INT,
Dollars FLOAT,
Freight FLOAT,
Approval VARCHAR(255) NULL
);


/*

--Tabla de facturas de compras sin modificar el datsset sucios Las fechas permiten strings

CREATE TABLE Invoice_Purchases(
VendorNumber INT,
VendorName VARCHAR(255),
InvoiceDate VARCHAR(255),
PONumber INT IDENTITY PRIMARY KEY,
PODate VARCHAR(255), 
PayDate VARCHAR(255), 
Quantity INT,
Dollars FLOAT,
Freight FLOAT,
Approval VARCHAR(255) NULL
);

*/


--Conexion entre compras final y facturas de compras


ALTER TABLE Purchases_Final
ADD CONSTRAINT FK_invoice_purchasesfinal
FOREIGN KEY(PONumber) REFERENCES Invoice_Purchases(PONumber);

--Se cargan los datos del archivo Purchase_Prices a la tabla 2017PurchasePricesDec

BULK INSERT 

	Purchase_Prices --destino

FROM 

	'\2017PurchasePricesDec.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);

SELECT *
FROM Purchase_Prices


--Se cargan los datos del archivo SalesFINAL12312016 a la tabla Sales_Final

BULK INSERT 

	Sales_Final --destino

FROM 

	'\SalesFINAL12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);



--Se cargan los datos del archivo EndInvFINAL12312016 a la tabla End_Inv

BULK INSERT 

	End_Inv --destino

FROM 

	'\EndInvFINAL12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);



--Se cargan los datos del archivo BegInvFINAL12312016 a la tabla Begin_Final

BULK INSERT 

	 Begin_Final --destino

FROM 

	'\BegInvFINAL12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);




--Se cargan los datos del archivo PurchasesFINAL12312016 a la tabla Purchases_Final

BULK INSERT 

	 Purchases_Final --destino

FROM 

	'\PurchasesFINAL12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);

SELECT *
FROM Purchases_Final;


--Se cargan los datos del archivo InvoicePurchases12312016 a la tabla Invoice_Purchases
-- Tiene error porque PONumber no es una clave unica. Ya hago los cambios para traer una columna con claves a esta tabla
BULK INSERT 

	 Invoice_Purchases --destino

FROM 

	'\InvoicePurchases12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);
