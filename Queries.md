# Queries y resultados

##### Creo este archivo para mostrar los resultados obtenidos en cada consulta. Se utiliza DBeaver para obtener los resultados de las consultas en forma de texto y poder implementarlos en el Markdown.



### Líneas de producto y cantidad de productos en cada una de ellas


```sql
SELECT productline AS ProductLine, COUNT(productCode) AS Model_Qtty
FROM products
GROUP BY productline
ORDER BY COUNT(productCode) DESC;
```

<details>
<summary>Ver resultado</summary>


| ProductLine      | Model_Qtty |
|-------------------|------------|
| Classic Cars      | 38         |
| Vintage Cars      | 24         |
| Motorcycles       | 13         |
| Planes            | 12         |
| Trucks and Buses  | 11         |
| Ships             | 9          |
| Trains            | 3          |

</details>

### Stock total


```sql
SELECT SUM(quantityinstock) as Total_Stock
FROM products
```

<details>
<summary>Ver resultado</summary>

| Total_Stock |
| -------------------- |
| 555131               |

</details>

### Stock por línea de producto y porcentaje sobre stock total

```sql
SELECT productline AS ProductLine, SUM(quantityinstock) AS Stock, 
ROUND((SUM(quantityinstock) / (SELECT SUM(quantityinstock) FROM products)) * 100,1) AS StockPercentage
FROM products
GROUP BY productline
ORDER BY SUM(quantityinstock) DESC;
```

<details>
<summary>Ver resultado</summary>

| ProductLine      | Stock  | StockPercentage |
| ----------------- | ------ | --------------- |
| Classic Cars      | 219183 | 39.5            |
| Vintage Cars      | 124880 | 22.5            |
| Motorcycles       | 69401  | 12.5            |
| Planes            | 62287  | 11.2            |
| Trucks and Buses  | 35851  | 6.5             |
| Ships             | 26833  | 4.8             |
| Trains            | 16696  | 3.0             |

</details>

### Dentro de la línea 'Classic Cars', determino cual es el stock de vehículos de marca Ferrari o Renault

```sql
SELECT 
(SELECT SUM(quantityinstock) FROM products WHERE productname LIKE '%Ferrari%') AS Ferrari_Stock, 
(SELECT SUM(quantityinstock) FROM products WHERE productname LIKE '%Renault%') AS Renault_Stock,
SUM(quantityinstock) AS Total_Stock
FROM products
WHERE productline = 'classic cars';
```

<details>
<summary>Ver resultado</summary>

| Ferrari_Stock | Renault_Stock | Total_Stock |
| -------------- | -------------- | ----------- |
|          11966 |         15300 |      219183 |

</details>

### Cantidad de modelos por tamaño

```sql

SELECT productscale AS Scale, COUNT(productcode) AS Model_Qtty
FROM products
GROUP BY productscale
ORDER BY COUNT(productscale) DESC;
```

<details>
<summary>Ver resultado</summary>

|Scale|Model_Qtty|
|-----|----------|
|1:18|42|
|1:24|27|
|1:700|10|
|1:12|9|
|1:32|8|
|1:10|6|
|1:72|4|
|1:50|4|

</details>

### Mínimo, máximo y promedio del precio de compra

```sql
SELECT ROUND(AVG(buyprice),2) AS Average_Price, MIN(buyprice) AS Min_Price, MAX(buyprice) AS Max_Price
FROM products;
```


<details>
<summary>Ver resultado</summary>

| Average_Price | Min_Price | Max_Price |
|---------------|-----------|-----------|
|         54.40 |     15.91 |    103.42 |

### Precio de compra más caro y más barato
</details>

```sql
SELECT productname AS Producto, buyprice AS Precio
FROM products
ORDER BY buyprice DESC
LIMIT 1;
```

<details>
<summary>Ver resultado</summary>

| Producto                  | Precio |
|---------------------------|--------|
| 1962 LanciaA Delta 16V    | 103.42 |

</details>

```sql

SELECT productname AS Producto, buyprice AS Precio
FROM products
ORDER BY buyprice ASC
LIMIT 1;
```

<details>
<summary>Ver resultado</summary>

