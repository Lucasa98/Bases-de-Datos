-- ////////////////////////////////////////////////
-- Ejercicio 2
/*
    Almacene el reporte del Ejercicio 1 en una tabla ReporteVentas.
*/

SELECT
    sa1.ord_num,
    st1.stor_id,
    t1.title_id as "Publicacion 1",
    CASE
        WHEN (
            SELECT COUNT(sa3.title_id)
            FROM Parcial2R2023.Sales sa3
            WHERE sa3.ord_num = sa1.ord_num
        ) > 1 THEN 'Mas de una publicacion en la venta'
    ELSE 'Unica publicacion en la venta'
    END as "Observaciones"
INTO Parcial2R2023.ReporteVentas
FROM Parcial2R2023.Sales sa1
INNER JOIN Parcial2R2023.Stores st1
    ON st1.stor_id = sa1.stor_id
INNER JOIN Parcial2R2023.Titles t1
    ON t1.title_id = sa1.title_id
WHERE t1.title_id = (
    SELECT t2.title_id
    FROM Parcial2R2023.Titles t2
    INNER JOIN Parcial2R2023.Sales sa2
        ON sa2.title_id = t2.title_id
    WHERE sa2.ord_num = sa1.ord_num
    ORDER BY (t2.price * sa2.qty) DESC
    LIMIT 1
)
ORDER BY st1.stor_id;