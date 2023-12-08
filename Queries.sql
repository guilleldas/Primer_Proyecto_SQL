# Las siguientes queries fueron pensadas para extraer información valiosa e interesante del dataset.

TABLA: PRODUCTLINES


#TABLA PRODUCTS

# LINEAS:
  
/*Comenzando por la tabla Product considero necesario analizar las lineas de productos y que cantidad de modelos existen dentro de cada una de ellas. 
Con la siguiente query podemos ver que las lineas son Classic Cars, Vintage Cars, Motorcycles, Planes, Trucks and Buses, Ships y Trains. 
Siendo Classic Cars la línea con más modelos y Trains la línea con menos modelos.*/ 

#SERA LA LÍNEA CON MAS PRODUCTOS LA MAS VENDIDA?

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

(
/*Haciendo un paréntesis y para demostrar el uso de JOIN, en caso de que Productline no fuere clave foránea en la tabla Products, podríamos haber utilizado 
las siguientes consultas para obtener el mismo resultado que en las queries de arriba.
  
SELECT pl.productline AS ProductLine, COUNT(pr.productCode) AS Model_Qtty
FROM productlines as pl
JOIN products as pr ON pr.productline = pl.productline
GROUP BY productline
ORDER BY COUNT(pr.productCode) DESC

SELECT pl.productline AS ProductLine, SUM(pr.quantityinstock) AS Stock, 
ROUND((SUM(pr.quantityinstock) / (SELECT SUM(quantityinstock) FROM products)) * 100,1) AS StockPercentage
FROM productlines as pl
JOIN products as pr ON pr.productline = pl.productline
GROUP BY pl.productline
ORDER BY SUM(pr.quantityinstock) DESC*/
)


/*Otro punto a analizar en la tabla Products es la cantidad de productos/modelos que existen por escala. 
La escala 1:18 es la que más modelos tiene, mientras que las escalas 1:72 y 10:50 son las que menos.*/

# SERA LA ESCALA CON MAS PRODUCTOS LA MAS VENDIDA?

SELECT productscale AS Scale, COUNT(productcode) AS Model_Qtty
FROM products
GROUP BY productscale
ORDER BY COUNT(productscale) DESC;

# PRECIO DE COMPRA:
  
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

#TABLA ORDERDETAILS:

#PRECIO DE VENTA:

/*Precio de venta más caro y el más barato.*/

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

#TABLA ORDERDETAILS Y PRODUCTS:

/* Utilizando pricEach de la tabla Orderdetails y buyPrice de Products, podemos analizar los 10 productos con menos/más margen
de ganancia.*/  

SELECT p.productcode AS Code, p.productline as Line, p.productname AS Product, p.buyprice AS Buy_Price, od.priceeach AS Sale_Price, (od.priceeach - p.buyprice) AS Margin, ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2) AS '%'
FROM products AS p
JOIN orderdetails as od ON p.productcode = od.productcode
GROUP BY p.productcode, od.priceeach
ORDER BY Margin DESC
LIMIT 10

SELECT p.productcode AS Code, p.productline as Line, p.productname AS Product, p.buyprice AS Buy_Price, od.priceeach AS Sale_Price, (od.priceeach - p.buyprice) AS Margin, ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2) AS '%'
FROM products AS p
JOIN orderdetails as od ON p.productcode = od.productcode
GROUP BY p.productcode, od.priceeach
ORDER BY Margin ASC
LIMIT 10


/*SELECT p.productline AS Line, AVG(ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2)) AS '%'
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
GROUP BY p.productline
ORDER BY AVG(ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2)) DESC*/




