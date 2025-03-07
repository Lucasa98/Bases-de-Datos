-- ////////////////////////////////////////////////
-- Ejercicio 3
-- a)
CREATE OR REPLACE FUNCTION UpdateJefe ()
RETURNS TRIGGER
AS $$
DECLARE
    empleados INTEGER;
BEGIN
    SELECT COUNT(e.id)
    INTO empleados
    FROM Empleado e
    WHERE e.id_jefe = NEW.id_jefe;

    IF empleados > 3 THEN
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tgUpdateJefe
BEFORE UPDATE OR INSERT
ON Empleado
FOR EACH ROW
EXECUTE PROCEDURE UpdateJefe();

-- b)
CREATE OR REPLACE FUNCTION UpdateJefe ()
RETURNS TRIGGER
AS $$
DECLARE
    empleados INTEGER;
BEGIN
    IF NEW.id_jefe IS NOT NULL NEW.id_jefe = NEW.id THEN
        RETURN NULL;
    END IF;

    SELECT COUNT(e.id)
    INTO empleados
    FROM Empleado e
    WHERE e.id_jefe = NEW.id_jefe;

    IF empleados > 3 THEN
        RETURN NULL;

    RETURN NEW;
END
$$
LANGUAGE plpgsql;

ALTER TABLE Empleado
ADD CONSTRAINT CHECK mismoJefe (id_jefe IS NULL OR id_jefe <> jefe);