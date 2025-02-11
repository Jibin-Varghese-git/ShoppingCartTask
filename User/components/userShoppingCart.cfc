<cfcomponent>

    <cffunction  name="addUser" description="TO Add User" returnType="struct">
        <cfargument  name="structForm" required="true">
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
                    fldRoleId = 1
                AND
                    fldActive = 1
            </cfquery>
            <cfif queryRecordCount(local.qryCheckUser)>
                <cfset local.structAddUserReturn["error"] = true>
                <cfset local.structAddUserReturn["errorMessage"] = "User Already Exists">
            <cfelse>
                <cftry>
                    <cfquery result="local.userSignup">
                        INSERT INTO
                            tblUser(
                                fldFirstName,
                                fldLastName,
                                fldPhone,
                                fldEmail,
                                fldUserSaltString,
                                fldHashedPassword,
                                fldRoleId
                            )VALUES(
                                <cfqueryparam value="#arguments.structForm.firstName#" cfsqltype="varchar">,
                                <cfqueryparam value="#arguments.structForm.lastName#" cfsqltype="varchar">,
                                <cfqueryparam value="#arguments.structForm.userPhone#" cfsqltype="varchar">,
                                <cfqueryparam value="#arguments.structForm.userEmail#" cfsqltype="varchar">,
                                <cfqueryparam value="#local.saltString#" cfsqltype="varchar">,
                                <cfqueryparam value="#local.hashedPassword#" cfsqltype="varchar">,
                                1
                            )
                    </cfquery>
                    <cfcatch>
                        <cfset errorMail(cfcatch.type,cfcatch.message)>
                    </cfcatch>
                </cftry>
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
        <cfargument  name="structForm" required="true">
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
                    fldRoleId = 1
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
                TOP 8
                fldCategory_ID,
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldActive = 1
            ORDER BY
                NEWID()
        </cfquery>
        <cfloop query="local.qrySelectCategory">
            <cfset local.structCategoryListing[local.qrySelectCategory.fldCategory_ID] = local.qrySelectCategory.fldCategoryName>
        </cfloop>
        <cfreturn local.structCategoryListing>
    </cffunction>

    <cffunction  name="selectRandomProducts" description="Function to select random products" returntype="query">
        <cftry>
            <cfquery name="local.qryRandomProducts">
                SELECT
                TOP 10
                    TP.fldProduct_ID,
                    TP.fldProductName,
                    TP.fldDescription,
                    TP.fldPrice,
                    TP.fldTax,
                    TB.fldBrandName,
                    TPI.fldImageFileName
                FROM
                    tblBrands as TB
                INNER JOIN tblProduct as TP ON TB.fldBrand_ID=TP.fldBrandId
                LEFT JOIN tblProductImages as TPI ON TP.fldProduct_ID=TPI.fldProductId
                LEFT JOIN tblSubCategory AS TSC ON TSC.fldSubCategory_ID = TP.fldSubCategoryId
                LEFT JOIN tblCategory AS TC ON TC.fldCategory_ID = TSC.fldCategoryId
                WHERE
                    TP.fldActive = 1
                AND
                    TSC.fldActive = 1 
                AND
                    TC.fldActive = 1 
                AND
                    TPI.fldDefaultImage = 1
                ORDER BY
                    NEWID()
            </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
        </cftry>
        <cfreturn local.qryRandomProducts>
    </cffunction>

    <cffunction  name="selectDistinctSubCategory" access="remote" returnformat="JSON" description="Function to select subcategories with products">
        <cfargument  name="categoryId" required="false">
        <cfquery name="local.qryDistinctSelectSubCategory">
            SELECT
                DISTINCT(TS.fldSubCategory_ID),
                TS.fldSubCategoryName
            FROM
                tblSubCategory AS TS
            INNER JOIN tblproduct AS tp ON TS.fldsubcategory_ID = TP.fldsubcategoryId 
                AND
                    TP.fldActive = 1
            WHERE
                TS.fldActive = 1
                <cfif structKeyExists(arguments, "categoryId")>
                AND
                    TS.fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
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



    <cffunction  name="logoutUser" access="remote" dsecription="Function for user logout" returnFormat="plain">
        <cfset structClear(session)>
        <cfset local.result["success"] = true>
        <cfreturn local.result>
    </cffunction>


    <cffunction  name="selectAllProducts" description="Function to select all products" returntype="query">
        <cfargument  name="productId" required="false">
        <cftry>
            <cfquery name="local.qrySelectAllProducts">
                SELECT 
                    TP.fldProduct_ID AS productId,
                    TP.fldProductName AS productName,
                    TP.fldDescription AS productDesc,
                    TP.fldPrice AS price,
                    TP.fldTax AS tax,
                    TP.fldSubCategoryId AS subcategoryId,
                    TB.fldBrandName AS brandName,
                    TPI.fldImageFileName AS imageName,
                    TSC.fldSubCategoryName AS subcategoryName,
                    TSC.fldCategoryId As categoryId,
                    TC.fldCategoryName AS categoryName
                FROM
                    tblBrands as TB
                INNER JOIN tblProduct as TP ON TB.fldBrand_ID=TP.fldBrandId
                INNER JOIN tblSubCategory as TSC ON TSC.fldSubCategory_ID=TP.fldSubCategoryId
                INNER JOIN tblCategory as TC ON TC.fldCategory_ID=TSC.fldCategoryId
                INNER JOIN tblProductImages as TPI ON TP.fldProduct_ID=TPI.fldProductId
                WHERE
                    TP.fldActive = 1
                AND
                    TPI.fldDefaultImage = 1
                AND
                    TSC.fldActive = 1
                AND
                    TC.fldActive = 1
                <cfif structKeyExists(arguments, "productId")>
                    AND
                        TP.fldProduct_ID = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                </cfif>
                ORDER BY
                    NEWID()
            </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
        </cftry>
        <cfreturn local.qrySelectAllProducts>
    </cffunction>

    <cffunction  name="selectSubcategoryProducts" description="Select products according to subcategory" returntype="query">
        <cfargument  name="subcategoryId" required="false">
        <cfargument  name="sort" required="false">
        <cfargument  name="search" required="false">
        <cftry>
            <cfquery name="local.qryselectSubcategoryProducts">
                SELECT
                    TP.fldProduct_Id AS productId,
                    TP.fldProductName AS productName,
                    TP.fldDescription AS productDescription,
                    TP.fldPrice AS productPrice,
                    TP.fldTax AS productTax,
                    TP.fldSubCategoryId AS subcategoryId,
                    TB.fldBrandName brandName,
                    TPI.fldImageFileName AS productImage,
                    TS.fldSubCategoryName AS subcategoryName
                FROM
                    tblBrands as TB
                INNER JOIN tblProduct as TP ON TB.fldBrand_ID=TP.fldBrandId
                INNER JOIN tblSubCategory as TS	ON TP.fldSubCategoryId= TS.fldSubCategory_ID
                INNER JOIN tblCategory as TC ON TC.fldCategory_ID=TS.fldCategoryId
                INNER JOIN tblProductImages as TPI ON TP.fldProduct_ID=TPI.fldProductId
                WHERE 
                    TP.fldActive = 1
                AND
                    TC.fldActive = 1
                AND
                    TS.fldActive = 1
                AND
                    TPI.fldDefaultImage = 1
                <cfif structKeyExists(arguments, "subcategoryId")>
                    AND
                        TP.fldSubCategoryId = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="integer">
                </cfif>
                <cfif structKeyExists(arguments, "search")>
                    AND
                    (
                            TP.fldProductName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
                        OR
                            TP.fldDescription LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
                        OR
                            TB.fldBrandName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
                    )
                </cfif>
                <cfif structKeyExists(arguments, "sort")>
                    ORDER BY TP.fldPrice #arguments.sort#
                </cfif>
            </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
        </cftry>
        <cfreturn local.qryselectSubcategoryProducts>
    </cffunction>

    <cffunction  name="filterProducts" description="Function to filter producs" access="remote" returnformat="JSON">
        <cfargument  name="subcategoryId" required="false">
        <cfargument  name="minValue" required="false">
        <cfargument  name="maxValue" required="false">
        <cfargument  name="search" required="false">
        <cftry>
            <cfquery name="local.qryFilterProducts">
                SELECT
                    TP.fldProduct_Id AS productId,
                    TP.fldProductName AS productName,
                    TP.fldDescription AS productDescription,
                    TP.fldPrice AS productPrice,
                    TP.fldTax AS productTax,
                    TP.fldSubCategoryId AS subcategoryId,
                    TB.fldBrandName brandName,
                    TPI.fldImageFileName AS productImage,
                    TS.fldSubCategoryName AS subcategoryName
                FROM
                    tblBrands as TB
                INNER JOIN tblProduct as TP ON TB.fldBrand_ID=TP.fldBrandId
                INNER JOIN tblSubCategory as TS ON tp.fldSubCategoryId= TS.fldSubCategory_ID
                INNER JOIN tblCategory as TC ON TC.fldCategory_ID=TS.fldCategoryId
                INNER JOIN tblProductImages as TPI ON TP.fldProduct_ID=TPI.fldProductId
                WHERE 
                    TP.fldActive = 1
                AND
                    TC.fldActive = 1
                AND
                    TS.fldActive = 1
                AND
                    TPI.fldDefaultImage = 1
                <cfif structKeyExists(arguments, "subcategoryId")>
                    AND
                    TP.fldSubCategoryId = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="integer">
                </cfif>
                <cfif structKeyExists(arguments, "minValue")>
                    AND
                    TP.fldPrice >= <cfqueryparam value="#arguments.minValue#" cfsqltype="decimal">
                </cfif>
                <cfif structKeyExists(arguments, "maxValue")>
                    AND
                    TP.fldPrice <= <cfqueryparam value="#arguments.maxValue#" cfsqltype="decimal">
                </cfif>
                <cfif structKeyExists(arguments, "search")>
                    AND
                    (
                            TP.fldProductName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
                        OR
                            TP.fldDescription LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
                        OR
                            TB.fldBrandName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
                    )
                </cfif>
            </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
        </cftry>
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
        <cfargument  name="productId" required="true">
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
        <cfargument  name="productId" required="true">
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
            <cftry>
                <cfquery>
                    INSERT INTO
                        tblCart(
                            fldUserId,
                            fldProductId,
                            fldQuantity
                        )VALUES(
                            <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">,
                            <cfqueryparam value="#arguments.productId#" cfsqltype="integer">,
                            1
                        )
                </cfquery>
                <cfcatch>
                    <cfset errorMail(cfcatch.type,cfcatch.message)>
                </cfcatch>
            </cftry>
        <cfelse>
            <cfset local.productQuantity = local.qryCheckCart.fldQuantity + 1>
            <cftry>
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
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
            </cftry>
        </cfif>
        <cfreturn true>
    </cffunction>

    <cffunction  name="selectProductCart" description="Select cart products to list in cart" returntype="query">
        <cftry>
            <cfquery name="local.qrySelectProductCart">
                    SELECT 
                        TC.fldCart_ID AS cartId,
                        TC.fldProductId AS productId,
                        TC.fldQuantity AS productQuantity,
                        TP.fldProductName AS productName,
                        TP.fldDescription AS productDesc,
                        TP.fldPrice AS price,
                        TP.fldTax AS tax,
                        TB.fldBrandName AS brandName,
                        TPI.fldImageFileName AS imageName
                    FROM
                        tblCart AS TC
                    INNER JOIN tblProduct AS TP ON TC.fldProductId = TP.fldProduct_ID
                    INNER JOIN tblBrands AS tb ON TB.fldBrand_ID = TP.fldBrandId
                    INNER JOIN tblProductImages AS TPI ON TPI.fldProductId = TP.fldProduct_ID
                    WHERE
                        TP.fldActive = 1
                    AND
                        TPI.fldDefaultImage = 1
                    AND 
                        TC.fldUserId = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
            </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
        </cftry>
        <cfreturn local.qrySelectProductCart>
    </cffunction>

    <cffunction  name="removeCartProduct" access="remote" description="Function to remove product from cart">
        <cfargument  name="cartId" required="true">
        <cftry>
            <cfquery>
                DELETE FROM
                    tblCart
                WHERE
                    fldCart_ID = <cfqueryparam value="#arguments.cartId#" cfsqltype="integer">
            </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
        </cftry>
        <cfreturn true>
    </cffunction>

    <cffunction  name="cartUpdate" access="remote" description="Function to update cart" returnformat="JSON">
        <cfargument  name="cartId" required="true">
        <cfargument  name="quantity" required="true">
        <cfif arguments.quantity LT 1>
            <cfset local.returnValue["success"] = false>
        <cfelse>
            <cftry>
                <cfquery>
                    UPDATE
                        tblCart
                    SET
                        fldQuantity = <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
                    WHERE
                        fldCart_ID = <cfqueryparam value="#arguments.cartId#" cfsqltype="integer">
                </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
            </cftry>
            <cfset local.returnValue["success"] = true>
        </cfif>
        <cfreturn local.returnValue>
    </cffunction>

    <cffunction  name="addAddress" description="Function to add Address">
        <cfargument  name="formAddress" required="true">
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
            <cftry>
                <cfquery name="local.qryAddAddress">
                    INSERT INTO 
                        tblAddress(
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
                        )VALUES(
                            <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">,
                            <cfqueryparam value="#arguments.formAddress.FIRSTNAME.trim()#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.formAddress.LASTNAME.trim()#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.formAddress.ADDRESSLINE1.trim()#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.formAddress.ADDRESSLINE2.trim()#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.formAddress.CITY.trim()#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.formAddress.STATE.trim()#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.formAddress.PINCODE.trim()#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.formAddress.PHONENUMBER.trim()#" cfsqltype="varchar">,
                            1
                        )
                </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
            </cftry>
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
        <cfargument  name="addressId" required="true">
        <cftry>
            <cfquery>
                UPDATE
                    tblAddress
                SET
                    fldActive = 0
                WHERE
                    fldAddress_ID = <cfqueryparam value="#arguments.addressId#" cfsqltype="integer">
            </cfquery>
            <cfcatch>
                <cfset errorMail(cfcatch.type,cfcatch.message)>
            </cfcatch>
        </cftry>
        <cfreturn true>
    </cffunction>

    <cffunction  name="editUserProfile" description="Function to edit user" returnFormat="JSON" access="remote">
        <cfargument  name="userId" required="true">
        <cfargument  name="userFirstName" required="true">
        <cfargument  name="userLastName" required="true">
        <cfargument  name="userEmail" required="true">
        <cfargument  name="userPhoneNumber" required="true">

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
                    TOP 1
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
                    fldRoleId = 1
                AND
                    fldActive = 1
                AND
                    fldUser_ID != <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
            </cfquery>
            <cfif queryRecordCount(local.qryCheckUser)>
                <cfset local.structAddUserReturn["error"] = true>
                <cfset local.structAddUserReturn["errorMessage"] = "User Already Exists">
            <cfelse>
                <cfset local.today = now()>
                <cftry>
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
                            fldRoleId = 1
                        AND
                            fldActive = 1
                        AND
                            fldUser_ID = <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
                    </cfquery>
                    <cfcatch>
                        <cfset errorMail(cfcatch.type,cfcatch.message)>
                    </cfcatch>
                </cftry>
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
        <cfargument  name="cardNumber" required="true">
        <cfargument  name="cardMonth" required="true">
        <cfargument  name="cardYear" required="true">
        <cfargument  name="cardCvv" required="true">
        <cfargument  name="cardName" required="true">
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
        <cfargument  name="formOrderItems" required="true">
        <cfset local.cardVerification = checkCardDetails(
            cardNumber = arguments.formOrderItems.CARDNUMBERINPUT,
            cardMonth = arguments.formOrderItems.cardExpiryMonth,
            cardYear = arguments.formOrderItems.cardExpiryYear,
            cardCvv = arguments.formOrderItems.cardCvvInput,
            cardName = arguments.formOrderItems.cardNameInput
        )>

        <cfif NOT local.cardVerification["error"]>
            <cfset local.productList = selectAllProducts(arguments.formOrderItems.productIdHidden)>
            <cfif Len(arguments.formOrderItems.productIdHidden) GT 0 AND arguments.formOrderItems.orderQuantity GT 0>
                <cfset local.totalProductPrice = arguments.formOrderItems.orderQuantity * local.productList.price>
                <cfset local.totalTax = arguments.formOrderItems.orderQuantity * local.productList.tax>
                <cfset local.generatedUuid = createUUID()>
                <cftransaction>
                    <cftry>
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
                                    <cfqueryparam value="#local.totalProductPrice#" cfsqltype="decimal">,
                                    <cfqueryparam value="#local.totalTax#" cfsqltype="decimal">,
                                    <cfqueryparam value="3456" cfsqltype="varchar">
                                )
                        </cfquery>
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
                        <cfset local.returnOrder["success"] = true>
                        <cfset sentEmailUser(local.generatedUuid)>
                        <cfcatch>
                            <cftransaction action="rollback">
                            <cfset local.returnOrder["success"] = false>
                            <cfset errorMail(cfcatch.type,cfcatch.message)>
                        </cfcatch>
                    </cftry>
                </cftransaction>
            <cfelse>
                <cfset local.returnOrder["success"] = false>
            </cfif>
        <cfelse>
            <cfset local.returnOrder["success"] = false>
        </cfif>
        <cfreturn local.returnOrder>
    </cffunction>

    <cffunction  name="cartToOrder" description="Function to store cart items to order table">
        <cfargument  name="formOrderItems" required="true">
         <cfset local.cardVerification = checkCardDetails(
            cardNumber = arguments.formOrderItems.CARDNUMBERINPUT,
            cardMonth = arguments.formOrderItems.cardExpiryMonth,
            cardYear = arguments.formOrderItems.cardExpiryYear,
            cardCvv = arguments.formOrderItems.cardCvvInput,
            cardName = arguments.formOrderItems.cardNameInput
        )>

        <cfif NOT local.cardVerification["error"]>
            <cfset local.generatedUuid = createUUID()>
            <cftry>
                <cfquery>
                    EXEC
                        spCartToOrder 
                        @userId = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">,
                        @addressId = <cfqueryparam value="#arguments.formOrderItems.selectedAddressId#" cfsqltype="integer">,
                        @generatedUuid = <cfqueryparam value="#local.generatedUuid#" cfsqltype="varchar">
                </cfquery>
                <cfcatch type="exception">
                    <cfset local.returnOrder["success"] = false>
                    <cfset errorMail(cfcatch.type,cfcatch.message)>
                </cfcatch>
            </cftry>
                <cfset sentEmailUser(local.generatedUuid)>
                <cfset local.returnOrder["success"] = true>
        <cfelse>
            <cfset local.returnOrder["success"] = false>
        </cfif>
            <cfreturn local.returnOrder>
    </cffunction>

    <cffunction  name="sentEmailUser" description="Function to Sent email to user">
        <cfargument  name="orderId" required="true">
        <cfmail to = "#session.structUserDetails['email']#" from = "jibinvarghese05101999@gmail.com" subject = "Thank you for your order"> 
            Your order has been confirmed.
            You can check your order using the orderId : #arguments.orderId#
        </cfmail> 
    </cffunction>

    <cffunction  name="selectOrderTable" description="Function to select order table" returntype="query">
        <cfargument  name="orderId" required="false">
        <cfquery name="local.qrySelectOrderTable">
            SELECT
                TBLO.fldOrder_ID AS orderId,
	            TBLO.fldTotalPrice AS totalPrice,
	            TBLO.fldTotalTax AS totalTax,
	            TBLO.fldOrderDate AS orderDate,
                TA.fldFirstName AS firstName,
	            TA.fldLastName AS LastName,
	            TA.fldAddressLine1 AS addressline1,
	            TA.fldAddressLine2 AS addressLine2,
	            TA.fldCity AS city,
	            TA.fldState AS state,
	            TA.fldPincode AS pincode,
                TA.fldPhoneNumber AS phoneNumber,
                TA.fldFirstName AS firstName,
                TA.fldLastName AS lastName
            FROM
                tblOrder AS TBLO
            INNER JOIN tblAddress AS TA ON TBLO.fldAddressId = TA.fldAddress_ID
            WHERE
                TBLO.fldUserId = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
            <cfif structKeyExists(arguments, "orderId")>
                AND
                    TBLO.fldOrder_ID = <cfqueryparam value="#arguments.orderId#" cfsqltype="varchar">
            </cfif>
            ORDER BY
                TBLO.fldOrderDate
                    DESC
        </cfquery>
        <cfreturn local.qrySelectOrderTable>
    </cffunction>

    <cffunction  name="selectOrderedItemsTable" description="Function to select ordereditems table" returntype="query">
        <cfargument  name="orderId" required="false">
        <cfquery name="local.qrySelectOrderedItemsTable">
            SELECT
            	TOI.fldOrderItem_ID AS orderItemId,
            	TOI.fldOrderId AS orderId,
            	TOI.fldProductId AS productId,
            	TOI.fldQuantity AS quantity,
            	TOI.fldUnitPrice AS unitPrice,
            	TOI.fldUnitTax AS unitTax,
            	TP.fldProductName AS productName,
            	TP.fldDescription AS description,
            	TPI.fldImageFileName AS imageName,
                ta.fldFirstName AS firstName,
            	TA.fldLastName AS LastName,
            	TA.fldAddressLine1 AS addressline1,
            	TA.fldAddressLine2 AS addressLine2,
            	TA.fldCity AS city,
            	TA.fldState AS state,
            	TA.fldPincode AS pincode,
                TA.fldPhoneNumber AS phoneNumber,
                TA.fldFirstName AS firstName,
                TA.fldLastName AS lastName
            FROM
            	tblOrderedItems AS TOI
            INNER JOIN tblOrder AS TBLO ON tblO.fldOrder_ID = TOI.fldOrderId
            INNER JOIN tblProduct AS TP ON TP.fldProduct_ID = TOI.fldProductId
            INNER JOIN tblProductImages AS TPI ON tp.fldProduct_ID = TPI.fldProductId
            INNER JOIN tblAddress AS TA ON tblO.fldAddressId = TA.fldAddress_ID 
            WHERE
            	TPI.fldActive = 1
            AND
            	TPI.fldDefaultImage = 1
            AND 
            	TP.fldActive =1
            AND
                TBLO.fldUserId = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
            <cfif structKeyExists(arguments, "orderId")>
                AND
                    TOI.fldOrderId = <cfqueryparam value="#arguments.orderId#" cfsqltype="varchar">
            </cfif>
        </cfquery>
        <cfreturn local.qrySelectOrderedItemsTable>
    </cffunction>

    <cffunction  name="invoiceDownload" returnformat="plain" access="remote" description="Function to print invoice">
        <cfargument  name="orderId" required="false">
        <cfinclude template ="../userInvoice.cfm">
        <cfset local.fileUrl = "../Assets/Invoices/#local.filename#.pdf">
        <cfreturn local.fileUrl>
    </cffunction>

    <cffunction  name="errorMail" description="Function to sent error mail to user">
        <cfargument  name="type" required="true">
        <cfargument  name="message" required="true">
        <cfoutput>
            <cfmail  to = "#session.structUserDetails['email']#" from = "jibinvarghese05101999@gmail.com" subject = "#arguments.type#"> 
                #arguments.message#
            </cfmail>
        </cfoutput>
    </cffunction>

    <cffunction  name="dumpFunction">
        <cfreturn true>
    </cffunction>

</cfcomponent>