Creo este archivo para mostrar tanto las consultas utilizadas, como los resultados devueltos por MySQL. Se utiliza DBeaver para obtener los resultados de las 
consultas en forma de texto y poder implementarlos en el Markdown.

### Líneas de producto y cantidad de productos en cada una de ellas

<details>
<summary>Ver consulta</summary>

```sql
SELECT productline AS ProductLine, COUNT(productCode) AS Model_Qtty
FROM products
GROUP BY productline
ORDER BY COUNT(productCode) DESC;
```
</details>

Resultado:

| ProductLine      | Model_Qtty |
|-------------------|------------|
| Classic Cars      | 38         |
| Vintage Cars      | 24         |
| Motorcycles       | 13         |
| Planes            | 12         |
| Trucks and Buses  | 11         |
| Ships             | 9          |
| Trains            | 3          |


### Stock total

<details>
<summary>Ver consulta</summary>

```sql
SELECT SUM(quantityinstock) as Total_Stock
FROM products
```
</details>

Resultado:

| Total_Stock |
| -------------------- |
| 555131               |


### Stock por línea de producto y porcentaje sobre stock total

<details>
<summary>Ver consulta</summary>

```sql
SELECT productline AS ProductLine, SUM(quantityinstock) AS Stock, 
ROUND((SUM(quantityinstock) / (SELECT SUM(quantityinstock) FROM products)) * 100,1) AS StockPercentage
FROM products
GROUP BY productline
ORDER BY SUM(quantityinstock) DESC;
```
</details>

Resultado:

### Dentro de la línea 'Classic Cars', determino cual es el stock de vehículos de marca Ferrari o Renault

<details>
<summary>Ver consulta</summary>

```sql
SELECT 
(SELECT SUM(quantityinstock) FROM products WHERE productname LIKE '%Ferrari%') AS Ferrari_Stock, 
(SELECT SUM(quantityinstock) FROM products WHERE productname LIKE '%Renault%') AS Renault_Stock,
SUM(quantityinstock) AS Total_Stock
FROM products
WHERE productline = 'classic cars';
```
</details>

Resultado:

### Cantidad de modelos por tamaño

<details>
<summary>Ver consulta</summary>

```sql

SELECT productscale AS Scale, COUNT(productcode) AS Model_Qtty
FROM products
GROUP BY productscale
ORDER BY COUNT(productscale) DESC;
```
</details>

Resultado:
  
### Mínimo, máximo y promedio del precio de compra

<details>
<summary>Ver consulta</summary>

```sql
SELECT ROUND(AVG(buyprice),2) AS Average_Price, MIN(buyprice) AS Min_Price, MAX(buyprice) AS Max_Price
FROM products;
```
</details>

Resultado:

### Precio de compra más caro y más barato

<details>
<summary>Ver consulta</summary>

```sql
SELECT productname AS Producto, buyprice AS Precio
FROM products
ORDER BY buyprice DESC
LIMIT 1;
```
</details>

Resultado:

<details>
<summary>Ver consulta</summary>

```sql

SELECT productname AS Producto, buyprice AS Precio
FROM products
ORDER BY buyprice ASC
LIMIT 1;
```
</details>

Resultado:

### Precio de venta más caro y más barato

<details>
<summary>Ver consulta</summary>

```sql
SELECT p.productname AS Producto, od.priceeach AS Precio
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
ORDER BY buyprice DESC
LIMIT 1;
```
</details>

Resultado:

<details>
<summary>Ver consulta</summary>

```sql
SELECT p.productname AS Producto, od.priceeach AS Precio
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
ORDER BY buyprice ASC
LIMIT 1;
```
</details>

Resultado:

### Productos con más y menos margen de ganancia 

<details>
<summary>Ver consulta</summary>

```sql
SELECT p.productcode AS Code, p.productline as Line, p.productname AS Product, p.buyprice AS Buy_Price, od.priceeach AS Sale_Price, (od.priceeach - p.buyprice) AS Margin, ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2) AS '%'
FROM products AS p
JOIN orderdetails as od ON p.productcode = od.productcode
GROUP BY p.productcode, od.priceeach
ORDER BY Margin DESC
LIMIT 10;
```
</details>

Resultado:

<details>
<summary>Ver consulta</summary>

