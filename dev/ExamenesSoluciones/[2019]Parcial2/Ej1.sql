-- ////////////////////////////////////////////////
-- Creacion de Tablas

-- Crear Esquema
CREATE SCHEMA parcial22019Ej1;

CREATE TABLE parcial22019Ej1.titles (
    title_id varchar(6) NOT NULL,
    title varchar(80) NOT NULL,
    type varchar(12) NOT NULL DEFAULT 'indefinido',
    price money,
    advance numeric(10,2),
    royalty int,
    ytd_sales int
    notes varchar(255),
    pubdate date NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT PK_title PRIMARY KEY (title_id)
);

CREATE TABLE parcial22019Ej1.sales (
    stor_id char(4) NOT NULL,
    title_id char(6) NOT NULL,
    ord_num varchar(20) NOT NULL,
    ord_date DATE NOT NULL,
    qty smallint NOT NULL,
    payterms varchar(12) NOT NULL,
    CONSTRAINT PK_sale PRIMARY KEY (stor_id, ord_num, title_id)
);

CREATE TABLE parcial22019Ej1.stores (
    stor_id char(4) NOT NULL,
    stor_name varchar(40),
    stor_address varchar(40),
    city varchar(20),
    state char(2),
    zip char(5),
    CONSTRAINT PK_store PRIMARY KEY (stor_id)
);

ALTER TABLE parcial22019Ej1.sales
ADD CONSTRAINT FK_salestitle FOREIGN KEY (title_id) REFERENCES parcial22019Ej1.titles(title_id);

ALTER TABLE parcial22019Ej1.sales
ADD CONSTRAINT FK_salesstores FOREIGN KEY (stor_id) REFERENCES parcial22019Ej1.stores(stor_id);

-- ////////////////////////////////////////////////
-- Ejercicio 1
/*
    Obtener un reporte donde se muestren, para cada factura (ord_num)
    y almacen (stor_id), dos columnas:
    "Publicacion 1": debe poseer el codigo (title_id) de la publicacion
    que mas dinero sumo en la factura (precio x cantidad vendida)
    "Observaciones": debe indicar si se trata de la unica publicacion en la
    factura o si existen otras publicaciones en la misma
*/

SELECT
    sa.ord_num,
    st.stor_id,
    t.title_id AS "Publicacion 1",
    CASE
        WHEN (
            SELECT COUNT(sa3.title_id)
            FROM sales sa3
            WHERE sa3.ord_num = sa.ord_num
        ) > 1 THEN 'Mas de una publicacion en la venta'
    ELSE
        'Unica publciacion en la venta'
  	END AS "Observaciones"
FROM stores st
INNER JOIN sales sa
    ON sa.stor_id = st.stor_id
INNER JOIN titles t
    ON t.title_id = sa.title_id
WHERE t.title_id = (
    SELECT t2.title_id
    FROM titles t2
    INNER JOIN sales sa2
        ON sa2.title_id = t2.title_id
    WHERE sa2.ord_num = sa.ord_num
    ORDER BY sa2.qty * t2.price DESC
    LIMIT 1
)
ORDER BY st.stor_id ASC;

-- ////////////////////////////////////////////////
-- Testear con

