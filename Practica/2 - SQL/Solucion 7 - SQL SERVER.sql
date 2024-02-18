---------------------------------------
--EJ 1--
---------------------------------------

/*
CREATE PROC actualizarPrecioEditorial
	(
	@prmPub_id CHAR(4)
	)
	AS
		DECLARE curPrices CURSOR
			FOR
				SELECT price
					FROM titles
					WHERE pub_id = @prmPub_id
					FOR UPDATE;
		DECLARE @price MONEY;

		OPEN curPrices

		FETCH NEXT
			FROM curPrices
			INTO @price

		WHILE @@fetch_status = 0
			BEGIN
				IF @price IS NOT NULL
				BEGIN
					IF @price > 10
					BEGIN
						UPDATE titles
							SET price = price*0.75
							WHERE CURRENT OF curPrices;
					END
					ELSE
					BEGIN
						UPDATE titles
							SET price = price*1.25
							WHERE CURRENT OF curPrices;
					END
				END
				
				FETCH NEXT
					FROM curPrices
					INTO @price
			END

			CLOSE curPrices;
			DEALLOCATE curPrices;
		RETURN;
*/

--EXECUTE actualizarPrecioEditorial '0736';

---------------------------------------
--EJ 2--
---------------------------------------

-- Solo se puede hacer en POSTGRESQL
-- Necesitamos cursores implicitos, cosa que SQL SERVER no tiene

---------------------------------------
--EJ 3--
---------------------------------------