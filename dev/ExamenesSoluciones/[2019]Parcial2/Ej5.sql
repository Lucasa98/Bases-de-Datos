-- ////////////////////////////////////////////////
-- Ejercicio 5
/*
    La FICH cuenta con la siguiente jerarquia de usuarios:
    sa -> adminFICH -> adminAlumnado
    Escriba las sentencias para:
    a) El usuario sa otorgue permiso de INSERT sobre la tabla titles al usuario adminFICH
    b) El usuario sa otorgue permiso de UPDATE sobre la tabla publishers (solo columna pubname)
    al usuario adminFICH
    Ademas:
    c) adminFICH debe otorgar permiso de INSERT sobre la tabla titles al usuario adminAlumnado.
    ¿Que sentencia o sentencias deben dispararse para que esto sea posible?
*/

-- a)
GRANT USAGE
    ON SCHEMA pubs
    TO adminFICH;

GRANT INSERT
    ON pubs.titles
    TO adminFICH;

-- b)
GRANT USAGE
    ON SCHEMA pubs
    TO adminFICH;

GRANT UPDATE (pub_name)
    ON pubs.publishers
    TO adminFICH;

GRANT SELECT (pub_name)
	ON pubs.publishers
	TO adminFICH;

-- c)
GRANT USAGE
    ON SCHEMA pubs
    TO adminFICH
    WITH GRANT OPTION;

GRANT INSERT
    ON pubs.titles
    TO adminFICH
    WITH GRANT OPTION;

SET ROLE adminFICH;

GRANT USAGE
    ON SCHEMA pubs
    TO adminAlumnado;

GRANT INSERT
    ON pubs.titles
    TO adminAlumnado;

-- ////////////////////////////////////////////////
-- Testear

create USER adminFICH
	with password 'fich';

CREATE USER adminAlumnado
    FOR LOGIN 'alumnado';

-- a)
SET ROLE root;

GRANT USAGE
    ON SCHEMA pubs
    TO adminFICH;

GRANT INSERT
    ON pubs.titles
    TO adminFICH;

SET ROLE adminFICH;

INSERT INTO pubs.titles
    (title_id, title, "type", pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
VALUES
    ('AA1111', 'Libro 1', 'UNDECIDED'::bpchar, '0736', 69, 6500.00, 21, 3336, 'Un broli', CURRENT_DATE);

-- b)
SET ROLE root;

GRANT USAGE
    ON SCHEMA pubs
    TO adminFICH;

GRANT UPDATE (pub_name)
    ON pubs.publishers
    TO adminFICH;

GRANT SELECT (pub_name)
	ON pubs.publishers
	TO adminFICH;

SET ROLE adminFICH;

UPDATE pubs.publishers
    SET pub_name = 'Los Libros de la Buena Memoria'
    WHERE pub_name = 'Lucerne Publishing';

-- c)
SET ROLE root;

GRANT USAGE
    ON SCHEMA pubs
    TO adminFICH
    WITH GRANT OPTION;

GRANT INSERT
    ON pubs.titles
    TO adminFICH
    WITH GRANT OPTION;

SET ROLE adminFICH;

GRANT USAGE
    ON SCHEMA pubs
    TO adminAlumnado;

GRANT INSERT
    ON pubs.titles
    TO adminAlumnado;

SET ROLE adminAlumnado;

INSERT INTO pubs.titles
    (title_id, title, "type", pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
VALUES
    ('BB2222', 'Libro B', 'UNDECIDED'::bpchar, '0736', 69, 6500.00, 21, 3336, 'Otro broli', CURRENT_DATE);