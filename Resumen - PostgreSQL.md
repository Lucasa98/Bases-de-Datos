# PostgreSQL

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
CREATE SCHEMA persona;
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
CREATE TABLE persona.provincia (
    id_provincia	smallint	not null,
    nom_provincia	varchar(30)	not null,
    constraint pk_provincia primary key (id_provincia)
);

CREATE TABLE persona.localidad (
    id_provincia	smallint	not null,
    id_localidad	smallint	not null,
    nom_localidad	varchar(40)	not null,
    constraint pk_localidad primary key (id_provincia, id_localidad),
    constraint fk_localidad_provincia foreign key (id_provincia) references persona.provincia (id_provincia)
);
```

## INSERT

Sintaxis:

```SQL
INSERT INTO [nombreEsquema].[nombreTabla] VALUES ([valorColumna1], [valorColumna2], [valorColumna3], ...);
```

Ejemplo:

```SQL
INSERT INTO persona.localidad VALUES (1, 1, 'SANTA FE');
INSERT INTO persona.localidad VALUES (1, 2, 'SANTO TOME');
INSERT INTO persona.localidad VALUES (2, 1, 'PARANA');
INSERT INTO persona.localidad VALUES (2, 2, 'CONCORDIA');
```

## SELECT

Sintaxis:

```SQL
SELECT [listaDeColumnasYAlias], [listaAtributosDeGrupo]
    FROM [listaDeTablas]
    WHERE [condicion]
    GROUP BY [indiceONombreColumna]
    HAVING [condicionDeGrupo]
    ORDER BY [indiceONombreColumna] [desc/asc];
```

Ejemplo:

```SQL
SELECT nom_provincia provincia, count(*) localidades
    FROM persona.provincia p, persona.localidad l
    WHERE nom_localidad like 'S%'
        AND p.id_provincia = l.id_provincia
    GROUP BY 1
    HAVING COUNT(*)>1
    ORDER BY 2 desc;
```