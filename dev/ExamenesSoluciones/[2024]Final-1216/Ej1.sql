-- ////////////////////////////////////////////////
-- Ejercicio 1
-- a)
SELECT
    anio as "Año",
    ranking,
    apellido_nombre,
    total_facturado,
    CASE
        WHEN total_facturado > 500 THEN
            '*'
        ELSE
            ''
    END "resaltar"
FROM (
    SELECT
        EXTRACT(YEAR from CURRENT_DATE)-1 anio,
        *
    FROM f_calc(EXTRACT(YEAR from CURRENT_DATE)-1)
    UNION
    SELECT
        EXTRACT(YEAR from CURRENT_DATE)-2 anio,
        *
    FROM f_calc(EXTRACT(YEAR from CURRENT_DATE)-2)
    UNION
    SELECT
        EXTRACT(YEAR from CURRENT_DATE)-3 anio,
        *
    FROM f_calc(EXTRACT(YEAR from CURRENT_DATE)-3)
)
WHERE ranking <= 3
ORDER BY
    anio ASC,
    ranking ASC;