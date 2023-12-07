## Análisis de Diagrama de Entidad Relación

Antes de comenzar a buscar insights, es bueno realizar un análisis del diagrama de Entidad Relación para comprender la BBDD y comenzar a pensar en que información es interestante y mediante cuales queries lo podría obtener. En este caso *classicmodels* es una BBDD que ya esta modelada y diagramada, por lo que no es necesario realizarlo, así que ire directo al análisis. Lo primero que puedo ver mediante el ER es que esta base de datos esta compuesta por 8 tablas:

- **Productlines:**

Almacena una lista de líneas de producto. Esta compuesta por 4 columnas y cuenta con un identificador único y clave primaria con nombre 
'productLine'. Productlines esta relacionada con la tabla Products, con una cardinalidad de 1 a N. No tiene llave foránea determinada.

- **Products:**

Lista los distintos productos, en este caso los modelos de autos a escala. Esta compueta por 9 columnas y posee una clave primaria, 'productCode' y una clave foránea, 'productLine' de la tabla Productlines. Esta relacionada con la tabla Productlines ,como se menciono anteriormente, y tambien con la tabla Orderdetails, con una cardinalidad de 1 a N. 

- **Ordersdetails:**

Esta tabla detalla los productos en las órdenes de venta, y esta relacionada con Products y Orders. Esta compuesta por 5 columnas y posee dos claves foráneas, 'productCode' de la tabla Products y 'orderNumber' de la tabla Orders, juntas estas claves foráneas, componen la clave primaria (orderNumber, productLine). Esta relacionada con la tabla Products y tambien esta relacionada con la tabla Orders, con una cardinalidad de N a 1. 

- **Orders:**

Lista las ordenes de compra hechas por los clientes. Esta compuesta por 7 columnas, tiene una clave primaria 'orderNumber' y una clave foránea 'customerNumber' proveniente de la tabla Customers. Esta relacionada tanto con Orderdetails en 1 a N como con la tabla Customers con una cardinalidad de N a 1.

- **Customers:**

Tabla compuesta por 13 columnas, donde se detalla información de los clientes. Tiene una llave primaria 'customerNumber' y una llave foránea 'salesRepEmployeeNumber' proveniente de la tabla Employees. Esta tabla esta relacionada con tres tablas, con Orders, con una cardinalidad de 1 a N, con Payments, con una cardinalidad de 1 a N y con Employees, N a 1. 

- **Payments:**

Esta tabla muestra los pagos efectuados por los clientes. Esta compuesta por 4 columnas, su llave primaria esta compuesta por la clave foránea 'customerNumber' proveniente de Customers y 'checkNumber'. Su única relacion es con la tabla Customers con carinalidad N a 1.

- **Employees:**

Detalla la información de los empleados de la empresa. Esta compuesta por 8 columnas, su clave primaria es 'employeeNumber' y posee dos claves foráneas, 'officeCode' proveniente de Offices y 'reportsTo' que hace referencia a la clave primaria 'employeeNumber'. Esto último se debe a que un empleado tiene un superior, y ese superior es un empleado de la misma tabla, a esta referencia se le puede llamar "auto-referencia", es en la única tabla que lo vemos. Employees esta relacionada con Customers con una cardinalidad de 1 a N y tambien con la tabla Offices, en N a 1.

- **Offices:**

Finalmente, la tabla Offices, compuesta por 9 columnas, detalla información acerca de las oficinas de la empresa. Consta de una clave primaria, 'officeCode' y su relación es con la tabla Employees, donde tiene una cardinalidad de 1 a N.











