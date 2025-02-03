
CREATE PROCEDURE spCartToOrder
	@userId INT,
	@addressId INT,
	@generatedUuid VARCHAR(150)

    AS 
    DECLARE
	    @productId INT,
	    @quantity INT,
	    @price DECIMAL(10,2),
	    @tax DECIMAL(10,2),
	    @totalPrice DECIMAL(10,2),
	    @totalTax DECIMAL(10,2)

    DECLARE cursorProduct CURSOR FOR
	    SELECT
			tc.fldProductId,
			tc.fldQuantity,
			 tp.fldPrice,
			 tp.fldTax
	    FROM 
	    	tblCart AS tc
	    INNER JOIN
	    	tblProduct AS tp
	    ON 
	    	tc.fldProductId = tp.fldProduct_ID
	    WHERE 
	    	fldUserId = @userId
	    ORDER BY fldProduct_ID

	SELECT
		 @totalPrice = SUM
		(
			 tc.fldQuantity * tp.fldPrice
		),
		@totalTax = SUM
		(
			 tc.fldQuantity * tp.fldTax
		) 
	FROM 
		tblCart AS tc
	INNER JOIN
		tblProduct AS tp
	ON 
		tc.fldProductId = tp.fldProduct_ID
	WHERE 
		fldUserId = @userId

	INSERT INTO
		tblOrder
		(
			fldOrder_ID,
			fldUserId,
			fldAddressId,
			fldTotalPrice,
			fldTotalTax,
			fldCardPart
		)
	VALUES
		(
			@generatedUuid,
			@userId,
			@addressId,
			@totalPrice,
			@totalTax,
			'3456'
		)


    OPEN cursorProduct

    FETCH NEXT FROM cursorProduct INTO @productId,@quantity,@price,@tax

    WHILE @@FETCH_STATUS = 0
    BEGIN

	    INSERT INTO
		    tblOrderedItems
		    (
			    fldOrderId,
			    fldProductId,
			    fldQuantity,
			    fldUnitPrice,
			    fldUnitTax
		    )
	    VALUES 
		    (
			    @generatedUuid,
			    @productId,
			    @qty,
			    @price,
			    @tax
		    )

        FETCH NEXT FROM cursorProduct INTO @productId,@quantity,@price,@tax
	END

	  CLOSE cursorProduct
	  DEALLOCATE cursorProduct

	DELETE FROM tblCart WHERE fldUserId = @userId

GO