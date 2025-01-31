-- ////////////////////////////////////////////////
-- Ejercicio 5
/*
    La FICH cuenta con la siguiente jerarquia de usuarios:
    sa -> adminfich -> adminalumnado
    Suponiendo que van a trabajar sobre un servidor SQL Server, y sobre la
    base de datos pubs, complete especificando la/s sentencia/s y el USER
    que debe disparar cada una para posibilitar las siguientes acciones:
     - A: el USER sa debe otorgar permiso de SELECT sobre la tabla publishers al USER adminfich
     - B: el USER sa debe otorgar permiso de INSERT sobre la tabla titles al USER adminfich
     - C: el USER sa debe otorgar permiso de UPDATE sobre la tabla publishers (pero solo sobre
     la columna pub_name) al USER adminfich
     - D: el USER adminfich debe otorgar permiso de INSERT sobre la tabla titles al USER adminalumnado.
*/

-- A
-- user sa
GRANT SELECT
ON pubs.publishers
TO adminfich;

-- B
-- user sa
GRANT INSERT
ON pubs.titles
TO adminfich;

-- C
-- user sa
GRANT UPDATE (pub_name)
ON pubs.publishers
TO adminfich;

-- D
-- user sa
GRANT INSERT
ON pubs.titles
TO adminfich
WITH GRANT OPTION;

-- user adminfich
GRANT INSERT
ON pubs.titles
TO adminalumnado;

-- ////////////////////////////////////////////////
-- Test
-- Hay que dar primero privilegios de uso al esquema pubs
GRANT USAGE
ON SCHEMA pubs
TO adminfich;

GRANT USAGE
ON SCHEMA pubs
TO adminalumnado;