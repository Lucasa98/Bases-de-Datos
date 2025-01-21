-- ////////////////////////////////////////////////
-- Ejercicio 3
/*
    Implementar un trigger que, por cada insercion en la tabla Sales, actualice los
    datos de la tabla InformeVentas
*/

CREATE FUNCTION updateSales()
RETURNS trigger AS
$$
BEGIN
    -- Eliminar entrada para la ord_num y stor_id insertado
    DELETE FROM InformeVentas
    WHERE stor_id = NEW.stor_id
    AND ord_num = NEW.ord_num;

    -- Insertar entrada actualizada
    INSERT INTO InformeVentas (ord_num, stor_id, "Publicacion 1", "Observaciones")
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
    AND st.stor_id = NEW.stor_id
    AND sa.ord_num = NEW.ord_num;

    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tgSales_insert
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION updateSales();