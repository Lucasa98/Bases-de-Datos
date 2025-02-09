-- ////////////////////////////////////////////////
-- Ejercicio 4

CREATE TABLE Parcial2R2024.HistorialPrecios (
    id                  BIGSERIAL       NOT NULL,
    id_producto         BIGINT          NOT NULL,
    fechaHora_cambio    TIMESTAMP       NOT NULL,
    precio_anterior     NUMERIC(38,2)   NULL,
    CONSTRAINT PK_historialprecios PRIMARY KEY (id),
    CONSTRAINT FK_historialprecios FOREIGN KEY (id_producto) REFERENCES Parcial2R2024.Producto(id)
);

CREATE OR REPLACE FUNCTION Parcial2R2024.producto_precio_update()
RETURNS TRIGGER
AS
$$
DECLARE
ahora    TIMESTAMP;
BEGIN
    ahora := CURRENT_TIMESTAMP;
    INSERT INTO parcial2r2024.historialprecios
        (id_producto, fechaHora_cambio, precio_anterior)
    VALUES (OLD.id, ahora, OLD.precio_unitario);
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tgProductoPrecioUpdate
BEFORE UPDATE
OF precio_unitario
ON Parcial2R2024.Producto
FOR EACH ROW
EXECUTE FUNCTION Parcial2R2024.producto_precio_update();

-- ////////////////////////////////////////////////
-- Test

INSERT INTO parcial2r2024.marca
(id, "version", codigo, descripcion)
VALUES(0, 1, 1, 'marca 1');

INSERT INTO parcial2r2024.proveedor
(id, "version", codigo, fecha_alta)
VALUES(0, 1, 1, CURRENT_TIMESTAMP);

INSERT INTO parcial2r2024.producto
(id, codigo_producto, descripcion, precio_unitario, costo_unitario, id_proveedor, id_marca)
VALUES(0, 111, 'producto 1', 50.0, 45.0, 0, 0);

UPDATE parcial2r2024.producto
SET precio_unitario=69.0
WHERE id=0;