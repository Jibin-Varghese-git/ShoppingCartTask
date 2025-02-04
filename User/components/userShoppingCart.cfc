<cfcomponent>

    <cffunction  name="addUser" description="TO Add User" returnType="struct">
        <cfargument  name="structForm">
        <cfset local.structAddUserReturn["error"] = false>
        <cfif Len(trim(structForm.firstName)) EQ 0>
            <cfset local.structAddUserReturn["error"] = true>
            <cfset local.structAddUserReturn["errorMessage"] = "Enter the username">
        </cfif>
        <cfif Len(trim(structForm.userPhone)) EQ 0>
            <cfset local.structAddUserReturn["error"] = true>
            <cfset local.structAddUserReturn["errorMessage"] = "Enter the phone number">
        </cfif>
        <cfif Len(trim(structForm.userEmail)) EQ 0>
            <cfset local.structAddUserReturn["error"] = true>
            <cfset local.structAddUserReturn["errorMessage"] = "Enter the Email">
        </cfif>
        <cfif Len(trim(structForm.password)) EQ 0>
            <cfset local.structAddUserReturn["error"] = true>
            <cfset local.structAddUserReturn["errorMessage"] = "Enter the password">
        </cfif>

        <cfif NOT local.structAddUserReturn["error"]>
            <cfset local.saltString = generateSecretKey(("AES"),128)>
            <cfset local.password = arguments.structForm.password & local.saltString>
            <cfset local.hashedPassword = hash(local.password,"SHA-256", "UTF-8")>
            <cfquery name="local.qryCheckUser">
                SELECT
                    fldEmail
                FROM
                    tblUser
                WHERE
                    (
                        fldPhone = <cfqueryparam value="#arguments.structForm.userPhone#" cfsqltype="varchar">
                    OR
                        fldEmail = <cfqueryparam value="#arguments.structForm.userEmail#" cfsqltype="varchar">
                    )
                AND
                    fldRoleId = <cfqueryparam value='1' cfsqltype="varchar">
                AND
                    fldActive = 1
            </cfquery>
            <cfif queryRecordCount(local.qryCheckUser)>
                <cfset local.structAddUserReturn["error"] = true>
                <cfset local.structAddUserReturn["errorMessage"] = "User Already Exists">
            <cfelse>
                <cfquery result="local.userSignup">
                    INSERT INTO
                        tblUser
                        (
                            fldFirstName,
                            fldLastName,
                            fldPhone,
                            fldEmail,
                            fldUserSaltString,
                            fldHashedPassword,
                            fldRoleId
                        )
                    VALUES
                        (
                            <cfqueryparam value="#arguments.structForm.firstName#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.structForm.lastName#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.structForm.userPhone#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.structForm.userEmail#" cfsqltype="varchar">,
                            <cfqueryparam value="#local.saltString#" cfsqltype="varchar">,
                            <cfqueryparam value="#local.hashedPassword#" cfsqltype="varchar">,
                            <cfqueryparam value='1' cfsqltype="varchar">
                        )
                </cfquery>
                <cfset local.structUserLoginReturn["error"] = false>
                    <cfset session.structUserDetails["userId"] = local.userSignup.generatedkey>
                    <cfset session.structUserDetails["firstName"] = arguments.structForm.firstName>
                    <cfset session.structUserDetails["lastName"] = arguments.structForm.lastName>
                    <cfset session.structUserDetails["phone"] = arguments.structForm.userPhone>
                    <cfset session.structUserDetails["email"] = arguments.structForm.userEmail>
                    <cfset session.structUserDetails["roleId"] = 1>
                <cfset local.structAddUserReturn["error"] = false>
            </cfif>
        </cfif>
            <cfreturn local.structAddUserReturn>   
    </cffunction>

    <cffunction  name="userLogin" description="Function for user login" returntype="struct">
        <cfargument  name="structForm">
        <cfset local.structUserLoginReturn["error"] = false>
        <cfif Len(trim(arguments.structForm.userNameLogin)) EQ 0>
            <cfset local.structUserLoginReturn["error"] = true>
            <cfset local.structUserLoginReturn["errorMessage"] = "Enter the username">
        </cfif>
        <cfif Len(trim(arguments.structForm.passwordLogin)) EQ 0>
            <cfset local.structUserLoginReturn["error"] = true>
            <cfset local.structUserLoginReturn["errorMessage"] = "Enter the password">
        </cfif>
        <cfif NOT local.structUserLoginReturn["error"]>
            <cfquery name="local.qrySelectUser">
                SELECT
                    fldUser_ID,
                    fldUserSaltString,
                    fldHashedPassword,
                    fldFirstName,
                    fldLastName,
                    fldPhone,
                    fldEmail,
                    fldRoleId
                FROM
                    tblUser
                WHERE
                    (fldEmail = <cfqueryparam value="#arguments.structForm.userNameLogin#" cfsqltype="varchar">
                OR
                    fldPhone = <cfqueryparam value="#arguments.structForm.userNameLogin#" cfsqltype="varchar">)
                AND
                    fldRoleId = <cfqueryparam value=1 cfsqltype="integer">
                AND
                    fldActive = 1
            </cfquery>
            <cfif queryRecordCount(local.qrySelectUser)>
                <cfset local.password = arguments.structForm.passwordLogin & local.qrySelectUser.fldUserSaltString>
                <cfset local.hashedPassword = hash(local.password,"SHA-256", "UTF-8")>
                <cfif local.hashedPassword EQ local.qrySelectUser.fldHashedPassword> 
                    <cfset local.structUserLoginReturn["error"] = false>
                    <cfset session.structUserDetails["userId"] = local.qrySelectUser.flduser_ID>
                    <cfset session.structUserDetails["firstName"] = local.qrySelectUser.fldFirstName>
                    <cfset session.structUserDetails["lastName"] = local.qrySelectUser.fldLastName>
                    <cfset session.structUserDetails["phone"] = local.qrySelectUser.fldPhone>
                    <cfset session.structUserDetails["email"] = local.qrySelectUser.fldEmail>
                    <cfset session.structUserDetails["roleId"] = local.qrySelectUser.fldRoleId>
                <cfelse>
                    <cfset local.structUserLoginReturn["error"] = true>
                    <cfset local.structUserLoginReturn["errorMessage"] = "Invalid Password">
                </cfif>
            <cfelse>
                <cfset local.structUserLoginReturn["error"] = true>
                <cfset local.structUserLoginReturn["errorMessage"] = "Invalid Username">
            </cfif>
        </cfif>
        <cfreturn local.structUserLoginReturn>
    </cffunction>

      <cffunction  name="selectCategory" description="Function for category listing" returntype="struct">
        <cfquery name="local.qrySelectCategory">
            SELECT
                fldCategory_ID,
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldActive = 1
        </cfquery>
        <cfloop query="local.qrySelectCategory">
            <cfset local.structCategoryListing[local.qrySelectCategory.fldCategory_ID] = local.qrySelectCategory.fldCategoryName>
        </cfloop>
        <cfreturn local.structCategoryListing>
    </cffunction>

    <cffunction  name="selectRandomProducts" description="Function to select random products" returntype="query">
        <cfquery name="local.qryRandomProducts">
        	SELECT
            TOP 10
                tp.fldProduct_ID,
                tp.fldProductName,
                tp.fldDescription,
                tp.fldPrice,
                tp.fldTax,
                tb.fldBrandName,
				tpi.fldImageFileName
            FROM
				tblBrands as tb
			INNER JOIN
                tblProduct as tp
			ON
				tb.fldBrand_ID=tp.fldBrandId
			LEFT JOIN
				tblProductImages as tpi
			ON
				tp.fldProduct_ID=tpi.fldProductId
            LEFT JOIN
                tblSubCategory AS tsc
            ON
                tsc.fldSubCategory_ID = tp.fldSubCategoryId
            LEFT JOIN
                tblCategory AS tc
            ON
                tc.fldCategory_ID = tsc.fldCategoryId
            WHERE
                tp.fldActive = 1
			AND
                tsc.fldActive = 1 
            AND
                tc.fldActive = 1 
            AND
				tpi.fldDefaultImage = 1
            ORDER BY
                NEWID()
        </cfquery>
        <cfreturn local.qryRandomProducts>
    </cffunction>

    <cffunction  name="selectDistinctSubCategory" access="remote" returnformat="JSON" description="Function to select subcategories with products">
        <cfargument  name="categoryId">
        <cfquery name="local.qryDistinctSelectSubCategory">
            SELECT
                DISTINCT(ts.fldSubCategory_ID),
                ts.fldSubCategoryName
            FROM
                tblSubCategory AS ts
            INNER JOIN
                tblproduct AS tp 
            ON
                ts.fldsubcategory_ID = tp.fldsubcategoryId 
                AND
                    tp.fldActive = 1
            WHERE
                ts.fldActive = 1
                <cfif structKeyExists(arguments, "categoryId")>
                AND
                    ts.fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                </cfif>
        </cfquery>
        <cfreturn local.qryDistinctSelectSubCategory>
    </cffunction>

    <cffunction  name="selectSubcategory" returntype="query" description="Function to select subcategory">
        <cfquery name="local.qrySelectSubcategory">
            SELECT
                fldSubCategory_ID,
                fldSubCategoryName,
                fldCategoryId
            FROM
                tblSubCategory
            WHERE
                fldActive = 1
        </cfquery>
        <cfreturn local.qrySelectSubcategory>
    </cffunction>



    <cffunction  name="logoutUser" access="remote" dsecription="Function for user logout">
        <cfset structClear(session)>
        <cflocation  url="../userHome.cfm" addToken="no">
    </cffunction>


    <cffunction  name="selectAllProducts" description="Function to select all products" returntype="query">
        <cfargument  name="productId">
        <cfquery name="local.qrySelectAllProducts">
        	SELECT 
                tp.fldProduct_ID AS productId,
                tp.fldProductName AS productName,
                tp.fldDescription AS productDesc,
                tp.fldPrice AS price,
                tp.fldTax AS tax,
                tp.fldSubCategoryId AS subcategoryId,
                tb.fldBrandName AS brandName,
				tpi.fldImageFileName AS imageName,
                tsc.fldSubCategoryName AS subcategoryName,
                tsc.fldCategoryId As categoryId,
                tc.fldCategoryName AS categoryName
            FROM
				tblBrands as tb
			INNER JOIN
                tblProduct as tp
			ON
				tb.fldBrand_ID=tp.fldBrandId
			INNER JOIN 
                tblSubCategory as tsc
            ON
                tsc.fldSubCategory_ID=tp.fldSubCategoryId
            INNER JOIN
                tblCategory as tc
            ON
                tc.fldCategory_ID=tsc.fldCategoryId
            INNER JOIN
				tblProductImages as tpi
			ON
				tp.fldProduct_ID=tpi.fldProductId
            WHERE
                tp.fldActive = 1
			AND
				tpi.fldDefaultImage = 1
            AND
                tsc.fldActive = 1
            AND
                tc.fldActive = 1
            <cfif structKeyExists(arguments, "productId")>
                AND
                    tp.fldProduct_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
            </cfif>
              ORDER BY
                NEWID()
        </cfquery>
        <cfreturn local.qrySelectAllProducts>
    </cffunction>

    <cffunction  name="selectSubcategoryProducts" description="Select products according to subcategory" returntype="query">
        <cfargument  name="subcategoryId">
        <cfargument  name="sort">
        <cfargument  name="search">
        <cfquery name="local.qryselectSubcategoryProducts">
            SELECT
                tp.fldProduct_Id AS productId,
                tp.fldProductName AS productName,
                tp.fldDescription AS productDescription,
                tp.fldPrice AS productPrice,
                tp.fldTax AS productTax,
                tp.fldSubCategoryId AS subcategoryId,
                tb.fldBrandName brandName,
				tpi.fldImageFileName AS productImage,
                ts.fldSubCategoryName AS subcategoryName
            FROM
				tblBrands as tb
			INNER JOIN
                tblProduct as tp
			ON
				tb.fldBrand_ID=tp.fldBrandId
            INNER JOIN
                tblSubCategory as ts
			ON
                tp.fldSubCategoryId= ts.fldSubCategory_ID
            INNER JOIN
                tblCategory as tc
            ON
                tc.fldCategory_ID=ts.fldCategoryId
			INNER JOIN 
				tblProductImages as tpi
			ON
				tp.fldProduct_ID=tpi.fldProductId
            WHERE 
                tp.fldActive = 1
			AND
                tc.fldActive = 1
            AND
                ts.fldActive = 1
            AND
				tpi.fldDefaultImage = 1
            <cfif structKeyExists(arguments, "subcategoryId")>
                AND
                    tp.fldSubCategoryId = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="integer">
            </cfif>
            <cfif structKeyExists(arguments, "search")>
                AND
                (
			        	tp.fldProductName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
			        OR
			        	tp.fldDescription LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
			        OR
			        	tb.fldBrandName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
                )
            </cfif>
             <cfif structKeyExists(arguments, "sort")>
                ORDER BY tp.fldPrice #arguments.sort#
            </cfif>
        </cfquery>
        <cfreturn local.qryselectSubcategoryProducts>
    </cffunction>

    <cffunction  name="filterProducts" description="Function to filter producs" access="remote" returnformat="JSON">
        <cfargument  name="subcategoryId">
        <cfargument  name="minValue">
        <cfargument  name="maxValue">
        <cfargument  name="search">
        <cfquery name="local.qryFilterProducts">
            SELECT
                tp.fldProduct_Id AS productId,
                tp.fldProductName AS productName,
                tp.fldDescription AS productDescription,
                tp.fldPrice AS productPrice,
                tp.fldTax AS productTax,
                tp.fldSubCategoryId AS subcategoryId,
                tb.fldBrandName brandName,
				tpi.fldImageFileName AS productImage,
                ts.fldSubCategoryName AS subcategoryName
            FROM
				tblBrands as tb
			INNER JOIN
                tblProduct as tp
			ON
				tb.fldBrand_ID=tp.fldBrandId
            INNER JOIN
                tblSubCategory as ts
			ON
                tp.fldSubCategoryId= ts.fldSubCategory_ID
            INNER JOIN
                tblCategory as tc
            ON
                tc.fldCategory_ID=ts.fldCategoryId
			INNER JOIN 
				tblProductImages as tpi
			ON
				tp.fldProduct_ID=tpi.fldProductId
            WHERE 
                tp.fldActive = 1
			AND
                tc.fldActive = 1
            AND
                ts.fldActive = 1
            AND
				tpi.fldDefaultImage = 1
            <cfif structKeyExists(arguments, "subcategoryId")>
                AND
                tp.fldSubCategoryId = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="integer">
             </cfif>
            <cfif structKeyExists(arguments, "minValue")>
                AND
                tp.fldPrice >= <cfqueryparam value="#arguments.minValue#" cfsqltype="decimal">
            </cfif>
            <cfif structKeyExists(arguments, "maxValue")>
                AND
                tp.fldPrice <= <cfqueryparam value="#arguments.maxValue#" cfsqltype="decimal">
            </cfif>
            <cfif structKeyExists(arguments, "search")>
                AND
                (
			        	tp.fldProductName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
			        OR
			        	tp.fldDescription LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
			        OR
			        	tb.fldBrandName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
                )
            </cfif>
        </cfquery>
        <cfset local.arrayFilterProducts = arrayNew(1)>
        <cfloop query="local.qryFilterProducts">
            <cfset arrayAppend(local.arrayFilterProducts, {
                productId=local.qryFilterProducts.productId,
                productName=local.qryFilterProducts.productName,
                productPrice=local.qryFilterProducts.productPrice,
                subcategoryId=local.qryFilterProducts.subcategoryId,
                brandName=local.qryFilterProducts.brandName,
                productImage=local.qryFilterProducts.productImage,
                subcategoryName=local.qryFilterProducts.subcategoryName
            })>
        </cfloop>
        <cfreturn local.arrayFilterProducts>
    </cffunction>

    <cffunction  name="selectProductImages" description="Function to select images of product" returntype="query">
        <cfargument  name="productId">
        <cfquery name="local.qrySelectProductImages">
            SELECT
                fldProductImage_ID AS imageId,
                fldImageFileName AS productImage,
                fldDefaultImage AS defaultImage
            FROM
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
            AND
                fldACtive = 1
        </cfquery>
        <cfreturn local.qrySelectProductImages>
    </cffunction>

    <cffunction  name="addProductCart" description="Function to add and update product in cart" returntype="boolean">
        <cfargument  name="productId">
        <cfquery name="local.qryCheckCart">
                SELECT
                    fldCart_ID,
                    fldUserId,
                    fldProductId,
                    fldQuantity
                FROM
                    tblCart
                WHERE
                    fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                AND
                    fldUserId = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
        </cfquery>
        
        <cfif queryRecordCount(local.qryCheckCart) LT 1>
            <cfquery>
                INSERT INTO
                    tblCart
                    (
                        fldUserId,
                        fldProductId,
                        fldQuantity
                    )
                VALUES
                    (
                        <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.productId#" cfsqltype="integer">,
                        <cfqueryparam value='1' cfsqltype="integer">
                    )

            </cfquery>
        <cfelse>
            <cfset local.productQuantity = local.qryCheckCart.fldQuantity + 1>
            <cfquery>
                UPDATE
                    tblCart
                SET
                    fldQuantity = <cfqueryparam value="#local.productQuantity#" cfsqltype="integer">
                FROM
                    tblCart
                WHERE
                    fldCart_ID = <cfqueryparam value="#local.qryCheckCart.fldCart_ID#" cfsqltype="integer">
            </cfquery>
        </cfif>
        <cfreturn true>
    </cffunction>

    <cffunction  name="selectProductCart" description="Select cart products to list in cart" returntype="query">
        <cfquery name="local.qrySelectProductCart">
                SELECT 
                	tc.fldCart_ID AS cartId,
                	tc.fldProductId AS productId,
                	tc.fldQuantity AS productQuantity,
                	tp.fldProductName AS productName,
                    tp.fldDescription AS productDesc,
                	tp.fldPrice AS price,
                    tp.fldTax AS tax,
                	tb.fldBrandName AS brandName,
                	tpi.fldImageFileName AS imageName
                FROM
                	tblCart AS tc
                INNER JOIN 
                	tblProduct AS tp
                ON
                	tc.fldProductId = tp.fldProduct_ID
                INNER JOIN 
                	tblBrands AS tb
                ON
                	tb.fldBrand_ID = tp.fldBrandId
                INNER JOIN 
                	tblProductImages AS tpi
                ON
                	tpi.fldProductId = tp.fldProduct_ID
                WHERE
                	tp.fldActive = 1
                AND
                	tpi.fldDefaultImage = 1
                AND 
                	tc.fldUserId = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
        </cfquery>
        <cfreturn local.qrySelectProductCart>
    </cffunction>

    <cffunction  name="removeCartProduct" access="remote" description="Function to remove product from cart">
        <cfargument  name="cartId">
            <cfquery>
                DELETE
                FROM
                    tblCart
                WHERE
                    fldCart_ID = <cfqueryparam value="#arguments.cartId#" cfsqltype="integer">
            </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="cartUpdate" access="remote" description="Function to update cart">
        <cfargument  name="cartId">
        <cfargument  name="quantity">
        <cfquery>
            UPDATE
                tblCart
            SET
                fldQuantity = <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
            WHERE
                fldCart_ID = <cfqueryparam value="#arguments.cartId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="addAddress" description="Function to add Address">
        <cfargument  name="formAddress">
        <cfset local.structResult["error"] = false>
        <cfset local.structResult["errorMessage"] = "No Error">
        <cfif len(arguments.formAddress.FIRSTNAME.trim()) EQ 0>
            <cfset local.structResult["error"] = true>
            <cfset local.structResult["errorMessage"] = "Enter the Firstname">
        </cfif>

        <cfif len(arguments.formAddress.ADDRESSLINE1.trim()) EQ 0>
            <cfset local.structResult["error"] = true>
            <cfset local.structResult["errorMessage"] = "Enter the Address">
        </cfif>

        <cfif len(arguments.formAddress.CITY.trim()) EQ 0>
            <cfset local.structResult["error"] = true>
            <cfset local.structResult["errorMessage"] = "Enter the city">
        </cfif>

        <cfif len(arguments.formAddress.STATE.trim()) EQ 0>
            <cfset local.structResult["error"] = true>
            <cfset local.structResult["errorMessage"] = "Enter the state">
        </cfif>

        <cfif len(arguments.formAddress.PINCODE.trim()) EQ 0>
            <cfset local.structResult["error"] = true>
            <cfset local.structResult["errorMessage"] = "Enter the pincode">
        </cfif>

        <cfif len(arguments.formAddress.PHONENUMBER.trim()) EQ 0>
            <cfset local.structResult["error"] = true>
            <cfset local.structResult["errorMessage"] = "Enter the phone number">
        </cfif>

        <cfif local.structResult["error"] EQ false> 
            <cfquery name="local.qryAddAddress">
                INSERT INTO
                    tblAddress
                    (
                        fldUserId,
                        fldFirstName,
                        fldLastName,
                        fldAddressLine1,
                        fldAddressLine2,
                        fldCity,
                        fldState,
                        fldPincode,
                        fldPhoneNumber,
                        fldActive
                    )
                VALUES
                    (
                        <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.formAddress.FIRSTNAME.trim()#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.formAddress.LASTNAME.trim()#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.formAddress.ADDRESSLINE1.trim()#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.formAddress.ADDRESSLINE2.trim()#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.formAddress.CITY.trim()#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.formAddress.STATE.trim()#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.formAddress.PINCODE.trim()#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.formAddress.PHONENUMBER.trim()#" cfsqltype="varchar">,
                        <cfqueryparam value='1' cfsqltype="integer">
                    )
            </cfquery>
        </cfif>
        <cfreturn local.structResult>
    </cffunction>

    <cffunction  name="selectAddress" description="Function to address">
        <cfquery name="local.qrySelectAddress">
            SELECT
                fldAddress_ID AS addressId,
                fldFirstName AS firstName,
                fldLastName AS lastName,
                fldAddressLine1 AS addressline1,
                fldAddressLine2 AS addressline2,
                fldCity AS city,
                fldState AS state,
                fldPincode AS pincode,
                fldPhoneNumber AS phoneNumber
            FROM
                tblAddress
            WHERE
                fldUserId = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
            AND
                fldActive = 1
            ORDER BY 
                fldCreatedDate DESC
        </cfquery>
        <cfreturn local.qrySelectAddress>
    </cffunction>

    <cffunction  name="removeAddress" description="Function to remove user address" access="remote">
        <cfargument  name="addressId">
        <cfquery>
            UPDATE
                tblAddress
            SET
                fldActive = 0
            WHERE
                fldAddress_ID = <cfqueryparam value="#arguments.addressId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="editUserProfile" description="Function to edit user" returnFormat="JSON" access="remote">
        <cfargument  name="userId">
        <cfargument  name="userFirstName">
        <cfargument  name="userLastName">
        <cfargument  name="userEmail">
        <cfargument  name="userPhoneNumber">

        <cfset local.structAddUserReturn["error"] = false>
        <cfif Len(trim(arguments.userFirstName)) EQ 0>
            <cfset local.structAddUserReturn["error"] = true>
            <cfset local.structAddUserReturn["errorMessage"] = "Enter the username">
        </cfif>
        <cfif Len(trim(arguments.userPhoneNumber)) EQ 0>
            <cfset local.structAddUserReturn["error"] = true>
            <cfset local.structAddUserReturn["errorMessage"] = "Enter the phone number">
        </cfif>
        <cfif Len(trim(arguments.userEmail)) EQ 0>
            <cfset local.structAddUserReturn["error"] = true>
            <cfset local.structAddUserReturn["errorMessage"] = "Enter the Email">
        </cfif>

        <cfif NOT local.structAddUserReturn["error"]>

            <cfquery name="local.qryCheckUser">
                SELECT
                    fldEmail
                FROM
                    tblUser
                WHERE
                    (
                        fldPhone = <cfqueryparam value="#arguments.userPhoneNumber#" cfsqltype="varchar">
                    OR
                        fldEmail = <cfqueryparam value="#arguments.userEmail#" cfsqltype="varchar">
                    )
                AND
                    fldRoleId = <cfqueryparam value='1' cfsqltype="varchar">
                AND
                    fldActive = 1
                AND
                    fldUser_ID != <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
                LIMIT 1
            </cfquery>
            <cfif queryRecordCount(local.qryCheckUser)>
                <cfset local.structAddUserReturn["error"] = true>
                <cfset local.structAddUserReturn["errorMessage"] = "User Already Exists">
            <cfelse>
                <cfset local.today = now()>
                <cfquery>
                    UPDATE
                        tblUser
                    SET
                        fldFirstName = <cfqueryparam value="#arguments.userFirstName#" cfsqltype="varchar">,
                        fldLastName = <cfqueryparam value="#arguments.userLastName#" cfsqltype="varchar">,
                        fldPhone = <cfqueryparam value="#arguments.userPhoneNumber#" cfsqltype="varchar">,
                        fldEmail = <cfqueryparam value="#arguments.userEmail#" cfsqltype="varchar">,
                        fldUpdatedDate = <cfqueryparam value="#local.today#" cfsqltype="date">,
                        fldUpdatedBy = <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
                    WHERE
                        fldRoleId = <cfqueryparam value='1' cfsqltype="varchar">
                    AND
                        fldActive = 1
                    AND
                        fldUser_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
                </cfquery>
                <cfset session.structUserDetails["userId"] = arguments.userId>
                <cfset session.structUserDetails["firstName"] = arguments.userFirstName>
                <cfset session.structUserDetails["lastName"] = arguments.userLastName>
                <cfset session.structUserDetails["phone"] = arguments.userPhoneNumber>
                <cfset session.structUserDetails["email"] = arguments.userEmail>
                <cfset session.structUserDetails["roleId"] = 1>
            </cfif>
        </cfif>
            <cfreturn local.structAddUserReturn>
    </cffunction>

    <cffunction  name="checkCardDetails" access="remote" description="Function to check card details" returnFormat="JSON">
        <cfargument  name="cardNumber">
        <cfargument  name="cardMonth">
        <cfargument  name="cardYear">
        <cfargument  name="cardCvv">
        <cfargument  name="cardName">
        <cfset local.checkCardReturn["error"] = false>

        <cfif NOT arguments.cardNumber EQ "1234567890123456">
            <cfset local.checkCardReturn["error"] = true>
            <cfset local.checkCardReturn["message"] = "Card Number Incorrect">
        </cfif>
        <cfif NOT arguments.cardMonth EQ "12">
            <cfset local.checkCardReturn["error"] = true>
            <cfset local.checkCardReturn["message"] = "Month Incorrect">
        </cfif>

        <cfif NOT arguments.cardYear EQ "28">
            <cfset local.checkCardReturn["error"] = true>
            <cfset local.checkCardReturn["message"] = "Year Incorrect">
        </cfif>

        <cfif NOT arguments.cardCvv EQ "123">
            <cfset local.checkCardReturn["error"] = true>
            <cfset local.checkCardReturn["message"] = "CVV Incorrect">
        </cfif>

        <cfif NOT arguments.cardName EQ "User User">
            <cfset local.checkCardReturn["error"] = true>
            <cfset local.checkCardReturn["message"] = "Card Name Incorrect">
        </cfif>
        <cfreturn local.checkCardReturn>
    </cffunction>

    <cffunction  name="addOrderItems" description="Function to add order items">
        <cfargument  name="formOrderItems">
        <cfset local.generatedUuid = createUUID()>
        <cfquery name="local.qryOrder">
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
                    <cfqueryparam value="#local.generatedUuid#" cfsqltype="varchar">,
                    <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.formOrderItems.selectedAddressId#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.formOrderItems.TOTALPRICEHIDDEN#" cfsqltype="decimal">,
                    <cfqueryparam value="#arguments.formOrderItems.TOTALTAXHIDDEN#" cfsqltype="decimal">,
                    <cfqueryparam value="3456" cfsqltype="varchar">
                )
        </cfquery>
        <cfset local.productList = selectAllProducts(arguments.formOrderItems.productIdHidden)>
        <cfquery name="local.qryOrderedItems">
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
                    <cfqueryparam value="#local.generatedUuid#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.formOrderItems.productIdHidden#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.formOrderItems.orderQuantity#" cfsqltype="integer">,
                    <cfqueryparam value="#local.productList.price#" cfsqltype="decimal">,
                    <cfqueryparam value="#local.productList.tax#" cfsqltype="decimal">
                )
        </cfquery>
        <cfset sentEmailUser(local.generatedUuid)>
        <cflocation  url="userOrderHistory.cfm" addToken="no">
    </cffunction>

    <cffunction  name="cartToOrder">
        <cfargument  name="formOrderItems">
        <cfset local.generatedUuid = createUUID()>
        <cfquery>
            EXEC
                spCartToOrder 
                @userId = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">,
                @addressId = <cfqueryparam value="#arguments.formOrderItems.selectedAddressId#" cfsqltype="integer">,
                @generatedUuid = <cfqueryparam value="#local.generatedUuid#" cfsqltype="varchar">
        </cfquery>
        <cfset sentEmailUser(local.generatedUuid)>
        <cflocation  url="userOrderHistory.cfm" addToken="no">
    </cffunction>

    <cffunction  name="sentEmailUser">
        <cfargument  name="orderId">
