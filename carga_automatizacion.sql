#Esta base de datos con tiene tablas elboradas manualmente para MySQL y esta transformada de acuerdo a la normalizacion

#Se crea la base de datos

CREATE DATABASE carga_automatizacion;

#Se "usa" la base de datos

USE carga_automatizacion;

#Se crea la tabla Purchase_Prices
#El archivo "2017PurchasePricesDec.csv" tenia el tipo de dato de la columna Volume incorrecto ya que era un string (todos los valores de la columna iban entre comillas) y aqui la columna solo acepta numeros enteros

CREATE TABLE carga_automatizacion.Purchase_Prices(
Brand INT, 
Description VARCHAR(255),
Price DECIMAL(10,2),
Size VARCHAR(255),
Volume INT, 
Classification INT, 
PurchasePrice DECIMAL(10,2),
VendorNumber INT,
VendorName VARCHAR(255)
);

#Tabla Sales_Final

CREATE TABLE carga_automatizacion.Sales_Final(
InventoryId VARCHAR(255),
Store INT,
Brand INT, 
Description VARCHAR(255),
Size VARCHAR(255),
SalesQuantity INT,
SalesDollars DECIMAL(10,2),
SalesPrice DECIMAL(10,2),
SalesDate DATE,
Volume INT,
Classification INT, 
ExciseTax DECIMAL(10,2),
VendorNo INT,
VendorName VARCHAR(255)
);

#Tabla de entregas final

CREATE TABLE carga_automatizacion.End_Inv(
InventoryId VARCHAR(255),
Store INT,
City VARCHAR(255),
Brand INT, 
Description VARCHAR(255),
Size VARCHAR(255),
OnHand INT,
Price DECIMAL(10,2),
endDate DATE
);

#Tabla de envios final

CREATE TABLE carga_automatizacion.Begin_Final(
InventoryId VARCHAR(255),
Store INT,
City VARCHAR(255) NULL,
Brand INT, 
Description VARCHAR(255),
Size VARCHAR(255),
OnHand INT,
Price DECIMAL(10,2),
startDate DATE
);

#Tabla de facturas de compras
#Las columnas InvoiceDate, PODate, PayDate tienen strings como fechas y ya fueron cambiadas por tipo de dato DATE 

CREATE TABLE carga_automatizacion.Invoice_Purchases(
VendorNumber INT,
VendorName VARCHAR(255),
InvoiceDate DATE,
PONumber DECIMAL(10,2),
PODate DATE, 
PayDate DATE, 
Quantity INT,
Dollars DECIMAL(10,2),
Freight DECIMAL(10,2),
Approval VARCHAR(255) NULL
);

#Tabla de compras final

CREATE TABLE carga_automatizacion.Purchases_Final(
InventoryId VARCHAR(255),
Store INT,
Brand INT, 
Description VARCHAR(255),
Size VARCHAR(255),
VendorNumber INT,
VendorName VARCHAR(255),
PONumber DECIMAL(10,2),
PODate VARCHAR(255),
ReceivingDate VARCHAR(255),
InvoiceDate VARCHAR(255),
PayDate VARCHAR(255),
PurchasePrice DECIMAL(10,2),
Quantity INT,
Dollars FLOAT, 
Classification INT
);

#Tabla de compras final
#Las tablas PODate, ReceivingDate, InvoiceDate y PayDate en sus respectivas filas tenian datos de tipo string y ahora sus columnas fueron cambiadas por DATE

CREATE TABLE carga_automatizacion.Purchases_Final(
InventoryId VARCHAR(255),
Store INT,
Brand INT, 
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
Dollars DECIMAL(10,2), 
Classification INT
);