| Producto                                 | Precio |
|------------------------------------------|--------|
| 1958 Chevy Corvette Limited Edition      | 15.91  |

</details>

### Precio de venta más caro y más barato

```sql
SELECT p.productname AS Producto, od.priceeach AS Precio
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
ORDER BY buyprice DESC
LIMIT 1;
```

<details>
<summary>Ver resultado</summary>

|Producto|Precio|
|--------|------|
|1962 LanciaA Delta 16V|119.67|
</details>


```sql
SELECT p.productname AS Producto, od.priceeach AS Precio
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
ORDER BY buyprice ASC
LIMIT 1;
```
</details>

<details>
<summary>Ver resultado</summary>

|Producto|Precio|
|--------|------|
|1958 Chevy Corvette Limited Edition|30.41|

</details>

### Productos con más y menos margen de ganancia 

```sql
SELECT p.productcode AS Code, p.productline as Line, p.productname AS Product, p.buyprice AS Buy_Price, od.priceeach AS Sale_Price, (od.priceeach - p.buyprice) AS Margin, ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2) AS '%'
FROM products AS p
JOIN orderdetails as od ON p.productcode = od.productcode
GROUP BY p.productcode, od.priceeach
ORDER BY Margin DESC
LIMIT 10;
```

<details>
<summary>Ver resultado</summary>
        
|Code|Line|Product|Buy_Price|Sale_Price|Margin|%|
|----|----|-------|---------|----------|------|-|
|S10_1949|Classic Cars|1952 Alpine Renault 1300|98.58|214.30|115.72|117.39|
|S10_1949|Classic Cars|1952 Alpine Renault 1300|98.58|212.16|113.58|115.22|
|S12_1108|Classic Cars|2001 Ferrari Enzo|95.59|207.80|112.21|117.39|
|S10_1949|Classic Cars|1952 Alpine Renault 1300|98.58|210.01|111.43|113.04|
|S12_1108|Classic Cars|2001 Ferrari Enzo|95.59|205.72|110.13|115.21|
|S10_1949|Classic Cars|1952 Alpine Renault 1300|98.58|207.87|109.29|110.86|
|S12_1108|Classic Cars|2001 Ferrari Enzo|95.59|203.64|108.05|113.03|
|S10_1949|Classic Cars|1952 Alpine Renault 1300|98.58|205.73|107.15|108.69|
|S12_1108|Classic Cars|2001 Ferrari Enzo|95.59|201.57|105.98|110.87|
|S10_1949|Classic Cars|1952 Alpine Renault 1300|98.58|203.59|105.01|106.52|
</details>


```sql
SELECT p.productcode AS Code, p.productline as Line, p.productname AS Product, p.buyprice AS Buy_Price, od.priceeach AS Sale_Price, (od.priceeach - p.buyprice) AS Margin, ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2) AS '%'
FROM products AS p
JOIN orderdetails as od ON p.productcode = od.productcode
GROUP BY p.productcode, od.priceeach
ORDER BY Margin ASC
LIMIT 10;
```

<details>
<summary>Ver resultado</summary>
        
|Code|Line|Product|Buy_Price|Sale_Price|Margin|%|
|----|----|-------|---------|----------|------|-|
|S24_1937|Vintage Cars|1939 Chevrolet Deluxe Coupe|22.57|26.55|3.98|17.63|
|S24_1937|Vintage Cars|1939 Chevrolet Deluxe Coupe|22.57|27.22|4.65|20.60|
|S24_1937|Vintage Cars|1939 Chevrolet Deluxe Coupe|22.57|27.55|4.98|22.06|
|S24_1937|Vintage Cars|1939 Chevrolet Deluxe Coupe|22.57|27.88|5.31|23.53|
|S24_1937|Vintage Cars|1939 Chevrolet Deluxe Coupe|22.57|28.88|6.31|27.96|
|S24_1937|Vintage Cars|1939 Chevrolet Deluxe Coupe|22.57|29.21|6.64|29.42|
|S72_1253|Planes|Boeing X-32A JSF|32.77|39.73|6.96|21.24|
|S24_1937|Vintage Cars|1939 Chevrolet Deluxe Coupe|22.57|29.54|6.97|30.88|
|S24_1937|Vintage Cars|1939 Chevrolet Deluxe Coupe|22.57|29.87|7.30|32.34|
|S72_1253|Planes|Boeing X-32A JSF|32.77|40.22|7.45|22.73|

