/*tipos de ddatos en sql - (cualquier tipo de dbms)
-> numericos enteros:
    TINYINT = enteros muy pequeños
    SMALLINT = enteros pequeños
    *INT / INTEGER = enteros estandar
    BIGINT = enteros grandes

-> numericos decimales:
    *DECIMAL(p, s) / NUMERIC(p, s) = presicion exacta (ideal para dinero)
        -P: precision total
        -S: decimales

-> numerico flotante o aproximado:
    *FLOAT = doble precision en algunos motores de gestion de BBDD
    REAL = precision simple
    DOUBLE / DOUBLE PRECISION = mayor precision

-> cadenas de tamaño:
    CHAR(n) - ocupa exactamente n (usual 8) caracteres
    *VARCHAR(n) - hasta n caracteres (8kb)
    TEXT (MySql/PostgresSQL)
    TINYTEXT, MEDIUMTEXT, LONGTEXT (MySQL)
    NTEXT ((SQL server, obsoleto)

-> fecha/hora:
    *DATE = solo fecha (AAAA-MMM-DD)
    *TIME -solo hora
    *DATETIME = fecha y hora
    *TIMESTAMP = fecha y hora con zona/ajustes
    *YEAR (MySQL)

-> booleano:
    BOOLEAN/BOOL - se guarda bien 0/1 o True/False en muchos motores

-> binarios: (imagenes, archivos oi datos RAW/en crudo)
    *BINARY(n)
    VARBINARY(n)
    *BLOB - dato binario largo
    *TINYBLOB, *MEDIUMBLOB, LONGBLOB (MySQL)

-> tipos especiales dependientes del dbms (motor)
    PostgresSQL
        SERIAL, BIGSERIAL - autoicremento
        UUID - ientificadores unicos
        JSON, JSONB  - datosa en formato JSON
        array - arreglos
        INET, CIDR, MACADDR - redes/IP
        GEOMETRY, GEOGRAPHY - datos especiales (PostGIS)

    MySQL
        ENUM - lista de valores permitidos
        SET - conjunto de valores multiples
        JSON

    SQL Server
        UNIQUEIDENTIFYER - UUID
    
    XML
        GEOGRAPHY, GEOMETRY

*/


/*creacion y arranque de la bbdd*/
CREATE DATABASE biblioteca;
USE biblioteca;


/*creacion estructura de tablas*/
CREATE TABLE autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50)
);

CREATE TABLE libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    anio INT CHECK (anio >= 1500),
    id_autor INT NOT NULL, /* foreign key, campo que esta en la otra tabla*/
    CONSTRAINT fk_libro_autor /*construye fk*/
    FOREIGN KEY (id_autor) REFERENCES autor (id_autor)
    /* FK - campo que enlaza en mi tabla actual REFERENCES
    la_tabla_con_la_que_enlaza (campo con el que enlaza)
    
    */
);

CREATE TABLE socio (
    id_socio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_libro INT NOT NULL,
    id_socio INT NOT NULL,
 ----------------  
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
  --------------
    CONSTRAINT fk_prestamo_libro FOREIGN KEY (id_libro) REFERENCES libro(id_libro),
    CONSTRAINT fk_prestamo_socio FOREIGN KEY (id_socio) REFERENCES socio(id_socio)
);

/*
CIBER:
    - CHECK (condicion) - restriccion que obliga a que los valors insertados en esa columna cumplan la condicion
    - PRIMARY KEY - identificacion unica y exclusiva , no permite null y no se puede repetir
    - FOREIGN KEY - (clave foranea): establece la relacion entre 2 tablas. el valor siempre debe existir en ambas tablas relacionadas (autor en libro y en la tabla autor)
    - UNIQUE: evita que se repitan valores en la columna 
    - NOT NULL: impide los valores nulos, o sea se dben rellenar obligatoriamente
    - DEFAULT: si no introduces el valor, lo coloca por defecto al que se programe
    - AUTO_INCREMENT/SERIAL: dependiendo del motor de gestion de BBDD, se genera un numero consecutivo para las PKs:
        .MySQL: AUTO_INCREMENT
        .PostgreSQL: SERIAL
        .SQL Server: IDENTITY
    - INDEX: mejoramos la velocidad de busqueda - no es restriccion de integridad, es lo mas cercano a disponer de mongoDB y sus "cositas"
    - CONSTRAINT: regla que asegura la integridad de los datos en mysql, evitando datos invalidos, duplicados, o incoherentes entre 2 tablas


*/

