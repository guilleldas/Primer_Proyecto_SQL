# TABLA: PRODUCTLINES + PRODUCTS

#Para seguir entendiendo la BBDD creo que es bueno saber cuales son las lineas de productos
# y que cantidad de modelos existen dentro de cada una de ellas. Con la siguiente query podemos ver que 
# las lineas son Classic Cars, Vintage Cars, Motorcycles, Planes, Trucks and Buses, Ships y Trains.
# Siendo Classic Cars la línea con más modelos y Trains la línea con menos modelos. Esto no significa que
# Classic Cars sea la más vendida sino que simplemente tiene más modelos. 

# MÁS ADELANTE SE PUDE ANALIZAR SI EXISTE UNA RELACION ENTRE LA CANTIDAD DE MODELOS DE CADA LINEA 
# Y LAS VENTAS.

/*SELECT pl.productline AS ProductLine, COUNT(pr.productCode) AS Model_Qtty
FROM productlines as pl
JOIN products as pr ON pr.productline = pl.productline
GROUP BY productline
ORDER BY COUNT(pr.productCode) DESC*/

## SIN NECESIDAD DE JOIN!!!! OJOOOO

/*SELECT productline AS ProductLine, COUNT(productCode) AS Model_Qtty
FROM products
GROUP BY productline
ORDER BY COUNT(productCode) DESC*/

#Nuevamente observando las tablas Productlines y Product podemos obtener el stock que existe por
#linea de productos y cual es su porcentaje sobre el total del stock. 
#En este caso Classic cars tiene un stock considerablemente más grande al de 
#las demás líneas, por otro lado Trains es el que menor stock maneja. 

/*SELECT pl.productline AS ProductLine, SUM(pr.quantityinstock) AS Stock, 
ROUND((SUM(pr.quantityinstock) / (SELECT SUM(quantityinstock) FROM products)) * 100,1) AS StockPercentage
FROM productlines as pl
JOIN products as pr ON pr.productline = pl.productline
GROUP BY pl.productline
ORDER BY SUM(pr.quantityinstock) DESC*/

# OJO SIN NECESIDAD DE JOIN!!!

/*SELECT productline AS ProductLine, SUM(quantityinstock) AS Stock, 
ROUND((SUM(quantityinstock) / (SELECT SUM(quantityinstock) FROM products)) * 100,1) AS StockPercentage
FROM products
GROUP BY productline
ORDER BY SUM(quantityinstock) DESC*/

#VER LA STOCK TOTAL PARA LUEGO SACAR CONCLUSIONES

/*SELECT SUM(quantityinstock)
FROM products*/

#TABLA PRODUCTS

# Similar a la query anterior, pero en este caso trabajando con la tabla Products, creo que es bueno
# saber la cantidad de productos que existen por escala. La escala 1:18 es la que más modelos tiene,
# mientras que las escalas 1:72 y 10:50 son las que menos.

# MÁS ADELANTE SE PUDE ANALIZAR SI EXISTE UNA RELACION ENTRE LA CANTIDAD DE MODELOS DE CADA ESCALA 
# Y LAS VENTAS.

/*SELECT productscale AS Scale, COUNT(productcode) AS Model_Qtty
FROM products
GROUP BY productscale
ORDER BY COUNT(productscale) DESC*/

# CON LA SIGUIENTE QUERY PODEMOS ANALIZAR, DE TODOS LOS PRODUCTOS, CUAL ES EL PROMEDIO, CUAL ES
# EL MAS CARO Y CUAL ES EL MAS BARATO.

/*SELECT ROUND(AVG(buyprice),2) AS Average_Price, MIN(buyprice) AS Min_Price, MAX(buyprice) AS Max_Price
FROM products*/

#BUSCANDO CUAL ES EL PRODUCTO MAS CARO

/*SELECT productname AS Producto, buyprice AS Precio
FROM products
ORDER BY buyprice DESC
LIMIT 1*/

#BUSCANDO CUAL ES EL PRODUCTO MAS BARATO

/*SELECT productname AS Producto, buyprice AS Precio
FROM products
ORDER BY buyprice ASC
LIMIT 1*/