</details>

### Margen de ganancia promedio por línea de producto

```sql
SELECT p.productline AS Line, AVG(ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2)) AS '%'
FROM products AS p
JOIN orderdetails AS od ON p.productcode = od.productcode
GROUP BY p.productline
ORDER BY AVG(ROUND(((od.priceeach - p.buyprice)/p.buyprice)*100,2)) DESC;
```

<details>
<summary>Ver resultado</summary>
        
|Line|%|
|----|-|
|Motorcycles|73.461365|
|Vintage Cars|71.528600|
|Trucks and Buses|71.497987|
|Ships|69.568286|
|Classic Cars|69.389624|
|Planes|64.529911|
|Trains|64.112963|

</details>

### Productos más vendidos en 2003, 2004, 2005 y período 2003-2005


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

<details>
<summary>Ver resultado</summary>

|Product|Line|Product_Code|Quantity_Ordered|
|-------|----|------------|----------------|
|1992 Ferrari 360 Spider red|Classic Cars|S18_3232|672|
|1936 Mercedes-Benz 500K Special Roadster|Vintage Cars|S18_1367|429|
|1964 Mercedes Tour Bus|Trucks and Buses|S18_2319|427|
|1940s Ford truck|Trucks and Buses|S18_4600|408|
|1926 Ford Fire Engine|Trucks and Buses|S18_2432|393|
|1956 Porsche 356A Coupe|Classic Cars|S24_3856|389|
|1965 Aston Martin DB5|Classic Cars|S18_1589|382|
|1948 Porsche Type 356 Roadster|Classic Cars|S18_3685|382|
|1996 Peterbilt 379 Stake Bed with Outrigger|Trucks and Buses|S32_3522|373|
|1950's Chicago Surface Lines Streetcar|Trains|S32_3207|372|

</details>


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


<details>
<summary>Ver resultado</summary>
        
|Product|Line|Product_Code|Quantity_Ordered|
|-------|----|------------|----------------|
|1992 Ferrari 360 Spider red|Classic Cars|S18_3232|789|
|1980s Black Hawk Helicopter|Planes|S18_1662|567|
|2001 Ferrari Enzo|Classic Cars|S12_1108|566|
|The USS Constitution Ship|Ships|S700_2610|541|
|1941 Chevrolet Special Deluxe Cabriolet|Vintage Cars|S18_3856|536|
|1930 Buick Marquette Phaeton|Vintage Cars|S50_1341|535|
|ATA: B757-300|Planes|S700_2834|533|
|American Airlines: MD-11S|Planes|S700_4002|531|
|1969 Harley Davidson Ultimate Chopper|Motorcycles|S10_1678|530|
|1937 Lincoln Berline|Vintage Cars|S18_1342|524|
</details>

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

<details>
<summary>Ver resultado</summary>

|Product|Line|Product_Code|Quantity_Ordered|
|-------|----|------------|----------------|
|1992 Ferrari 360 Spider red|Classic Cars|S18_3232|347|
|1969 Dodge Charger|Classic Cars|S12_4675|272|
|1997 BMW R 1100 S|Motorcycles|S24_1578|271|
|1997 BMW F650 ST|Motorcycles|S32_1374|257|
|1956 Porsche 356A Coupe|Classic Cars|S24_3856|255|
|1960 BSA Gold Star DBD34|Motorcycles|S24_2000|242|
|1900s Vintage Tri-Plane|Planes|S24_4278|238|
|2002 Suzuki XREO|Motorcycles|S12_2823|231|
|1996 Moto Guzzi 1100i|Motorcycles|S10_2016|230|
|1941 Chevrolet Special Deluxe Cabriolet|Vintage Cars|S18_3856|226|
</details>

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

<details>
<summary>Ver resultado</summary>

