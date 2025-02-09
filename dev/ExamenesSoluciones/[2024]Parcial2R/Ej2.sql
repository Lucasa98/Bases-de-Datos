-- ////////////////////////////////////////////////
-- Ejercicio 2

CREATE OR REPLACE FUNCTION Parcial2R2024.f_calcular_facturacion(
    p_anio    NUMERIC,
    p_mes     NUMERIC,
    p_marca   VARCHAR(50)
)
RETURNS NUMERIC(38,2)
AS
$$
DECLARE
    prom NUMERIC(38,2);
BEGIN
    IF p_marca = '*' THEN
        SELECT
            AVG(f.total)
        INTO prom
        FROM Parcial2R2024.Factura f
        INNER JOIN Parcial2R2024.FacturaEstado fe
            ON fe.id_factura = f.id
        WHERE fe.tipo_estado = 'OK'
        AND EXTRACT(YEAR from fe.fechaHora_estado) = p_anio
        AND EXTRACT(MONTH from fe.fechaHora_estado) = p_mes;
    ELSE
        IF EXISTS(SELECT * FROM Parcial2R2024.Marca m WHERE m.descripcion = p_marca) THEN
            SELECT
                AVG(f.total)
            INTO prom
            FROM Parcial2R2024.Factura f
            INNER JOIN Parcial2R2024.FacturaEstado fe
                ON fe.id_factura = f.id
            INNER JOIN Parcial2R2024.FacturaDetalle fd
                ON fd.id_factura = f.id
            INNER JOIN Parcial2R2024.Producto p
                ON fd.id_producto = p.id
            INNER JOIN Parcial2R2024.Marca m
                ON p.id_marca = m.id
            WHERE fe.tipo_estado = 'OK'
            AND EXTRACT(YEAR from fe.fechaHora_estado) = p_anio
            AND EXTRACT(MONTH from fe.fechaHora_estado) = p_mes
            AND m.descripcion = p_marca;
        ELSE
            RAISE EXCEPTION 'No existe la marca consultada';
        END IF;
    END IF;
    RETURN prom;
END;
$$
LANGUAGE plpgsql;

-- Ejemplo
SELECT Parcial2R2024.f_calcular_facturacion('2023', '1', '*');
SELECT Parcial2R2024.f_calcular_facturacion('2023', '2', 'Pansasonic');
