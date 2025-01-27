-- ////////////////////////////////////////////////
-- Ejercicio 3
/*
    Codificar un script en SQL standard que permita mostrar los proyecto,
    el monto aportado y la cantidad de sensores fabricados, ordenados por
    costo de fabricacion. La salida debe mostrar:
    nombreProyecto | montoAportado | cantidadSensorFabricados | costoPorSensor
    Se supone que el costo de fabricacion se calcula como el aporte del proyecto
    dividido la cantidad de sensores que se pudieron fabricar con su aporte.
*/

SELECT
    p.nombre as nombreProyecto,
    p.monto as montoAportado,
    COUNT(s.numeroSerie) as cantidadSensoroFabricados,
    p.monto / COUNT(numeroSerie) as costoPorSensor
FROM Final20231218.Proyecto p
INNER JOIN Final20231218.Sensor s
    ON s.codProyecto = p.codProyecto
GROUP BY p.codProyecto
ORDER BY p.monto / COUNT(numeroSerie) DESC;