|Product|Line|Product_Code|Quantity_Ordered|
|-------|----|------------|----------------|
|1992 Ferrari 360 Spider red|Classic Cars|S18_3232|1808|
|1937 Lincoln Berline|Vintage Cars|S18_1342|1111|
|American Airlines: MD-11S|Planes|S700_4002|1085|
|1941 Chevrolet Special Deluxe Cabriolet|Vintage Cars|S18_3856|1076|
|1930 Buick Marquette Phaeton|Vintage Cars|S50_1341|1074|
|1940s Ford truck|Trucks and Buses|S18_4600|1061|
|1969 Harley Davidson Ultimate Chopper|Motorcycles|S10_1678|1057|
|1957 Chevy Pickup|Trucks and Buses|S12_4473|1056|
|1964 Mercedes Tour Bus|Trucks and Buses|S18_2319|1053|
|1956 Porsche 356A Coupe|Classic Cars|S24_3856|1052|
</details>

### Productos menos vendidos período 2003-2005

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

<details>
<summary>Ver resultado</summary>

|Product|Line|Product_Code|Quantity_Ordered|
|-------|----|------------|----------------|
|1957 Ford Thunderbird|Classic Cars|S18_4933|767|
|1970 Chevy Chevelle SS 454|Classic Cars|S24_1046|803|
|1936 Mercedes Benz 500k Roadster|Vintage Cars|S24_3969|824|
|1911 Ford Town Car|Vintage Cars|S18_2248|832|
|1999 Indy 500 Monte Carlo SS|Classic Cars|S18_2870|855|
|1932 Alfa Romeo 8C2300 Spider Sport|Vintage Cars|S18_4409|866|
|1992 Porsche Cayenne Turbo Silver|Classic Cars|S24_4048|867|
|1969 Chevrolet Camaro Z28|Classic Cars|S24_3191|870|
|1952 Citroen-15CV|Classic Cars|S24_2887|873|
|1928 Mercedes-Benz SSK|Vintage Cars|S18_2795|880|
</details>

### 3 ordenes de mayor monto


```sql  
SELECT ordernumber AS Order_Number, SUM((priceeach * quantityordered)) AS Total
FROM orderdetails
GROUP BY ordernumber
ORDER BY Total DESC
LIMIT 3;
```

<details>
<summary>Ver resultado</summary>

|Order_Number|Total|
|------------|-----|
|10165|67392.85|
|10287|61402.00|
|10310|61234.67|

</details>

### Busco cliente de las 3 facturas de mayor monto

```sql  
SELECT od.ordernumber AS Order_Number, SUM((od.priceeach * od.quantityordered)) AS Total, c.customername as Customer_Name
FROM orderdetails AS od
JOIN orders AS o ON od.ordernumber = o.ordernumber
JOIN customers AS c ON c.customernumber = o.customernumber 
GROUP BY od.ordernumber
ORDER BY Total DESC
LIMIT 3;
```


<details>
<summary>Ver resultado</summary>
        
|Order_Number|Total|Customer_Name|
|------------|-----|-------------|
|10165|67392.85|Dragon Souveniers, Ltd.|
|10287|61402.00|Vida Sport, Ltd|
|10310|61234.67|Toms Spezialitäten, Ltd|
</details>

### Busco detalles e información de cada una de las facturas de mayor monto

```sql  
SELECT od.ordernumber AS Order_Number, od.productcode AS Product_Code, p.productname AS Product, od.priceeach AS Price, od.quantityordered AS Quantity, SUM((od.priceeach * od.quantityordered)) AS Total
FROM orders AS o
JOIN orderdetails AS od ON od.ordernumber = o.ordernumber
JOIN products AS p ON p.productcode = od.productcode
WHERE od.ordernumber = '10165' OR od.ordernumber = '10287' OR od.ordernumber = '10310'
GROUP BY od.ordernumber, od.productcode, p.productname, od.priceeach, od.quantityordered
ORDER BY od.ordernumber, Total DESC;
```


<details>
<summary>Ver resultado</summary>

