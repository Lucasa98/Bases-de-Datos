-- ////////////////////////////////////////////////
-- Crear Esquema

CREATE SCHEMA Parcial22023;

-- Crear Tablas
CREATE TABLE Parcial22023.Triangulo (
    idTriangulo     INT             NOT NULL,
    descripcion     VARCHAR(60),
    CONSTRAINT PK_triangulo PRIMARY KEY (idTriangulo)
);

CREATE TABLE Parcial22023.Lado (
    idLado          INT             NOT NULL,
    idTriangulo     INT             NOT NULL,
    descripcion     VARCHAR(60),
    longitudcm      INT,
    CONSTRAINT PK_lado PRIMARY KEY (idLado)
);

ALTER TABLE Parcial22023.Lado
ADD CONSTRAINT FK_lado_triangulo FOREIGN KEY (idTriangulo) REFERENCES Parcial22023.Triangulo(idTriangulo);

INSERT INTO Parcial22023.Triangulo
    (idTriangulo, descripcion)
VALUES
    (1, 'Triangulo 1'),
    (2, 'Triangulo 2');

INSERT INTO Parcial22023.Lado
    (idLado, idTriangulo, descripcion, longitudcm)
VALUES
    (1, 1, 'Lado AB', 5),
    (2, 1, 'Lado AC', 5),
    (3, 1, 'Lado BC', 9),
    (4, 2, 'Lado AB', 3),
    (5, 2, 'Lado AC', 5),
    (6, 2, 'Lado BC', 9);

-- ////////////////////////////////////////////////
-- Ejercicio 1
/*
    Se desea querer demostrar la propiedad de que, en un triangulo, la longitud
    de cada lado debe ser siempre menor que la suma de los otros dos lados.
    Esta Propiedad debe cumplirse para los tres lados de un triangulo.
    Se desea listar los nombres (descripcion) de todos los triangulos que son
    imposibles de dibujar de acuerdo a esta propiedad.
*/

SELECT
    t.descripcion
FROM Parcial22023.Triangulo t
INNER JOIN Parcial22023.Lado l
    ON l.idTriangulo = t.idTriangulo
WHERE l.longitudcm >= (
    SELECT SUM(l2.longitudcm)
    FROM Parcial22023.Lado l2
    WHERE l2.idTriangulo = l.idTriangulo
    AND l2.idLado != l.idLado
)
GROUP BY t.idTriangulo;