INSERT INTO parcial22019ej1.titles (title_id,title,"type",price,advance,royalty,ytd_sales,notes,pubdate) VALUES
	 ('PC1035','But Is It User Friendly?','popular_comp',$22.95,7000.00,16,8780,'A survey of software for the naive user, focusing on the ''friendliness'' of each.','1991-06-30'),
	 ('PC8888','Secrets of Silicon Valley','popular_comp',$20.00,8000.00,10,4095,'Muckraking reporting on the world''s largest computer hardware and software manufacturers.','1994-06-12'),
	 ('BU1032','The Busy Executive''s Database Guide','business',$19.99,5000.00,10,4095,'An overview of available database systems with emphasis on common business applications. Illustrated.','1991-06-12'),
	 ('PS7777','Emotional Security: A New Algorithm','psychology',$7.99,4000.00,10,3336,'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.','1991-06-12'),
	 ('PS3333','Prolonged Data Deprivation: Four Case Studies','psychology',$19.99,2000.00,10,4072,'What happens when the data runs dry?  Searching evaluations of information-shortage effects.','1991-06-12'),
	 ('BU1111','Cooking with Computers: Surreptitious Balance Sheets','business',$11.95,5000.00,10,3876,'Helpful hints on how to use your electronic resources to the best advantage.','1991-06-09'),
	 ('MC2222','Silicon Valley Gastronomic Treats','mod_cook',$19.99,0.00,12,2032,'Favorite recipes for quick, easy, and elegant meals.','1991-06-09'),
	 ('TC4203','Fifty Years in Buckingham Palace Kitchens','trad_cook',$11.95,4000.00,14,15096,'More anecdotes from the Queen''s favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.','1991-06-12'),
	 ('BU2075','You Can Combat Computer Stress!','business',$2.99,10125.00,24,18722,'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.','1991-06-30'),
	 ('PS2091','Is Anger the Enemy?','psychology',$10.95,2275.00,12,2045,'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.','1991-06-15'),
	 ('PS2106','Life Without Fear','psychology',$7.00,6000.00,10,111,'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.','1991-10-05'),
	 ('MC3021','The Gourmet Microwave','mod_cook',$2.99,15000.00,24,22246,'Traditional French gourmet recipes adapted for modern microwave cooking.','1991-06-18'),
	 ('TC3218','Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean','trad_cook',$20.95,7000.00,10,375,'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.','1991-10-21'),
	 ('MC3026','The Psychology of Computer Cooking','indefinido',NULL,NULL,NULL,NULL,NULL,'2025-01-20'),
	 ('BU7832','Straight Talk About Computers','business',$19.99,5000.00,10,4095,'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.','1991-06-22'),
	 ('PS1372','Computer Phobic AND Non-Phobic Individuals: Behavior Variations','psychology',$21.59,7000.00,10,375,'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.','1991-10-21'),
	 ('PC9999','Net Etiquette','popular_comp',NULL,NULL,NULL,NULL,'A must-read for computer conferencing.','2025-01-20'),
	 ('TC7777','Sushi, Anyone?','trad_cook',$14.99,8000.00,10,4095,'Detailed instructions on how to make authentic Japanese sushi in your spare time.','1991-06-12');

INSERT INTO parcial22019ej1.stores (stor_id,stor_name,stor_address,city,state,zip) VALUES
	 ('7066','Barnum''s','567 Pasadena Ave.','Tustin','CA','92789'),
	 ('7067','News & Brews','577 First St.','Los Gatos','CA','96745'),
	 ('7131','Doc-U-Mat: Quality Laundry and Books','24-A Avogadro Way','Remulade','WA','98014'),
	 ('8042','Bookbeat','679 Carson St.','Portland','OR','89076'),
	 ('6380','Eric the Read Books','788 Catamaugus Ave.','Seattle','WA','98056'),
	 ('7896','Fricative Bookshop','89 Madison St.','Fremont','CA','90019');

INSERT INTO parcial22019ej1.sales (stor_id,title_id,ord_num,ord_date,qty,payterms) VALUES
	 ('7067','PS2091','D4482','1994-09-14',10,'Net 60'),
	 ('7131','PS2091','N914008','1994-09-14',20,'Net 30'),
	 ('7131','MC3021','N914014','1994-09-14',25,'Net 30'),
	 ('8042','MC3021','423LL19922','1994-09-14',15,'ON invoice'),
	 ('8042','BU1032','423LL19930','1994-09-14',10,'ON invoice'),
	 ('6380','PS2091','722a','1994-09-13',3,'Net 60'),
	 ('6380','BU1032','6871','1994-09-14',5,'Net 60'),
	 ('8042','BU1111','P723','1993-03-11',25,'Net 30'),
	 ('7896','BU2075','X999','1993-02-21',35,'ON invoice'),
	 ('7896','BU7832','QQ2299','1993-10-28',15,'Net 60'),
	 ('7896','MC2222','TQ456','1993-12-12',10,'Net 60'),
	 ('8042','PC1035','QA879.1','1993-05-22',30,'Net 30'),
	 ('7066','PC8888','A2976','1993-05-24',50,'Net 30'),
	 ('7131','PS1372','P3087a','1993-05-29',20,'Net 60'),
	 ('7131','PS2106','P3087a','1993-05-29',25,'Net 60'),
	 ('7131','PS3333','P3087a','1993-05-29',15,'Net 60'),
	 ('7131','PS7777','P3087a','1993-05-29',25,'Net 60'),
	 ('7067','TC3218','P2121','1992-06-15',40,'Net 30'),
	 ('7067','TC4203','P2121','1992-06-15',20,'Net 30'),
	 ('7067','TC7777','P2121','1992-06-15',20,'Net 30'),
	 ('7896','BU1111','Y1010','1998-12-15',20,'NET 30');
