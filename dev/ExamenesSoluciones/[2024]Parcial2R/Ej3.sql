-- ////////////////////////////////////////////////
-- Ejercicio 3

SELECT
    DISTINCT f.id_cliente as "Cliente",
    EXTRACT(MONTH from fe.fechaHora_estado) as "Mes",
    SUM(f.total) as "Total"
FROM Parcial2R2024.Factura f
INNER JOIN Parcial2R2024.FacturaEstado fe
    ON fe.id = f.id_estado_actual
WHERE EXTRACT(YEAR from fe.fechaHora_estado) = '2023'
GROUP BY f.id_cliente, fe.fechaHora_estado
HAVING SUM(f.total) > 0.5 * f_calcular_facturacion('2023', EXTRACT(MONTH from fe.fechaHora_estado), '*')
ORDER BY SUM(f.total);
