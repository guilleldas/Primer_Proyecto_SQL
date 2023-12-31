#Las siguientes queries fueron pensadas para extraer información valiosa e interesante del dataset.

#LINEAS:
  
/*Comenzando por la tabla Product considero necesario analizar las lineas de productos y que cantidad de modelos existen dentro de cada una de ellas. 
Con la siguiente query podemos ver que las lineas son Classic Cars, Vintage Cars, Motorcycles, Planes, Trucks and Buses, Ships y Trains. 
Siendo Classic Cars la línea con más modelos y Trains la línea con menos modelos.*/ 

SELECT productline AS ProductLine, COUNT(productCode) AS Model_Qtty
FROM products
GROUP BY productline
ORDER BY COUNT(productCode) DESC;

#STOCK:

/*En esta tabla, podemos ver el stock tal de modelos a escala mediante la siguiente query.*/

SELECT SUM(quantityinstock)
FROM products

/*Siguiendo con el stock, podemos obtener el stock existente por línea de productos y cual es su porcentaje sobre el stock total. En este caso Classic cars tiene un 
stock considerablemente superior al de las demás líneas, por otro lado Trains es el que menor stock maneja.*/
  
SELECT productline AS ProductLine, SUM(quantityinstock) AS Stock, 
ROUND((SUM(quantityinstock) / (SELECT SUM(quantityinstock) FROM products)) * 100,1) AS StockPercentage
FROM products
GROUP BY productline
ORDER BY SUM(quantityinstock) DESC;

/*La siguiente query la planteo para analizar, dentro de la linea 'Classic Cars', cual es la cantidad en stock de coches marca Ferrari y que cantidad es marca Renault.*/
SELECT 
(SELECT SUM(quantityinstock) FROM products WHERE productname LIKE '%Ferrari%') AS Ferrari_Stock, 
(SELECT SUM(quantityinstock) FROM products WHERE productname LIKE '%Renault%') AS Renault_Stock,
SUM(quantityinstock) AS Total_Stock
FROM products
WHERE productline = 'classic cars';

/*Otro punto a analizar en la tabla Products es la cantidad de productos/modelos que existen por escala. 
La escala 1:18 es la que más modelos tiene, mientras que las escalas 1:72 y 10:50 son las que menos.*/

SELECT productscale AS Scale, COUNT(productcode) AS Model_Qtty
FROM products
GROUP BY productscale
ORDER BY COUNT(productscale) DESC;

#PRECIO DE COMPRA:
  
/* Aprovechando que la tabla contiene información sobre el precio de compra de los productos, podemos analizar con funciones de
agregación, cual es el  Mínimo, Máximo y Promedio.*/

SELECT ROUND(AVG(buyprice),2) AS Average_Price, MIN(buyprice) AS Min_Price, MAX(buyprice) AS Max_Price
FROM products;

/*Tambien el precio de compra más caro y el más barato.*/

SELECT productname AS Producto, buyprice AS Precio
FROM products
ORDER BY buyprice DESC
LIMIT 1;

SELECT productname AS Producto, buyprice AS Precio
FROM products
ORDER BY buyprice ASC
LIMIT 1;

#PRECIO DE VENTA:

/*Precio de venta más caro y más barato.*/

SELECT p.productname AS Producto, od.priceeach AS Precio
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
ORDER BY buyprice DESC
LIMIT 1;

SELECT p.productname AS Producto, od.priceeach AS Precio
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
ORDER BY buyprice ASC
LIMIT 1;

#MARGEN DE GANANCIA:

/* Utilizando priceEach de la tabla Orderdetails y buyPrice de Products, podemos analizar los 10 productos con menos/más margen
de ganancia.*/  

SELECT p.productcode AS Code, p.productline as Line, p.productname AS Product, p.buyprice AS Buy_Price, od.priceeach AS Sale_Price, (od.priceeach - p.buyprice) AS Margin, ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2) AS '%'
FROM products AS p
JOIN orderdetails as od ON p.productcode = od.productcode
GROUP BY p.productcode, od.priceeach
ORDER BY Margin DESC
LIMIT 10;

