--Se crea la base de datos del proyecto y elaborada en SQLServer. Consiste en 6 tablas 
--Es un modelo del estrella con la tabla de hechos de Purchases_Final y las otras 5 tablas son sus dimensiones

CREATE DATABASE bebidas_alcohol;

USE bebidas_alcohol;

--Se crea la tabla Purchase_Prices
--El archivo "2017PurchasePricesDec.csv" tenia el tipo de dato de la columna Volume incorrecto ya que era un string (todos los valores de la columna iban entre comillas) 
--y aqui la columna solo acepta numeros enteros

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

--Tabla Sales_Final

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
FOREIGN KEY(Brand) REFERENCES Purchase_Prices(Brand);


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

--Tabla de facturas de compras
--Las columnas InvoiceDate, PODate, PayDate tienen strings como fechas y ya fueron cambiadas por tipo de dato DATE 

CREATE TABLE Invoice_Purchases(
VendorNumber INT,
VendorName VARCHAR(255),
InvoiceDate VARCHAR(255),
PONumber DECIMAL(10,2),
PODate DATE, 
PayDate DATE, 
Quantity INT,
Dollars FLOAT,
Freight FLOAT,
Approval VARCHAR(255) NULL
);

--Tabla de compras final

CREATE TABLE Purchases_Final(
InventoryId VARCHAR(255),
Store INT,
Brand INT IDENTITY PRIMARY KEY, 
Description VARCHAR(255),
Size VARCHAR(255),
VendorNumber INT,
VendorName VARCHAR(255),
PONumber DECIMAL(10,2),
PODate DATE,
ReceivingDate DATE,
InvoiceDate DATE,
PayDate DATE,
PurchasePrice DECIMAL(10,2),
Quantity INT,
Dollars FLOAT, 
Classification INT, 
);

--Conexion entre envios fin y compras final 

ALTER TABLE Purchases_Final
ADD CONSTRAINT FK_beginv_purchases
FOREIGN KEY(brand) REFERENCES Begin_Final(brand);

--Conexion entre envios final y compras final

ALTER TABLE Purchases_Final
ADD CONSTRAINT FK_endinv_purchases
FOREIGN KEY(brand) REFERENCES End_Inv(brand);

--Se hace la conexion entre entregas final y compras final

ALTER TABLE Purchases_Final
ADD CONSTRAINT FK_sales_purchases
FOREIGN KEY(Brand ) REFERENCES Sales_Final(Brand);


--Se hace la conexion entre precios final y ventas final

ALTER TABLE Purchases_Final
ADD CONSTRAINT FK_invoice_purchasesfinal
FOREIGN KEY(PONumber) REFERENCES Invoice_Purchases(PONumber);




--Se cargan los datos del archivo Purchase_Prices a la tabla 2017PurchasePricesDec

BULK INSERT 

	Purchase_Prices --destino

FROM 

	'2017PurchasePricesDec.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);




--Se cargan los datos del archivo SalesFINAL12312016 a la tabla Sales_Final

BULK INSERT 

	Sales_Final --destino

FROM 

	'SalesFINAL12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);




--Se cargan los datos del archivo EndInvFINAL12312016 a la tabla End_Inv

BULK INSERT 

	End_Inv --destino

FROM 

	'EndInvFINAL12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);




--Se cargan los datos del archivo BegInvFINAL12312016 a la tabla Begin_Final

BULK INSERT 

	 Begin_Final --destino

FROM 

	'BegInvFINAL12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);




--Se cargan los datos del archivo PurchasesFINAL12312016 a la tabla Purchases_Final

BULK INSERT 

	 Purchases_Final --destino

FROM 

	'PurchasesFINAL12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);




--Se cargan los datos del archivo InvoicePurchases12312016 a la tabla Invoice_Purchases

BULK INSERT 

	 Invoice_Purchases --destino

FROM 

	'InvoicePurchases12312016.csv'

WITH

	(FIRSTROW=2,
	FIELDTERMINATOR = ','
	);




