-- ////////////////////////////////////////////////
-- Ejercicio 3
/*
    Implemente un trigger que, por cada nueva entrada en Sales actualice
    los datos de la tabla ReporteVentas creada en el Ejercicio2.
*/
CREATE OR REPLACE FUNCTION Parcial2R2023.tgSalesInsert ()
RETURNS TRIGGER
as
$$
BEGIN
    IF NEW.ord_num in (SELECT r.ord_num FROM Parcial2R2023.ReporteVentas r) THEN
        UPDATE Parcial2R2023.ReporteVentas
        SET
            "Publicacion 1" = NEW.title_id,
            "Observaciones" = 'Mas de una publicacion en la venta'
        WHERE ord_num = NEW.ord_num
        AND (
            SELECT NEW.qty * t1.price
            FROM Parcial2R2023.Titles t1
            WHERE t1.title_id = NEW.title_id
        ) > (
            SELECT sa2.qty * t2.price
            FROM Parcial2R2023.Sales sa2
            INNER JOIN Parcial2R2023.Titles t2
                ON t2.title_id = sa2.title_id
            WHERE sa2.ord_num = NEW.ord_num
            AND t2.title_id = "Publicacion 1"
        );
    ELSE
        INSERT INTO Parcial2R2023.ReporteVentas (ord_num, stor_id, "Publicacion 1", "Observaciones")
        VALUES (NEW.ord_num, NEW.stor_id, NEW.title_id, 'Unica publicacion en la venta');
    END IF;

    RETURN NEW;
END;
$$ language plpgsql;

CREATE TRIGGER tg_sales_insert
BEFORE INSERT
ON Parcial2R2023.Sales
FOR EACH ROW
EXECUTE FUNCTION Parcial2R2023.tgSalesInsert();

-- ////////////////////////////////////////////////
-- Test
INSERT INTO Parcial2R2023.Sales
    (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES
    (7066, 'AA11TQTQ', CURRENT_DATE, 19, 'Net 30', 'TC7777');

-- Chusmear ReporteVentas

INSERT INTO Parcial2R2023.Sales
    (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES
    (7066, 'AA11TQTQ', CURRENT_DATE, 99, 'Net 30', 'TC4203'); -- aca reemplazar CURRENT_DATE por la que tenga la anterior

-- Chusmear Otra vez