SELECT p.productcode AS Code, p.productline as Line, p.productname AS Product, p.buyprice AS Buy_Price, od.priceeach AS Sale_Price, (od.priceeach - p.buyprice) AS Margin, ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2) AS '%'
FROM products AS p
JOIN orderdetails as od ON p.productcode = od.productcode
GROUP BY p.productcode, od.priceeach
ORDER BY Margin ASC
LIMIT 10;

/*Siguiendo con las mismas dos tablas, podemos ver el margen de ganancia promedio, por linea de producto.*/

SELECT p.productline AS Line, AVG(ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2)) AS '%'
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
GROUP BY p.productline
ORDER BY AVG(ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2)) DESC;

#VENTAS:

/* Con el uso de las tablas Orderdetails, Orders y Products, pude analizar cuales fueron los productos más vendidos en distintos períodos de tiempo.
En 2003, 2004, 2005 y en el período 2003-2005. Tambien se listan las columnas productline y product code para darle contexto al nombre del producto.*/
  
SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) DESC
LIMIT 10;

SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2004-01-01' AND '2004-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) DESC
LIMIT 10;

SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2005-01-01' AND '2005-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) DESC
LIMIT 10;

SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2003-01-01' AND '2005-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) DESC
LIMIT 10;

/*La siguiente query es realizada para, al contrario de la anterior, devuelve cuales son los productos menos vendidos en el período 2003-2005*/

SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2003-01-01' AND '2005-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) ASC
LIMIT 10;

ORDENES:

/* Dentro de la tabla Orderdetails, podemos analizar cuales fueron las ordenes de mayor monto.*/

SELECT ordernumber AS Order_Number, SUM((priceeach * quantityordered)) AS Total
FROM orderdetails
GROUP BY ordernumber
ORDER BY Total DESC
LIMIT 3;

/* Realizando dos JOINs con las tablas orders y customers, podemos ver quien es el cliente en cada una de las facturas filtradas anteriormente*/

SELECT od.ordernumber AS Order_Number, SUM((od.priceeach * od.quantityordered)) AS Total, c.customername as Customer_Name
FROM orderdetails AS od
JOIN orders AS o ON od.ordernumber = o.ordernumber
JOIN customers AS c ON c.customernumber = o.customernumber 
GROUP BY od.ordernumber
ORDER BY Total DESC
LIMIT 3;

/* Sabiendo cual fueron las facturas mas caras, realizo la siguiente query para saber en detalle como estan compuestas las mismas. Es decir, su order number, junto con
cada uno de los productos incluidos en esa orden, su precio, cantidad y total.*/

SELECT od.ordernumber AS Order_Number, od.productcode AS Product_Code, p.productname AS Product, od.priceeach AS Price, od.quantityordered AS Quantity, SUM((od.priceeach * od.quantityordered)) AS Total
FROM orders AS o
JOIN orderdetails AS od ON od.ordernumber = o.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE od.ordernumber = '10165' OR od.ordernumber = '10287' OR od.ordernumber = '10310'
GROUP BY od.ordernumber, od.productcode, p.productname, od.priceeach, od.quantityordered
ORDER BY od.ordernumber, Total DESC;

#PAGOS:

/* En cualquier empresa es importante saber quienes son los clientes pendiente de pago, es por eso que realizo la siguiente query para saber que cliente no pago, 
o bien, si el pago no fue registrado en el sistema.*/

SELECT c.customerNumber AS Customer_Number, c.customerName AS Company,
c.contactLastName AS Contact_Name, c.contactFirstName AS Contact_Surname
FROM customers AS c
LEFT JOIN payments AS p ON c.customerNumber = p.customerNumber
WHERE p.checkNumber IS NULL;

#CREDITO:

/*Dentro de la tabla customers, se puede analizar el limite de credito de cada uno. Para esto utilizo CASE WHEN, donde creo una columna para saber si su limite
de credito es Alto, Medio o Bajo. Excluyo aquellos clientes que su limite de crédito sea = 0.*/

SELECT customername AS Customer_Name, creditlimit AS Credit_Limit,
CASE
WHEN creditLimit > 50000 THEN 'Alto'
WHEN creditLimit >= 10000 AND creditLimit <= 50000 THEN 'Medio'
ELSE 'Bajo'
END AS Categoria_Credito
FROM customers
WHERE creditlimit <> 0.00
ORDER BY customername;