<!---             <cfdump  var="#arguments#"  abort> --->
        <cfmail to = "#session.structUserDetails['email']#" from = "jibinvarghese05101999@gmail.com" subject = "Thank you for your order"> 
            Your order has been confirmed.
            You can check your order using the orderId : #arguments.orderId#
        </cfmail> 
    </cffunction>

    <cffunction  name="selectOrderTable">
        <cfquery name="local.qrySelectOrderTable">
            SELECT
                tblo.fldOrder_ID AS orderId,
	            tblo.fldTotalPrice AS totalPrice,
	            tblo.fldTotalTax AS totalTax,
	            tblo.fldOrderDate AS orderDate,
                ta.fldFirstName AS firstName,
	            ta.fldLastName AS LastName,
	            ta.fldAddressLine1 AS addressline1,
	            ta.fldAddressLine2 AS addressLine2,
	            ta.fldCity AS city,
	            ta.fldState AS state,
	            ta.fldPincode AS pincode
            FROM
                tblOrder AS tblo
            INNER JOIN
	            tblAddress AS ta
            ON
	            tblo.fldAddressId = ta.fldAddress_ID
        </cfquery>
        <cfreturn local.qrySelectOrderTable>
    </cffunction>

    <cffunction  name="selectOrderedItemsTable">
        <cfquery name="local.qrySelectOrderedItemsTable">
            SELECT
            	toi.fldOrderItem_ID AS orderItemId,
            	toi.fldOrderId AS orderId,
            	toi.fldProductId AS productId,
            	toi.fldQuantity AS quantity,
            	toi.fldUnitPrice AS unitPrice,
            	toi.fldUnitTax AS unitTax,
            	tp.fldProductName AS productName,
            	tp.fldDescription AS description,
            	tpi.fldImageFileName AS imageName,
                ta.fldFirstName AS firstName,
            	ta.fldLastName AS LastName,
            	ta.fldAddressLine1 AS addressline1,
            	ta.fldAddressLine2 AS addressLine2,
            	ta.fldCity AS city,
            	ta.fldState AS state,
            	ta.fldPincode AS pincode
            FROM
            	tblOrderedItems AS toi
            INNER JOIN	
            	tblOrder AS tblO
            ON
            	tblO.fldOrder_ID = toi.fldOrderId
            INNER JOIN
            	tblProduct AS tp
            ON
            	tp.fldProduct_ID = toi.fldProductId
            INNER JOIN
            	tblProductImages AS tpi
            ON
            	tp.fldProduct_ID = tpi.fldProductId
            INNER JOIN
	            tblAddress AS ta
            ON
            	tblO.fldAddressId = ta.fldAddress_ID 
            WHERE
            	tpi.fldActive = 1
            AND
            	tpi.fldDefaultImage = 1
            AND 
            	tp.fldActive =1
        </cfquery>
        <cfreturn local.qrySelectOrderedItemsTable>
    </cffunction>

    <cffunction  name="dumpFunction">
        <cfreturn true>
    </cffunction>

</cfcomponent>