-- ////////////////////////////////////////////////
-- Ejercicio 2
/*
    Codificar un control en un trigger PostgreSQL que en caso de insercion
    en la tabla LecturaSensor, realice lo siguiente:
    - Si el valor recibido en la insercion para el atributo estadoEmocional
    es igual al ultimo registrado para el sensor, no hacer nada
    - Por el contrario, si el valor recibido es distinto del ultimo
    estadoEmocional, en este caso si convalidar la insercion
*/

CREATE OR REPLACE FUNCTION Final20231218.insertLectura ()
RETURNS trigger AS
$$
DECLARE
    ultimoEstado VARCHAR(20);
BEGIN
    -- Consultar ultimo estadoEmocional para el sensor
    SELECT
        estadoEmocional
    INTO ultimoEstado
    FROM Final20231218.LecturaSensor ls
    WHERE ls.numeroSerie = NEW.numeroSerie
    ORDER BY ls.momento DESC
    LIMIT 1;

    -- Insertar solo si tiene nuevo estado distinto
    IF ultimoEstado IS NULL OR ultimoEstado != NEW.estadoEmocional THEN
        RETURN NEW;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ language plpgsql;

CREATE TRIGGER tgLecturaSensor_insert
BEFORE INSERT ON Final20231218.LecturaSensor
FOR EACH ROW
EXECUTE FUNCTION insertLectura();

-- ////////////////////////////////////////////////
-- Testear

INSERT INTO final20231218.taller
	(codtaller, nombre)
values
	(1, 'Taller 1'),
	(2, 'Taller 2'),
	(3, 'Taller 3');

INSERT INTO final20231218.proyecto
	(codproyecto, nombre, monto)
values
	(1, 'Proyecto 1', 1000),
	(2, 'Proyecto 2', 2000),
	(3, 'Proyecto 3', 3000);

INSERT INTO final20231218.sensor
	(numeroserie, codtaller, codproyecto, fechafabric)
values
	('SN12345', 1, 1, CURRENT_DATE),
	('SN67890', 2, 2, CURRENT_DATE),
	('SN34567', 3, 3, CURRENT_DATE);

-- y Ejecutar la funcion del Ej1 con el archiov `./lecturas.csv`