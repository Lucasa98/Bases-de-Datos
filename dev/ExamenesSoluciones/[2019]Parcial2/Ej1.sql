-- ##### Creacion de Tablas #####

-- Create a new database called 'Parcial22019Ej1'
CREATE DATABASE if not EXISTS Parcial22019Ej1;

SET Parcial22019Ej1;

CREATE TABLE IF NOT EXISTS Titles (
    title_id VARCHAR(6) NOT NULL,
    title VARCHAR(255) NOT NULL,
    type char(16) NOT NULL DEFAULT 'No decidido',
    price 
);