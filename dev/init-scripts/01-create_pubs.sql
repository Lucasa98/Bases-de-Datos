-- ################# PUBS #################

CREATE SCHEMA pubs;

-- ##### Creacion de Tablas #####

CREATE TABLE pubs.authors (
   au_id varchar(11) NOT NULL,
   au_lname varchar(40) NOT NULL,
   au_fname varchar(20) NOT NULL,
   phone char(12) NOT NULL DEFAULT 'UNKNOWN',
   address varchar(40),
   city varchar(20),
   state char(2),
   zip char(5),
   contract Smallint
);

ALTER TABLE pubs.authors
ADD CONSTRAINT UPKCL_auidind PRIMARY KEY (au_id);

CREATE TABLE pubs.publishers (
   pub_id char(4) NOT NULL,
   pub_name varchar(40),
   city varchar(20),
   state char(2),
   country varchar(30) DEFAULT 'USA'
);

ALTER TABLE pubs.publishers
ADD CONSTRAINT UPKCL_pubind PRIMARY KEY (pub_id);

-- No tiene tipo double. Use numeric (10,2) instead
CREATE TABLE pubs.titles (
   title_id varchar(6) NOT NULL,
   title varchar(80) NOT NULL,
   type char(12) NOT NULL DEFAULT 'UNDECIDED',
   pub_id char(4),
   price numeric (10, 2),
   advance numeric (10, 2),
   royalty int,
   ytd_sales int,
   notes varchar(200),
   pubdate date NOT NULL DEFAULT CURRENT_DATE
);

ALTER TABLE pubs.titles
ADD CONSTRAINT UPKCL_titleidind PRIMARY KEY (title_id);

ALTER TABLE pubs.titles
ADD CONSTRAINT Publisher_FK FOREIGN KEY (pub_id) REFERENCES pubs.publishers(pub_id);

CREATE TABLE pubs.titleauthor (
   au_id varchar(11) NOT NULL,
   title_id varchar(6) NOT NULL,
   au_ord smallint,
   -- was tinyint
   royaltyper int
);

ALTER TABLE pubs.titleauthor
ADD CONSTRAINT UPKCL_taind PRIMARY KEY (au_id, title_id);

ALTER TABLE pubs.titleauthor
ADD CONSTRAINT Authors_FK FOREIGN KEY (au_id) REFERENCES pubs.authors(au_id);

ALTER TABLE pubs.titleauthor
ADD CONSTRAINT Titles_FK FOREIGN KEY (title_id) REFERENCES pubs.titles(title_id);

CREATE TABLE pubs.stores (
   stor_id char(4) NOT NULL,
   stor_name varchar(40),
   stor_address varchar(40),
   city varchar(20),
   state char(2),
   zip char(5)
);

ALTER TABLE pubs.stores
ADD CONSTRAINT UPK_storeid PRIMARY KEY (stor_id);

CREATE TABLE pubs.sales (
   stor_id char(4) NOT NULL,
   ord_num varchar(20) NOT NULL,
   ord_date date NOT NULL,
   qty smallint NOT NULL,
   payterms varchar(12) NOT NULL,
   title_id varchar(6) NOT NULL
);

ALTER TABLE pubs.sales
ADD CONSTRAINT UPKCL_sales PRIMARY KEY (stor_id, ord_num, title_id);

ALTER TABLE pubs.sales
ADD CONSTRAINT Store_FK FOREIGN KEY (stor_id) REFERENCES pubs.stores(stor_id);

ALTER TABLE pubs.sales
ADD CONSTRAINT Title_FK FOREIGN KEY (title_id) REFERENCES pubs.titles(title_id);

CREATE TABLE pubs.roysched (
   title_id varchar(6) NOT NULL,
   lorange int,
   hirange int,
   royalty int
);

ALTER TABLE pubs.roysched
ADD CONSTRAINT Title2_FK FOREIGN KEY (title_id) REFERENCES pubs.titles(title_id);

CREATE TABLE pubs.discounts (
   discounttype varchar(40) NOT NULL,
   stor_id char(4),
   lowqty smallint,
   highqty smallint,
   discount dec(4, 2) NOT NULL
);

ALTER TABLE pubs.discounts
ADD CONSTRAINT Store2_FK FOREIGN KEY (stor_id) REFERENCES pubs.stores(stor_id);

-- No: GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1)
-- Use SERIAL NOT NULL instead 
--NOTICE:  CREATE TABLE pubs.creará una secuencia implícita «jobs_job_id_seq» para la columna serial «jobs.job_id»
CREATE TABLE pubs.jobs (
   job_id SERIAL NOT NULL,
   job_desc varchar(50) NOT NULL DEFAULT 'New Position - title not formalized yet',
   min_lvl smallint NOT NULL CHECK (min_lvl >= 10),
   max_lvl smallint NOT NULL CHECK (max_lvl <= 250)
);

ALTER TABLE pubs.jobs
ADD CONSTRAINT UPK_jobsid PRIMARY KEY (job_id);

CREATE TABLE pubs.employee (
   emp_id char(9) NOT NULL,
   fname varchar(20) NOT NULL,
   minit char(1),
   lname varchar(30) NOT NULL,
   job_id smallint NOT NULL DEFAULT 1,
   job_lvl smallint DEFAULT 10,
   pub_id char(4) NOT NULL DEFAULT '9952',
   hire_date date NOT NULL DEFAULT CURRENT_DATE
);

ALTER TABLE pubs.employee
ADD CONSTRAINT PK_emp_id PRIMARY KEY (emp_id);

ALTER TABLE pubs.employee
ADD CONSTRAINT Jobs2_FK FOREIGN KEY (job_id) REFERENCES pubs.jobs(job_id);

ALTER TABLE pubs.employee
ADD CONSTRAINT pub_id2_FK FOREIGN KEY (pub_id) REFERENCES pubs.publishers(pub_id);