|Order_Number|Product_Code|Product|Price|Quantity|Total|
|------------|------------|-------|-----|--------|-----|
|10165|S12_1108|2001 Ferrari Enzo|168.32|44|7406.08|
|10165|S18_3232|1992 Ferrari 360 Spider red|154.10|47|7242.70|
|10165|S18_2319|1964 Mercedes Tour Bus|120.28|46|5532.88|
|10165|S12_4473|1957 Chevy Pickup|109.02|48|5232.96|
|10165|S50_1392|Diamond T620 Semi-Skirted Tanker|106.49|48|5111.52|
|10165|S18_3259|Collectable Wooden Train|84.71|50|4235.50|
|10165|S12_3148|1969 Corvair Monza|123.89|34|4212.26|
|10165|S12_3891|1969 Ford Falcon|152.26|27|4111.02|
|10165|S18_2238|1998 Chrysler Plymouth Prowler|134.26|29|3893.54|
|10165|S24_2300|1962 Volkswagen Microbus|117.57|32|3762.24|
|10165|S18_4027|1970 Triumph Spitfire|123.51|28|3458.28|
|10165|S24_4048|1992 Porsche Cayenne Turbo Silver|106.45|24|2554.80|
|10165|S32_2509|1954 Greyhound Scenicruiser|50.86|48|2441.28|
|10165|S32_3207|1950's Chicago Surface Lines Streetcar|55.30|44|2433.20|
|10165|S18_2432|1926 Ford Fire Engine|60.77|31|1883.87|
|10165|S50_1514|1962 City of Detroit Streetcar|49.21|38|1869.98|
|10165|S24_1444|1970 Dodge Coronet|46.82|25|1170.50|
|10165|S24_2840|1958 Chevy Corvette Limited Edition|31.12|27|840.24|
|10287|S12_3380|1968 Dodge Charger|117.44|45|5284.80|
|10287|S18_3482|1976 Ford Gran Torino|127.88|40|5115.20|
|10287|S18_2870|1999 Indy 500 Monte Carlo SS|114.84|44|5052.96|
|10287|S24_3856|1956 Porsche 356A Coupe|137.62|36|4954.32|
|10287|S18_3232|1992 Ferrari 360 Spider red|137.17|36|4938.12|
|10287|S18_1129|1993 Mazda RX-7|113.23|41|4642.43|
|10287|S18_4721|1957 Corvette Convertible|119.04|34|4047.36|
|10287|S12_1099|1968 Ford Mustang|190.68|21|4004.28|
|10287|S18_3685|1948 Porsche Type 356 Roadster|139.87|27|3776.49|
|10287|S24_4620|1961 Chevrolet Impala|79.22|40|3168.80|
|10287|S12_3990|1970 Plymouth Hemi Cuda|74.21|41|3042.61|
|10287|S18_1984|1995 Honda Civic|123.76|24|2970.24|
|10287|S18_3278|1969 Dodge Super Bee|68.35|43|2939.05|
|10287|S18_1889|1948 Porsche 356-A Roadster|61.60|44|2710.40|
|10287|S12_4675|1969 Dodge Charger|107.10|23|2463.30|
|10287|S24_3371|1971 Alpine Renault 1600s|58.17|20|1163.40|
|10287|S24_2972|1982 Lamborghini Diablo|31.34|36|1128.24|
|10310|S18_3232|1992 Ferrari 360 Spider red|159.18|48|7640.64|
|10310|S24_3856|1956 Porsche 356A Coupe|139.03|45|6256.35|
|10310|S18_3482|1976 Ford Gran Torino|122.00|49|5978.00|
|10310|S12_1099|1968 Ford Mustang|165.38|33|5457.54|
|10310|S18_4721|1957 Corvette Convertible|133.92|40|5356.80|
|10310|S18_1129|1993 Mazda RX-7|128.80|37|4765.60|
|10310|S12_3990|1970 Plymouth Hemi Cuda|77.41|49|3793.09|
|10310|S24_4620|1961 Chevrolet Impala|75.18|49|3683.82|
|10310|S18_1984|1995 Honda Civic|129.45|24|3106.80|
|10310|S12_3380|1968 Dodge Charger|105.70|24|2536.80|
|10310|S12_4675|1969 Dodge Charger|101.34|25|2533.50|
|10310|S18_3782|1957 Vespa GS150|59.06|42|2480.52|
|10310|S18_3278|1969 Dodge Super Bee|70.76|27|1910.52|
|10310|S24_3371|1971 Alpine Renault 1600s|50.21|38|1907.98|
|10310|S32_2206|1982 Ducati 996 R|38.62|36|1390.32|
|10310|S18_1889|1948 Porsche 356-A Roadster|66.99|20|1339.80|
|10310|S24_2972|1982 Lamborghini Diablo|33.23|33|1096.59|
</details>