/*AHORA INSERTAMOS DATOS*/

INSERT INTO autor (nombre, pais) VALUES
('Marta Tome', 'España');
('Isabel Allende', 'Chile');

/* select o podemos testear que la bbdd esta bien */

--obtencion de todos los libros
SELECT * FROM libro;
--obtener  ciertos campos nada mas
SELECT nombre FROM autor;
--obtener consultas mas parametrizadas
SELECT anio FROM libro WHERE anio>1970;
SELECT autor, anio FROM libro WHERE id_autor;---
--obtener datos en ascendente y descendente
SELECT id_autor, anio FROM libro ORDER BY anio ASC;
SELECT id_autor, anio FROM libro ORDER BY anio DESC;
--ahora funcionamos con funciones built-in
SELECT COUNT(*) AS total_autores FROM autor;--conteo
SELECT DISTINCT anio FROM libro;-- sin duplicados
SELECT id_autor, anio, FROM libro WHERE anio BETWEEN 1950 AND 1980; --entre fechas
SELECT nombre, email FROM socio WHERE email '%.com';

/*funciones prebuild de sql*/
COUNT() --cuenta registros -> SELECT COUNT (*) FROM libro;
SUM() -- suma valores -> SELECT SUM(precio) FROM libro;
AVG() -- promedio -> SELECT AVG(anio) FROM libro;
MAX() --maximo -> SELECT MAX(anio) FROM libro;
MIN() --MINIMO -> SELECT MIN(precio) FROM libro;

--- FUNCIONES DE TEXTO --
UPPER() --mayusculas -> SELECT UPPER('hola'); --> "HOLA"
LOWER() -- minusculas -> SELECT LOWER('HOLA'); --> "hola"
LENGTH() --longitud -> SELECT LENGTH ('libro'); --> 5
CONCAT()-- concatenacion -> SELECT CONCAT('Hola', 'Mundo'); --> "Hola Mundo"
SUBSTRING() --extraccion -> SELECT SUBSTRING('biblioteca', 1, 4); --> "bibl"
REPLACE() --reemplazo -> SELECT REPLACE('hola mundo', 'hola', 'hey'); --> "hey mundo"
TRIM() --quita espacios antes y despues -> SELECT TRIM('texto'); --> "texto"

--FUNCIONES MATEMATICAS/NUMERICAS --

ROUND() -- redondeo -> SELECT ROUND(3,14159,2); --> 3.14
CEIL() -- muestra el proximo mas pequeño al dado --> SELECT CEIL(4.1); --> 5
FLOOR() -- redondeo a la baja --> SELECT FLOOR(4.9); --> 4
ABS() --valor absoluto -> SELECT ABS(-8); --> 8
MOD() -- resto --> SELECT MOD(10,3); MOD(dividendo, divisor) --> 1

-- funciones de fecha y hora
NOW() --fecha y hora actual --> SELECT NOW();
CURDATE() -- solo fecha --> SELECT CURDATE();
CURTIME() -- solo hora --> SELECT CURTIME();
YEAR() --solo año --> SELECT YEAR ('2024-10-01');
MONTH() -- solo mes -> SELECT MONTH ('2024-10-01');
DAY() --solo dia -> SELECT DAY ('2024-10-01');
DATEDIFF() --SELECT DATEDIFF('2025-01-10','2025-01-01'); -->9
DATE_ADD() --fecha + x dias --> SELECT DATE_ADD(CURDATE(), INTERVAL 10 DAY);
DATE_SUB() --fecha -x dias -> SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- funciones de logicas/condicionales
IF() --condicional simple --> SELECT IF(1=1, 'Si', 'No');
IFNULL() --reemplazar NULL -> SELECT IFNULL(email, 'sin correo');
NULLIF() --devuelve NULL si son iguales -> SELECT NULLIF(5 ,5);
CASE -- condicionales multiple -> CASE WHEN edad>18 THEN 'Adulto' END
--Ejemplo completo de un CASE:
SELECT nombre,
    CASE
        WHEN anio < 1950 THEN 'Antiguo'
        WHEN anio BETWEEN 1950 AND 2000 THEN 'Moderno'
        ELSE 'Reciente'
    END AS categoria
