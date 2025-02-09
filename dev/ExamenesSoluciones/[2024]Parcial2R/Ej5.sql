-- ////////////////////////////////////////////////
-- Ejercicio 5

CREATE TABLE Parcial2R2024.Inventario (
    id          BIGINT      NOT NULL,
    id_producto BIGINT      NOT NULL,
    cantidad    INTEGER     NOT NULL,
    fecha_act   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_inventario PRIMARY KEY (id),
    CONSTRAINT fk_inventario_producto FOREIGN KEY (id_producto) REFERENCES Parcial2R2024.Producto(id)
);

-- ////////////////////////////////////////////////
-- a
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

	UPDATE Parcial2R2024.Inventario
	SET cantidad = cantidad - 5
	WHERE id_producto = 0;

COMMIT;

-- ////////////////////////////////////////////////
-- b
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    SELECT cantidad
    FROM Parcial2R2024.Inventario
    WHERE id_producto = 0
    FOR UPDATE;

    UPDATE Parcial2R2024.Inventario
    SET cantidad = cantidad - 1
    WHERE id_producto = 0;

COMMIT;

-- ////////////////////////////////////////////////
-- c
/*
    En el caso de Serializable se generan bloqueos optimistas, es decir que en caso de que otra
    transaccion opere sobre la columna se genera un conflicto y se debe reintentar esta.
    En el caso de bloqueos pesimistas, se bloquea preventivamente la columna y cualquier otra operacion
    sobre la misma debe esperar que finalice la transaccion.
*/

-- ////////////////////////////////////////////////
-- d
/*
    En ambos casos los bloqueos se liberan en COMMIT o ROLLBACK.
*/