### Clientes deudores o pagos no registrados

```sql  
SELECT c.customerNumber AS Customer_Number, c.customerName AS Company,
c.contactLastName AS Contact_Name, c.contactFirstName AS Contact_Surname
FROM customers AS c
LEFT JOIN payments AS p ON c.customerNumber = p.customerNumber
WHERE p.checkNumber IS NULL;
```


<details>
<summary>Ver resultado</summary>

|Customer_Number|Company|Contact_Name|Contact_Surname|
|---------------|-------|------------|---------------|
|125|Havel & Zbyszek Co|Piestrzeniewicz|Zbyszek |
|168|American Souvenirs Inc|Franco|Keith|
|169|Porto Imports Co.|de Castro|Isabel |
|206|Asian Shopping Network, Co|Walker|Brydey|
|223|Natürlich Autos|Kloss|Horst |
|237|ANG Resellers|Camino|Alejandra |
|247|Messner Shopping Network|Messner|Renate |
|273|Franken Gifts, Co|Franken|Peter |
|293|BG&E Collectables|Harrison|Ed|
|303|Schuyler Imports|Schuyler|Bradley|
|307|Der Hund Imports|Andersen|Mel|
|335|Cramer Spezialitäten, Ltd|Cramer|Philip |
|348|Asian Treasures, Inc.|McKenna|Patricia |
|356|SAR Distributors, Co|Kuger|Armand|
|361|Kommission Auto|Josephs|Karin|
|369|Lisboa Souveniers, Inc|Rodriguez|Lino |
|376|Precious Collectables|Urs|Braun|
|409|Stuttgart Collectable Exchange|Müller|Rita |
|443|Feuer Online Stores, Inc|Feuer|Alexander |
|459|Warburg Exchange|Ottlieb|Sven |
|465|Anton Designs, Ltd.|Anton|Carmen|
|477|Mit Vergnügen & Co.|Moos|Hanna |
|480|Kremlin Collectables, Co.|Semenov|Alexander |
|481|Raanan Stores, Inc|Altagar,G M|Raanan|
</details>

### Análisis y categorización de créditos

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

<details>
<summary>Ver resultado</summary>