FROM libro;

-- funciones de conversion
CAST() -- conversion de tipos -> SELECT CAST(10 AS CHAR);
CONVERT() -- conversion flexible -> SELECT CONVERT('2024-01-01', DATE);

--EJEMPLO INDIVIDUALIZADOS
SELECT COUNT(*), SUM(precio), AVG(precio), MAX(precio), MIN(precio)
FROM libro; --agregacion

SELECT UPPER(nombre), LENGTH(nombre), SUBSTRING(nombre, 1, 3)
FROM libro; --texto

SELECT precio, ROUND(precio,1), CEIL(precio), MOD(stock,5)
FROM libro; --matematicas

SELECT fecha_publicacion,
    YEAR(fecha_publicacion),
    DATEDIFF(NOW(), fecha_publicacion)
FROM libro; -- fechas

SELECT nombre,
    IF(stock>0, 'Disponible', 'Agotado'),
    CASE WHEN precio>30 THEN 'Caro' ELSE 'Economico' END
FROM libro; -- logicas

SELECT CAST(stock AS CHAR), CONVERT(precio, DECIMAL(10,2))
FROM libro; --conversion

--OPERADORES PATRONES Y FUNCIONES DE LIKE (SQL)
-- Operador LIKE se utiliza para comprar cadenas contra un RegExp (expresion regular)
...columna LIKE 'Patrón'...
-- % - cualquier numero de caracteres
nombre LIKE 'A%'--> empieza con A
nombre LIKE '%A'--> finaliza con A
nombre LIKE '%an%'--> contiene 'an'

--_un solo caracter
codigo LIKE 'A_1' --> A + 1 caracter + 1

-- conjuntos y rangos (solo en SQL Server, PostgresSQL y SQLite)
-- En MySQL NO funciona; usar REGEXP

--cualquiera de esos caracteres
nombre LIKE '[abc]%' --empieza con a, b, o c
-- rango d eletras
nombre LIKE '[A-Z]%' --empieza con mayuscula
-- NO esta en el rango
nombre LIKE '[^0-9]%' --NO empieza con numero
--negacion de LIKE
columna NOT LIKE '%texto%'

-- escape de caractereres especiales: si necesitas buscar un %, _ o [ ], debes escapar --
-->para MySQL Server
columna LIKE '%[%]%' -- busca corchetes

-->para MySQL y PostgreSQL
columna LIKE '%\%%' ESCAPE '\'; -- busca signo %

-- alternativas mas potentes que LIKE
MySQL -> REGEXP
PostgreSQL -> ~ y ~*
SQL Server -> LIKE + PATINDEX
SQLite -> REGEXP (si esta activado)

--Ejemplo a lo bruto
SELECT id_socio, nombre, email
FROM socio
WHERE email REGEXP '^[a-z0-9._%-]+@gmail.com$'; 

/*
^-> iniciamos la REGEXP
[a-z0-9._%-] -> nombre email con letras numeros guiones y puntos
@gmail.com -> dominio excato del email
$-> fin de la cadena
*/

-- funciones relacionadas que suelen usarse con LIKE
SELECT * FROM libros WHERE LOWER(nombre) LIKE LOWER('%Garcia%') --busquedas sin distinguir
SELECT * FROM libros WHERE RTRIM(nombre) LIKE 'Juan%' -- limpiar espacios derecha
SELECT * FROM libros WHERE LTRIM(nombre) LIKE 'Juan%' -- limpiar espacios izquierda
SELECT * FROM libros WHERE email LIKE CONCAT('%', 'gmail', '%') --concatenar patrones

