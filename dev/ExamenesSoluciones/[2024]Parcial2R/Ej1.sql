-- ////////////////////////////////////////////////
-- Ejercicio 1

-- Crear tabla
CREATE TABLE Parcial2R2024.FacturaEstado (
    id                  BIGSERIAL   NOT NULL,
    id_factura          BIGINT      NOT NULL,
    item_estado         SERIAL      NOT NULL,
    fechaHora_estado    TIMESTAMP   NOT NULL,
    tipo_estado         VARCHAR(10) NOT NULL,
    observacion         VARCHAR(255) NULL,
    CONSTRAINT PK_facturaestado PRIMARY KEY (id),
    CONSTRAINT AK_facturaestado UNIQUE (id_factura, item_estado),
    CONSTRAINT FK_facturaestado FOREIGN KEY (if_factura) REFERENCES Parcial2R2024.Factura(id)
);

-- Agregar columna a Factura
ALTER TABLE Parcial2R2024.Factura
ADD COLUMN id_estado_actual BIGINT NULL;

ALTER TABLE Parcial2R2024.Factura
ADD CONSTRAINT FK_factura_facturaestado FOREIGN KEY (id_estado_actual) REFERENCES Parcial2R2024.FacturaEstado(id);

-- Migrar datos
INSERT INTO Parcial2R2024.FacturaEstado
    (id_factura, fechaHora_estado, tipo_estado, observacion)
SELECT
    f.id,
    f.fecha_registro,
    'ET',
    'Migracion desde estructura anterior.'
FROM Parcial2R2024.Factura f;

INSERT INTO Parcial2R2024.FacturaEstado
    (id_factura, fechaHora_estado, tipo_estado, observacion)
SELECT
    f.id,
    f.fecha_anulacion,
    'AN',
    'Migracion desde estructura anterior.'
FROM Parcial2R2024.Factura f
WHERE f.fecha_anulacion IS NOT NULL;

INSERT INTO Parcial2R2024.FacturaEstado
    (id_factura, fechaHora_estado, tipo_estado, observacion)
SELECT
    f.id,
    f.fecha_confirmacion,
    'OK',
    'Migracion desde estructura anterior.'
FROM Parcial2R2024.Factura f
WHERE f.fecha_confirmacion IS NOT NULL;

UPDATE Parcial2R2024.Factura
SET id_estado_actual = (
    SELECT e.id
    FROM Parcial2R2024.FacturaEstado e
    WHERE e.id_factura = id_factura
    AND e.tipo_estado = 'ET'
)
WHERE fecha_anulacion IS NULL
AND fecha_confirmacion IS NULL;

UPDATE Parcial2R2024.Factura
SET id_estado_actual = (
    SELECT e.id
    FROM Parcial2R2024.FacturaEstado e
    WHERE e.id_factura = id_factura
    AND e.tipo_estado = 'OK'
)
WHERE fecha_confirmacion IS NOT NULL;

UPDATE Parcial2R2024.Factura
SET id_estado_actual = (
    SELECT e.id
    FROM Parcial2R2024.FacturaEstado e
    WHERE e.id_factura = id_factura
    AND e.tipo_estado = 'AN'
)
WHERE fecha_anulacion IS NOT NULL;

-- Eliminar columnas irrelevantes

ALTER TABLE Parcial2R2024.Factura
DROP COLUMN fecha_anulacion;

ALTER TABLE Parcial2R2024.Factura
DROP COLUMN fecha_confirmacion;

-- ////////////////////////////////////////////////
-- Test

CREATE SCHEMA Parcial2R2024;

CREATE TABLE Parcial2R2024.Cliente (
    id                  BIGINT      NOT NULL,
    id_persona          BIGINT      NOT NULL,
    codigo_cliente      INTEGER     NOT NULL,
    fecha_alta          DATE        NOT NULL,
    fecha_baja          DATE        NULL,
    CONSTRAINT PK_cliente PRIMARY KEY (id),
    CONSTRAINT AK_cliente1 UNIQUE (id_persona),
    CONSTRAINT AK_cliente2 UNIQUE (codigo_cliente)
);