```sql
SELECT p.productcode AS Code, p.productline as Line, p.productname AS Product, p.buyprice AS Buy_Price, od.priceeach AS Sale_Price, (od.priceeach - p.buyprice) AS Margin, ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2) AS '%'
FROM products AS p
JOIN orderdetails as od ON p.productcode = od.productcode
GROUP BY p.productcode, od.priceeach
ORDER BY Margin ASC
LIMIT 10;
```
</details>

Resultado:

### Margen de ganancia promedio por línea de producto

<details>
<summary>Ver consulta</summary>

```sql
SELECT p.productline AS Line, AVG(ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2)) AS '%'
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
GROUP BY p.productline
ORDER BY AVG(ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2)) DESC;
```
</details>

Resultado:

### Productos más vendidos en 2003, 2004, 2005 y período 2003-2005

<details>
<summary>Ver consulta</summary>

```sql  
SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) DESC
LIMIT 10;
```
</details>

Resultado:

<details>
<summary>Ver consulta</summary>

```sql
SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2004-01-01' AND '2004-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) DESC
LIMIT 10;
```
</details>

Resultado:

<details>
<summary>Ver consulta</summary>

```sql
SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2005-01-01' AND '2005-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) DESC
LIMIT 10;

```
</details>

Resultado:

<details>
<summary>Ver consulta</summary>

```sql  
SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2003-01-01' AND '2005-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) DESC
LIMIT 10;
```
</details>

Resultado:

### Productos menos vendidos período 2003-2005

<details>
<summary>Ver consulta</summary>

```sql  
SELECT p.productname AS Product, p.productline AS Line, od.productcode AS Product_Code, SUM(od.quantityordered) AS Quantity_Ordered
FROM orderdetails AS od
JOIN orders AS o ON o.ordernumber = od.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE o.orderdate BETWEEN '2003-01-01' AND '2005-12-31'
GROUP BY od.productcode
ORDER BY SUM(od.quantityordered) ASC
LIMIT 10;
```
</details>

Resultado:

### 3 ordenes de mayor monto

<details>
<summary>Ver consulta</summary>

```sql  
SELECT ordernumber AS Order_Number, SUM((priceeach * quantityordered)) AS Total
FROM orderdetails
GROUP BY ordernumber
ORDER BY Total DESC
LIMIT 3;
```
</details>

Resultado:

### Busco cliente de las 3 facturas de mayor monto
<details>
<summary>Ver consulta</summary>

```sql  
SELECT od.ordernumber AS Order_Number, SUM((od.priceeach * od.quantityordered)) AS Total, c.customername as Customer_Name
FROM orderdetails AS od
JOIN orders AS o ON od.ordernumber = o.ordernumber
JOIN customers AS c ON c.customernumber = o.customernumber 
GROUP BY od.ordernumber
ORDER BY Total DESC
LIMIT 3;
```
</details>

Resultado:

### Busco detalles e información de cada una de las facturas de mayor monto

<details>
<summary>Ver consulta</summary>

```sql  
SELECT od.ordernumber AS Order_Number, od.productcode AS Product_Code, p.productname AS Product, od.priceeach AS Price, od.quantityordered AS Quantity, SUM((od.priceeach * od.quantityordered)) AS Total
FROM orders AS o
JOIN orderdetails AS od ON od.ordernumber = o.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE od.ordernumber = '10165' OR od.ordernumber = '10287' OR od.ordernumber = '10310'
GROUP BY od.ordernumber, od.productcode, p.productname, od.priceeach, od.quantityordered
ORDER BY od.ordernumber, Total DESC;
```
</details>

Resultado:

### Clientes deudores o pagos no registrados

<details>
<summary>Ver consulta</summary>

```sql  
SELECT c.customerNumber AS Customer_Number, c.customerName AS Company,
c.contactLastName AS Contact_Name, c.contactFirstName AS Contact_Surname
FROM customers AS c
LEFT JOIN payments AS p ON c.customerNumber = p.customerNumber
WHERE p.checkNumber IS NULL;
```
</details>

Resultado:

### Análisis y categorización de créditos

<details>
<summary>Ver consulta</summary>

```sql  
SELECT customername AS Customer_Name, creditlimit AS Credit_Limit,
CASE
WHEN creditLimit > 50000 THEN 'Alto'
WHEN creditLimit >= 10000 AND creditLimit <= 50000 THEN 'Medio'
ELSE 'Bajo'
END AS Categoria_Credito
FROM customers
WHERE creditlimit <> 0.00
ORDER BY customername;
```
</details>

Resultado:
