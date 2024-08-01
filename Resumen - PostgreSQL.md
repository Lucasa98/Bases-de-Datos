# PostgreSQL

Haremos referencia a la siguiente base de datos
![Detalle pubs](https://github.com/Lucasa98/Bases-de-Datos/blob/main/Practica/DetallePubs.png?raw=true)

## Comentarios

```SQL
-- Esto es un comentario
```

## CREATE

### Esquema

Sintaxis:

```SQL
CREATE SCHEMA [nombreEsquema];
```

Ejemplo:

```SQL
CREATE SCHEMA pubs;
```

### Tablas

Sintaxis:

```SQL
CREATE TABLE [nombreEsquema].[nombreTabla] (
    -- not null para campos obligatorios
    columna1	tipo	not null,
    columna2	tipo	not null,
    -- null para campos opcionales
    columna3	tipo	null,
    -- Clave primaria compuesta
    constraint pk_[nombre tabla] primary key (columna1, columna2),
    -- Clave foranea
    constraint fk_[nombreTabla]_[nombreOtraTabla] foreign key (columna1) references [nombreEsquema].[nombreOtraTabla] (columnaOtraTabla)
);
```

Ejemplo:

```SQL
CREATE TABLE pubs.Publishers (
	pub_id	char(4)		not null,
	pub_name	varchar(40)	not null,
	city	varchar(20)	null,
	state	char(2)		not null,
	country	varchar(30)	not null,
	constraint pk_publisher primary key (pub_id)
);

CREATE TABLE pubs.Employee (
	emp_id	char(9)		not null,
	fname	varchar(20)	not null,
	minit	char(1)		not null,
	lname	varchar(30)	not null,
	job_id	smallint	not null,
	job_lvl	smallint	null,
	pub_id	char(4)		not null,
	hire_date	timestamp	not null,
	constraint pk_employee primary key (emp_id),
	constraint fk_employee_publisher foreign key (pub_id) references pubs.Publishers (pub_id),
	constraint fk_employee_job foreign key (job_id) references pubs.Jobs (job_id)
);
```

## INSERT

Sintaxis:

```SQL
INSERT INTO [nombreEsquema].[nombreTabla] VALUES ([valorColumna1], [valorColumna2], [valorColumna3], ...);
```

Ejemplo:

```SQL
INSERT INTO pubs.Jobs VALUES (1, 'Job 1', 2, 3);
INSERT INTO pubs.Jobs VALUES (2, 'Job 2', 3, 4);
INSERT INTO pubs.Jobs VALUES (3, 'Job 3', 1, 3);
INSERT INTO pubs.Jobs VALUES (4, 'Job 4', 2, 5);
```

## SELECT

Sintaxis:

```SQL
SELECT
	[listaDeColumnasYAlias], [listaAtributosDeGrupoYAlias], [subqueriesYAlias]
FROM
	[nombreTabla] AS [aliasTabla]
JOIN
	[nombreOtraTabla] AS [aliasOtraTabla]
	ON [condicion]
WHERE
	[condicion]
GROUP BY
	[indiceONombreColumna]
HAVING
	[condicionDeGrupo]
ORDER BY
	[indiceONombreColumna] [DESC/ASC];
```

Ejemplo:

```SQL
SELECT
	pub_name AS name,
	COUNT(*) AS titles
FROM
	pubs.Publishers AS P
JOIN
	pubs.Titles AS T
	ON P.pub_id = T.pub_id
WHERE
	T.title LIKE 'S%' -- Regular Expression para decir "empieza con S"
GROUP BY
	P.pub_name
HAVING
	COUNT(*) > 1
ORDER BY
	titles DESC;
```

### DISTINCT

Elimina duplicados
```SQL
SELECT
	DISTINCT type
FROM
	titles;
```

### Operadores de agregación

Devuelve _atributos de grupo_
```AVG```: promedio
```MIN/MAX```: valor minimo o maximo
```COUNT```: numero de filas
```SUM```: sumatoria de valores

### GROUP BY

Cada fila es una agrupación de todas las filas con mismo ```[nombreColumna]```
En la salida del ```SELECT``` solo puede haber atributos de tuplas presentes en la clausula ```GROUP BY``` o _atributos de grupo_.
```SQL
SELECT
	type,
	AVG(price)
FROM
	titles
GROUP BY
	type;
```

### HAVING

Establece _condiciones de grupo_ con (obviamente) atributos de grupo
```SQL
SELECT
	type,
	AVG(price)
FROM
	titles
WHERE
	pub_id = '0877'
GROUP BY
	type
HAVING
	MIN(pubdate) > '1991-10-01';
```

### Subqueries

Como salida de SELECT's:
```SQL
SELECT
	title,
	(SELECT SUM(qty)
		FROM
			sales
		WHERE
			sales.title_id = titles.title_id)
		AS 'Cantidad vendida'
	FROM titles;
```

En cláusulas FROM:
```SQL
SELECT
	au_lname
FROM
	authors
INNER JOIN
	titleauthor
	ON authors.au_id = titleauthor.au_id
	INNER JOIN
		(SELECT
			titles.*
		FROM
			titles
		WHERE
			pub_id = '0736'
		) AS titlesAlgoData
		ON titleauthor.title_id = titlesAlgodata.title_id;
```

## CASE

Una especie de operador ternario (condicion, valor por el verdadero, valor por el falso)

Sintaxis:
```SQL
SELECT
	CASE
		WHEN [condicion] THEN [valorPorVerdadero]
		ELSE [valorPorFalse]
	END AS [alias]
FROM
	[nombreTabla];
```

Ejemplo:
```SQL
SELECT
	CASE
		WHEN type = 'business' THEN 'Negocios'
		ELSE 'Otros'
	END AS tipo
FROM
	titles;
```

## UNION

Sintaxis:
```SQL
[query1]

UNION ALL -- ALL previene la eliminación de duplicados

[query2]
```

Ejemplo:
```SQL
SELECT
	type, title
FROM
	titles
WHERE
	type = 'business'

UNION ALL

SELECT
	type, title
FROM
	titles
WHERE
		type = 'popular_comp'
```

## Stored Procedures

Sintaxis:
```SQL
CREATE OR REPLACE FUNCTION [nombreFuncion]
	(
	IN [nombreParametro1] [tipoParametro1] DEFAULT [valorPorOmision],
	IN [nombreParametro2] [tipoParametro2] DEFAULT [valorPorOmision],
	...
	)
	RETURNS [tipoRetorno]
	AS
	$$
	DECLARE
		[nombreVariableLocal1]	[tipoVariableLocal1]	:= [valorInicial1];
		[nombreVariableLocal2]	[tipoVariableLocal2]	:= [valorInicial2];
	BEGIN
		[instrucciones]
		RETURN;
	END
	$$
	LANGUAGE plpgsql
```

Ejemplo:
```SQL
CREATE OR REPLACE FUNCTION CambiarDomicilio
	(
	IN prmAu_lname	VARCHAR(40),
	IN prmAddress	VARCHAR(40)	DEFAULT 'NO ESPECIFICADO'
	)
	RETURNS void
	AS
	$$
	DECLARE
		apellido	VARCHAR(40)	:= 'LOPEZ';
		domicilio	VARCHAR(40);
	BEGIN
		UPDATE
			authors
		SET
			address = prmAddress
		WHERE
			au_lname LIKE prmAu_lname
	END
	$$
	LANGUAGE plpgsql
```

### Llamadas a Stored Procedures

Sintaxis:
```SQL
-- parametros por nombre
SELECT [nombreFuncion] ([nombreParametro1] := [valorParametro1], ...)
-- parametros por orden
SELECT [nombreFuncion] ([valorParametro1], [valorParametro2], ...)
```

### IF-ELSE

Sintaxis:
```SQL
IF [condicion] THEN
	...
ELSE
	...
RETURN;
```

### LOOP

Sintaxis:
```SQL
[etiquetaLoop]	-- opcional
LOOP
	...
	-- Esto se repetira hasta que se ejecute un EXIT [etiquetaLoop]
END LOOP [etiquetaLoop];
```

### WHILE

Sintaxis:
```SQL
[etiquetaLoop]	-- opcional
WHILE [expresionBooleana] LOOP
	...
END LOOP [etiquetaLoop]
```

### FOR

Sintaxis:
```SQL
[etiquetaLoop]	-- opcional
FOR [nombreIterador] IN [expresion1] [expresion2] ... LOOP
	...
END LOOP
```

## Anchored Declarations

El tipo de la variabla se asocia al tipo deun elemento de la DB

Sintaxis:
```SQL
...
DECLARE
	precio	titles.price%TYPE;
	BEGIN
		precio := (
			SELECT
				price
			FROM
				titles
			WHERE
				totle_id = prmTitle_id
		);
		RAISE NOTICE 'La publicacion % vale $%', prmTitle_id, precio;
	END
...
```

## Recuperar valores de single-row query

Sintaxis:
```SQL
DECLARE
	price1 titles.price%TYPE;
	type1 titles.type%TYPE;
BEGIN
	SELECT
		price, type INTO price1, type1	-- los valores price y type de la query se almacenan en price1 y type1
	FROM
		titles
	WHERE
		title_id = prmTitle_id;
	RAISE NOTICE 'La publicacion % es de tipo % y vale $%', prmTitle_id, trim(both FROM type1), price1;
END
```

## RECORD Anchoring

Se asocia el tipo de la variable a una tupla completa

Sintaxis:
```SQL
DECLARE
	titleRec	titles%ROWTYPE;
BEGIN
	SELECT
		* INTO titleRec
	FROM
		titles
	WHERE
		title_id = prmTitle_id;
	
	RAISE NOTICE 'La publicación % es de tipo % y vale $%', prmTitle_id, trim(both FROM titleRec.type) titleRec.price;
	...
END
```

### Projection

Se usa una _proyeccion_ de la tupla en lugar de la tupla completa
```SQL
CREATE TYPE titleCT
	AS (
		type	char(12),
		price	numeric
	);

	...
	DECLARE
		titleRec titleCT%ROWTYPE;
	BEGIN
		SELECT
			type, price INTO titleRec
		FROM
			titles
		WHERE
			title_id = prmTitle_id;
		
		RAISE NOTICE 'La publicacion % es de tipo % y vale $%', prmTitle_id, trim(both FROM titleRec.type), titleRec.price;
	END
```

