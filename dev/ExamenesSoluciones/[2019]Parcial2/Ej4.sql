-- ////////////////////////////////////////////////
-- Creacion de Tablas

-- Crear Esquema
CREATE SCHEMA parcial22019Ej4;

CREATE TABLE parcial22019Ej4.Proveedores (
    IDProveedor     int             NOT NULL,
    descrip         varchar(200)    NOT NULL,
    CONSTRAINT PK_proveedor PRIMARY KEY (IDProveedor)
);

CREATE TABLE parcial22019Ej4.Componentes (
    IDComponente    int             NOT NULL,
    descrip         varchar(100)    NOT NULL,
    CONSTRAINT PK_componente PRIMARY KEY (IDComponente)
);

CREATE TABLE parcial22019Ej4.ProvComp (
    IDProveedor     int             NOT NULL,
    IDComponente    int             NOT NULL
);

ALTER TABLE parcial22019Ej4.ProvComp
ADD CONSTRAINT FK_provcompprov FOREIGN KEY (IDProveedor) REFERENCES parcial22019Ej4.Proveedores(IDProveedor);

ALTER TABLE parcial22019Ej4.ProvComp
ADD CONSTRAINT FK_provcompcomp FOREIGN KEY (IDComponente) REFERENCES parcial22019Ej4.Componentes(IDComponente);

-- ////////////////////////////////////////////////
-- Ejercicio 4
/*
    Obtener la razon social de los proveedores que, como minimo, proveen
    todos los componentes que provee el proveedor con idProveedor con valor 200
*/

SELECT p.descrip
FROM parcial22019Ej4.Proveedores p
INNER JOIN parcial22019Ej4.ProvComp pc
    ON pc.IDProveedor = p.IDProveedor
INNER JOIN parcial22019Ej4.Componentes c
    ON c.IDComponente = pc.IDComponente
where p.idproveedor != 200 
and (
    SELECT COUNT(pc2.IDComponente)
    FROM parcial22019Ej4.ProvComp pc2
    WHERE pc2.IDProveedor = p.IDProveedor
    AND pc2.IDComponente IN (
        SELECT pc3.IDComponente
        FROM parcial22019Ej4.ProvComp pc3
        WHERE pc3.IDProveedor = 200
    )
) = (
    SELECT COUNT(pc4.IDComponente)
    FROM parcial22019Ej4.ProvComp pc4
    WHERE pc4.IDProveedor = 200
)
group by p.idproveedor;

-- ////////////////////////////////////////////////
-- Testear

INSERT INTO parcial22019Ej4.Proveedores
    (IDProveedor, descrip)
VALUES
    (1, 'proveedor 1'),
    (2, 'proveedor 2'),
    (3, 'proveedor 3'),
    (4, 'proveedor 4'),
    (5, 'proveedor 5'),
    (6, 'proveedor 6'),
    (7, 'proveedor 7'),
    (8, 'proveedor 8');
    (200, 'PROVEEDOR 200')

INSERT INTO parcial22019Ej4.Componentes
    (IDComponente, descrip)
VALUES
    (1, 'componente 1'),
    (2, 'componente 2'),
    (3, 'componente 3'),
    (4, 'componente 4'),
    (5, 'componente 5'),
    (6, 'componente 6'),
    (7, 'componente 7'),
    (8, 'componente 8'),
    (9, 'componente 9'),
    (10, 'componente 10'),
    (11, 'componente 11'),
    (12, 'componente 12'),
    (13, 'componente 13'),
    (14, 'componente 14'),
    (15, 'componente 15'),
    (16, 'componente 16'),
    (17, 'componente 17'),
    (18, 'componente 18'),
    (19, 'componente 19');

INSERT INTO parcial22019Ej4.ProvComp
    (IDProveedor, IDComponente)
VALUES
    (200,1),
    (200,2),
    (200,3),
    (200,4),
    (200,5),
    (200,6),
    (200,7),
    (1,10),
    (1,11),
    (1,12),
    (1,3),
    (1,4),
    (2,7),
    (2,6),
    (2,5),
    (2,4),
    (2,3),
    (2,2),
    (2,1),
    (2,10),
    (2,13),
    (3,19),
    (3,18),
    (3,17),
    (3,16),
    (3,15),
    (4,9),
    (4,8),
    (4,7),
    (5,1),
    (5,2),
    (5,3),
    (5,4),
    (5,5),
    (5,6),
    (5,7),
    (8,16),
    (7,7),
    (6,11);
