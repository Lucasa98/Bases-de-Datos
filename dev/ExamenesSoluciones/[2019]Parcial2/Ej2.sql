-- ////////////////////////////////////////////////
-- Ejercicio 2
/*
    Almacenar el reporte (tal cual se muestra) en una tabla llamada InformeVentas
*/

SELECT
    sa.ord_num,
    st.stor_id,
    t.title_id AS "Publicacion 1",
    CASE
        WHEN (
            SELECT COUNT(sa3.title_id)
            FROM sales sa3
            WHERE sa3.ord_num = sa.ord_num
        ) > 1 THEN 'Mas de una publicacion en la venta'
    ELSE
        'Unica publciacion en la venta'
  	END AS "Observaciones"
INTO InformeVentas -- UNICA DIFERENCIA
FROM stores st
INNER JOIN sales sa
    ON sa.stor_id = st.stor_id
INNER JOIN titles t
    ON t.title_id = sa.title_id
WHERE t.title_id = (
    SELECT t2.title_id
    FROM titles t2
    INNER JOIN sales sa2
        ON sa2.title_id = t2.title_id
    WHERE sa2.ord_num = sa.ord_num
    ORDER BY sa2.qty * t2.price DESC
    LIMIT 1
)
ORDER BY st.stor_id ASC;