|Customer_Name|Credit_Limit|Categoria_Credito|
|-------------|------------|-----------------|
|Alpha Cognac|61100.00|Alto|
|Amica Models & Co.|113000.00|Alto|
|Anna's Decorations, Ltd|107800.00|Alto|
|Atelier graphique|21000.00|Medio|
|Australian Collectables, Ltd|60300.00|Alto|
|Australian Collectors, Co.|117300.00|Alto|
|Australian Gift Network, Co|51600.00|Alto|
|Auto Associés & Cie.|77900.00|Alto|
|Auto Canal+ Petit|95000.00|Alto|
|Auto-Moto Classics Inc.|23000.00|Medio|
|AV Stores, Co.|136800.00|Alto|
|Baane Mini Imports|81700.00|Alto|
|Bavarian Collectables Imports, Co.|77000.00|Alto|
|Blauer See Auto, Co.|59700.00|Alto|
|Boards & Toys Co.|11000.00|Medio|
|CAF Imports|59600.00|Alto|
|Cambridge Collectables Co.|43400.00|Medio|
|Canadian Gift Exchange Network|90300.00|Alto|
|Classic Gift Ideas, Inc|81100.00|Alto|
|Classic Legends Inc.|67500.00|Alto|
|Clover Collections, Co.|69400.00|Alto|
|Collectable Mini Designs Co.|105000.00|Alto|
|Collectables For Less Inc.|70700.00|Alto|
|Corporate Gift Ideas Co.|105000.00|Alto|
|Corrida Auto Replicas, Ltd|104600.00|Alto|
|Cruz & Sons Co.|81500.00|Alto|
|Daedalus Designs Imports|82900.00|Alto|
|Danish Wholesale Imports|83400.00|Alto|
|Diecast Classics Inc.|100600.00|Alto|
|Diecast Collectables|85100.00|Alto|
|Double Decker Gift Stores, Ltd|43300.00|Medio|
|Down Under Souveniers, Inc|88000.00|Alto|
|Dragon Souveniers, Ltd.|103800.00|Alto|
|Enaco Distributors|60300.00|Alto|
|Euro+ Shopping Channel|227600.00|Alto|
|Extreme Desk Decorations, Ltd|86800.00|Alto|
|Frau da Collezione|34800.00|Medio|
|FunGiftIdeas.com|85800.00|Alto|
|Gift Depot Inc.|84300.00|Alto|
|Gift Ideas Corp.|49700.00|Medio|
|Gifts4AllAges.com|41900.00|Medio|
|giftsbymail.co.uk|93900.00|Alto|
|GiftsForHim.com|77700.00|Alto|
|Handji Gifts& Co|97900.00|Alto|
|Heintze Collectables|120800.00|Alto|
|Herkku Gifts|96800.00|Alto|
|Iberia Gift Imports, Corp.|65700.00|Alto|
|Kelly's Gift Shop|110000.00|Alto|
|King Kong Collectables, Co.|58600.00|Alto|
|L'ordine Souveniers|121400.00|Alto|
|La Corne D'abondance, Co.|84300.00|Alto|
|La Rochelle Gifts|118200.00|Alto|
|Land of Toys Inc.|114900.00|Alto|
|Lyon Souveniers|68100.00|Alto|
|Marseille Mini Autos|65000.00|Alto|
|Marta's Replicas Co.|123700.00|Alto|
|Men 'R' US Retailers, Ltd.|57700.00|Alto|
|Microscale Inc.|39800.00|Medio|
|Mini Auto Werke|45300.00|Medio|
|Mini Caravy|53800.00|Alto|
|Mini Classics|102700.00|Alto|
|Mini Creations Ltd.|94500.00|Alto|
|Mini Gifts Distributors Ltd.|210500.00|Alto|
|Mini Wheels Co.|64600.00|Alto|
|Motor Mint Distributors Inc.|72600.00|Alto|
|Muscle Machine Inc|138500.00|Alto|
|Norway Gifts By Mail, Co.|95100.00|Alto|
|Online Diecast Creations Co.|114200.00|Alto|
|Online Mini Collectables|68700.00|Alto|
|Osaka Souveniers Co.|81200.00|Alto|
|Oulu Toy Supplies, Inc.|90500.00|Alto|
|Petit Auto|79900.00|Alto|
|Québec Home Shopping Network|48700.00|Medio|
|Reims Collectables|81100.00|Alto|
|Rovelli Gifts|119600.00|Alto|
|Royal Canadian Collectables, Ltd.|89600.00|Alto|
|Royale Belge|23500.00|Medio|
|Salzburg Collectables|71700.00|Alto|
|Saveley & Henriot, Co.|123900.00|Alto|
|Scandinavian Gift Ideas|116400.00|Alto|
|Signal Collectibles Ltd.|60300.00|Alto|
|Signal Gift Stores|71800.00|Alto|
|Souveniers And Things Co.|93300.00|Alto|
|Stylish Desk Decors, Co.|77000.00|Alto|
|Suominen Souveniers|98800.00|Alto|
|Super Scale Inc.|95400.00|Alto|
|Technics Stores Inc.|84600.00|Alto|
|Tekni Collectables Inc.|43000.00|Medio|
|The Sharp Gifts Warehouse|77600.00|Alto|
|Tokyo Collectables, Ltd|94400.00|Alto|
|Toms Spezialitäten, Ltd|120400.00|Alto|
|Toys of Finland, Co.|96500.00|Alto|
|Toys4GrownUps.com|90700.00|Alto|
|UK Collectables, Ltd.|92700.00|Alto|
|Vida Sport, Ltd|141300.00|Alto|
|Vitachrome Inc.|76400.00|Alto|
|Volvo Model Replicas, Co|53100.00|Alto|
|West Coast Collectables Co.|55400.00|Alto|
</details>
