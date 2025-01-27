-- ////////////////////////////////////////////////
-- Ejercicio 4
/*
    Modificar con un script SQL standard la estructura para permitir que la fabricacion
    de un mismo sensor sea realizada en mas de un taller, incorporando como dato el
    porcentaje aportado por cada taller.
    Hacer los cambios de estructura considerando que existen datos cargados previamente
    y no se pueden perder. Trasladar los datos de la estructura previa a la nueva.
*/

-- Tabla Intermedia
CREATE TABLE Final20231218.SensorTaller (
    numeroSerie VARCHAR(20)     NOT NULL,
    codTaller   INT             NOT NULL,
    aporte      DECIMAL(5,4)    NOT NULL,   -- Representacion 100.00% => 1.00000
    CONSTRAINT PK_sensortaller PRIMARY KEY (numeroSerie, codTaller)
);

ALTER TABLE Final20231218.SensorTaller
ADD CONSTRAINT FK_sensortaller_sensor FOREIGN KEY (numeroSerie) REFERENCES Final20231218.Sensor(numeroSerie);

ALTER TABLE Final20231218.SensorTaller
ADD CONSTRAINT FK_sensortaller_taller FOREIGN KEY (codTaller) REFERENCES Final20231218.Taller(codTaller);

-- Migrar datos a estructura nueva
INSERT INTO Final20231218.SensorTaller
    (numeroSerie, codTaller, aporte)
SELECT
    s.numeroSerie,
    t.codTaller,
    1.0000
FROM Final20231218.Sensor s
INNER JOIN Final20231218.Taller t
    ON t.codTaller = s.codTaller;

-- Modificar estructura de Sensor
ALTER TABLE Final20231218.Sensor
DROP CONSTRAINT FK_sensor_taller;

ALTER TABLE Final20231218.Sensor
DROP COLUMN codTaller;

-- Testear agregando

INSERT INTO Final20231218.Sensor
    (numeroSerie, codProyecto, fechaFabric)
VALUES ('AFT-2023-000023', 1, CURRENT_DATE);

INSERT INTO Final20231218.Taller
    (codTaller, nombre)
VALUES
    (4, 'El boliche de Picutin'),
    (8, 'La vinoteca del Tio Eloy');

INSERT INTO Final20231218.SensorTaller
    (numeroSerie, codTaller, aporte)
VALUES
    ('AFT-2023-000023', 4, 0.8),
    ('AFT-2023-000023', 8, 0.2);