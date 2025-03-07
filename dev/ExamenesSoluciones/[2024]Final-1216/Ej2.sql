-- ////////////////////////////////////////////////
-- Ejercicio 2
-- a)
SELECT
    j.codigo_empleado,
    pf.apellido || pf.nombre "Nombre Completo",
    SUM(e.id) "Empleados a Cargo"
FROM Empleado j         -- Jefe
INNER JOIN Empleado e   -- Empleado
    ON e.id_jefe = j.id
INNER JOIN PersonaFisica pf
    ON pf.if = j.id_persona_fisica
GROUP BY j.id
ORDER BY j.id;

-- b)
SELECT

FROM Empleado e
    e.codigo_empleado,
    pfe.apellido || pfe.nombre "Empleado",
    CASE
        WHEN e.id_jefe IS NOT NULL THEN j.codigo_empleado
        ELSE 'NULL'
    END "codigo_jefe",
    CASE
        WHEN e.id_jefe IS NOT NULL THEN pfj.apellido || pfj.nombre
        ELSE 'NULL'
    END "nombre_jefe"
INNER JOIN PersonaFisica pfe
    ON pfe.id = e.id_persona_fisica
INNER JOIN Empleado j
    ON j.id = e.id_jefe
INNER JOIN PersonaFisica pfj
    ON pfj.id = j.id_persona_fisica
ORDER BY e.codigo_empleado;