CREATE TABLE Parcial2R2024.Marca (
    id                  BIGINT      NOT NULL,
    version             INTEGER     NOT NULL,
    codigo              INTEGER     NOT NULL,
    descripcion         VARCHAR(50) NOT NULL,
    CONSTRAINT PK_marca PRIMARY KEY (id),
    CONSTRAINT AK_marca UNIQUE (codigo)
);

CREATE TABLE Parcial2R2024.Proveedor (
    id                  BIGINT      NOT NULL,
    version             INTEGER     NOT NULL,
    codigo              INTEGER     NOT NULL,
    fecha_alta          TIMESTAMP   NULL,
    CONSTRAINT PK_proveedor PRIMARY KEY (id),
    CONSTRAINT AK_proveedor UNIQUE (codigo)
);

CREATE TABLE Parcial2R2024.Empleado (
    id                  BIGINT      NOT NULL,
    codigo_empleado     INTEGER     NOT NULL,
    fecha_alta          DATE        NOT NULL,
    fecha_baja          DATE        NULL,
    CONSTRAINT PK_empleado PRIMARY KEY (id),
    CONSTRAINT AK_empleado UNIQUE (codigo_empleado)
);

CREATE TABLE Parcial2R2024.Factura (
    id                  BIGINT      NOT NULL,
    numero_factura      INTEGER     NOT NULL,
    id_cliente          BIGINT      NOT NULL,
    id_empleado         BIGINT      NOT NULL,
    fecha_registro      DATE        NOT NULL,
    fecha_anulacion     DATE        NULL,
    fecha_confirmacion  DATE        NULL,
    descuento           NUMERIC(38,2) NOT NULL,
    total               NUMERIC(38,2) NOT NULL,
    CONSTRAINT PK_factura PRIMARY KEY (id),
    CONSTRAINT AK_factura UNIQUE (numero_factura),
    CONSTRAINT FK_factura_cliente FOREIGN KEY (id_cliente) REFERENCES Parcial2R2024.Cliente(id),
    CONSTRAINT FK_factura_empleado FOREIGN KEY (id_empleado) REFERENCES Parcial2R2024.Empleado(id)
);

CREATE TABLE Parcial2R2024.Producto (
    id                  BIGINT      NOT NULL,
    codigo_producto     INTEGER     NOT NULL,
    descripcion         VARCHAR(50) NOT NULL,
    precio_unitario     NUMERIC(38,2) NOT NULL,
    costo_unitario      NUMERIC(38,2) NOT NULL,
    id_proveedor        BIGINT      NULL,
    id_marca            BIGINT      NULL,
    CONSTRAINT PK_producto PRIMARY KEY (id),
    CONSTRAINT AK_producto UNIQUE (codigo_producto),
    CONSTRAINT FK_producto_marca FOREIGN KEY (id_marca) REFERENCES Parcial2R2024.Marca(id),
    CONSTRAINT FK_producto_proveedor FOREIGN KEY (id_proveedor) REFERENCES Parcial2R2024.Proveedor(id)
);

CREATE TABLE Parcial2R2024.FacturaDetalle (
    id                  BIGINT      NOT NULL,
    id_factura          BIGINT      NOT NULL,
    item_factura        INTEGER     NOT NULL,
    cantidad            NUMERIC(38,2) NOT NULL,
    precio_unitario     NUMERIC(38,2) NOT NULL,
    id_producto         BIGINT      NOT NULL,
    CONSTRAINT PK_facturadetalle PRIMARY KEY (id),
    CONSTRAINT AK_facturadetalle UNIQUE (id_factura, item_factura),
    CONSTRAINT FK_facturadetalle_factura FOREIGN KEY (id_factura) REFERENCES Parcial2R2024.Factura(id),
    CONSTRAINT FK_facutradetalle_producto FOREIGN KEY (id_producto) REFERENCES Parcial2R2024.Producto(id)
);

-- Ejecutar la solucion al ejercicio