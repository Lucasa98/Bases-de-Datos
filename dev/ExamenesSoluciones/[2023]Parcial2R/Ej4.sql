-- ////////////////////////////////////////////////
-- Ejercicio 4
/*
    Que variables especiales proporcionan todos los triggers PL/pgSQL (ademas de los records
    NEW y OLD, que pueden existir o no en dependencia del triggering event), y que solamente
    existen en el ambito de su trigger function?
*/

/*
    Todos los trigger proporcionan las siguientes variables:
     - TG_NAME: nombre del trigger que disparo la trigger function
     - TG_OP: operacion que disparo el trigger
     - TG_TABLE_NAME: nombre de la tabla que disparo el trigger
     - TG_WHEN: el tipo de trigger (BEFORE, AFTER, INSTEAD OF)
     - TG_LEVEL: granularidad del trigger
*/