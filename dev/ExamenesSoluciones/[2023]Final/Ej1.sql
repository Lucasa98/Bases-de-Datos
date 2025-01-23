-- ////////////////////////////////////////////////
-- Crear Esquema
CREATE SCHEMA Final20231218;

-- Crear Tablas
CREATE TABLE Final20231218.Visita (
    numeroSerie     VARCHAR(20)     NOT NULL,
    fechaVisita     DATE            NOT NULL,
    observaciones   VARCHAR(256)    DEFAULT NULL,
    CONSTRAINT PK_visita PRIMARY KEY (fechaVisita, numeroSerie)
);

CREATE TABLE Final20231218.Sensor (
    numeroSerie     VARCHAR(20)     NOT NULL,
    codTaller       INT             NOT NULL,
    codProyecto     INT             NOT NULL,
    fechaFabric     DATE            NOT NULL,
    CONSTRAINT PK_sensor PRIMARY KEY (numeroSerie)
);

CREATE TABLE Final20231218.Proyecto (
    codProyecto     INT             NOT NULL,
    nombre          VARCHAR(120)    NOT NULL,
    monto           NUMERIC(9,2)    NOT NULL,
    CONSTRAINT PK_proyecto PRIMARY KEY (codProyecto)
);

CREATE TABLE Final20231218.LecturaSensor (
    numeroSerie     VARCHAR(20)     NOT NULL,
    fechaVisita     DATE            NOT NULL,
    momento         TIMESTAMP       NOT NULL,
    estadoEmocional VARCHAR(20)     NOT NULL,
    CONSTRAINT PK_lectura PRIMARY KEY (numeroSerie, fechaVisita, momento)
);

CREATE TABLE Final20231218.Taller (
    codTaller       INT             NOT NULL,
    nombre          VARCHAR(120)    NOT NULL,
    CONSTRAINT PK_taller PRIMARY KEY (codTaller)
);

ALTER TABLE Final20231218.Visita
ADD CONSTRAINT FK_visita_sensor FOREIGN KEY (numeroSerie) REFERENCES Final20231218.Sensor(numeroSerie);

ALTER TABLE Final20231218.LecturaSensor
ADD CONSTRAINT FK_lectura_visita FOREIGN KEY (numeroSerie, fechaVisita) REFERENCES Final20231218.Visita(numeroSerie, fechaVisita);

ALTER TABLE Final20231218.Sensor
ADD CONSTRAINT FK_sensor_taller FOREIGN KEY (codTaller) REFERENCES Final20231218.Taller(codTaller);

ALTER TABLE Final20231218.Sensor
ADD CONSTRAINT FK_sensor_proyecto FOREIGN KEY (codProyecto) REFERENCES Final20231218.Proyecto(codProyecto);

-- ////////////////////////////////////////////////
-- Ejercicio 1
/*
    Escribir una funcion PostgreSQL que permita importar archivos desde el
    sistema operativo con el comando COPY, en la tabla LecturaSensor.
    Asumir que el archivo de entrada registros con los siguientes atributos
     - numeroSerie: identificador del sensor.
     - momento: fecha/hora/minuto/segundo
     - estadoEmocional: varchar con valores "P", "A", "S", asignables a los
     estados "Pen-sar", "Actuar" y "Sentir".
    La funcion debe recibir como parametros:
     - archivoLecturas: varchar con el nombre del archivo que contiene los datos.
     - observaciones: varchar a registrar en la tabla Visita.
    En el atributo fechaVisita debe asignarse la fecha actual.
    La funcion debe ejecutar el comando COPY usando SQL dinamico, para poder utilizar
    la variable archivoLecturas que contiene el nombre del archivo a importar.
    Se deben insertar por cada archivo que se vaya a importar con la funcion, una
    fila en la tabla Visita y tantas filas en LecturaSensor como registros vengan en el
    archivo.
    La funcion debe retornar un string informando la cantidad de filas insertadas.
*/

CREATE OR REPLACE FUNCTION Final20231218.LeerSensor
(
    archivoLecturas VARCHAR(255),
    observaciones   VARCHAR(255)
)
RETURNS VARCHAR(255) as
$$
DECLARE
    QUERY TEXT;
    hoy DATE := CURRENT_DATE;
    rows INT;
BEGIN
    -- Tabla auxiliar
    CREATE TEMP TABLE tmp_lectura (
        numeroSerie     varchar(20),
        momento         TIMESTAMP,
        estadoEmocional char(1)
    );

    -- COPY a la tabla auxiliar
    QUERY := 'COPY tmp_lectura (numeroSerie, momento, estadoEmocional) FROM ''' 
         || archivoLecturas 
         || ''' WITH (FORMAT CSV, HEADER, DELIMITER '','')';
    EXECUTE QUERY;

    -- Registrar visita
    INSERT INTO Final20231218.Visita
        (numeroSerie, fechaVisita, observaciones)
    SELECT
        tmp.numeroSerie,
        hoy,
        observaciones
    FROM tmp_lectura tmp
    GROUP BY numeroSerie;

    -- Registrar lecturas
    INSERT INTO Final20231218.LecturaSensor
        (numeroSerie, momento, estadoEmocional, fechaVisita)
    SELECT
        tmp.numeroSerie,
        tmp.momento,
        CASE
            WHEN tmp.estadoEmocional = 'P' THEN 'Pensar'
            WHEN tmp.estadoEmocional = 'A' THEN 'Actuar'
            WHEN tmp.estadoEmocional = 'S' THEN 'Sentir'
            ELSE 'indefinido'
        END,
        hoy
    FROM tmp_lectura tmp;

    -- Final insertadas
    GET DIAGNOSTICS rows = ROW_COUNT;

    -- Eliminar tabla auxiliar
    DROP TABLE tmp_lectura;

    RETURN 'Numero de filas insertadas: ' || rows + 1;
END;
$$
LANGUAGE plpgsql;