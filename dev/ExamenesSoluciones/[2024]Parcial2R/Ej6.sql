-- ////////////////////////////////////////////////
-- Ejercicio 6
DECLARE
    @fechaInicio DATE = '2022-01-01',
    @fechaFin DATE = '2022-12-31',
    @fecha DATE,
    @sql VARCHAR(300);
SET @fecha = @fechaInicio;
WHILE(@fecha <= @fechaFin)
BEGIN
    SET @sql = 'ALTER TABLE #ventas_por_producto ADD ['
                + CAST(YEAR(@fecha) AS VARCHAR(4))
                + '-' + RIGHT('0' + CAST(MONTH(@fecha) AS VARCHAR(2)), 2)
                + '] NUMERIC(38,2) NULL;';
    EXEC(@sql);
    SET @fecha = DATEADD(MONTH, 1, @fecha);
END;

/*  a)
    Este codigo agrega un columna '2022-MES' por cada mes del ano al atabla ventas_por_producto.
    Es decir las columnas que crea son
    [2022-01], [2022-02], [2022-03], [2022-04], [2022-05], [2022-06], [2022-07], [2022-08], [2022-09], [2022-10], [2022-11], [2022-12]
*/

/*  b)
    Se creara una columna por cada mes, en este caso 294 columnas. El nombre de la primera es [2000-06] y la ultimo [2024-11]
*/