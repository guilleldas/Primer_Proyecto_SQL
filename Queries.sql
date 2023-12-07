# Las siguientes queries fueron pensadas para extraer información valiosa e interesante del dataset.

TABLA: PRODUCTLINES

Comenzando por la tabla Productlines y creo que es bueno saber cuales son las lineas de productos y que cantidad de modelos existen dentro de cada una de ellas. 
Con la siguiente query podemos ver que las lineas son Classic Cars, Vintage Cars, Motorcycles, Planes, Trucks and Buses, Ships y Trains. 
Siendo Classic Cars la línea con más modelos y Trains la línea con menos modelos. Esto no significa que Classic Cars sea la más vendida sino que simplemente tiene más modelos. 

SELECT productline AS ProductLine, COUNT(productCode) AS Model_Qtty
FROM products
GROUP BY productline
ORDER BY COUNT(productCode) DESC

En cuanto al stock, podemos obtener el stock existente por linea de productos y cual es su porcentaje sobre el stock total. En este caso Classic cars tiene un stock considerablemente mayor
al de las demás líneas, por otro lado Trains es el que menor stock maneja. 
  
SELECT productline AS ProductLine, SUM(quantityinstock) AS Stock, 
ROUND((SUM(quantityinstock) / (SELECT SUM(quantityinstock) FROM products)) * 100,1) AS StockPercentage
FROM products
GROUP BY productline
ORDER BY SUM(quantityinstock) DESC

#(Haciendo un paréntesis y para demostrar el uso de JOIN, en caso de que Productline no fuere clave foránea en products, deberíamos haber hecho las siguientes consultas para obtener el mismo resultado
#que en las queries de arriba.
  
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
