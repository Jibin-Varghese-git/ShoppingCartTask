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
                    fldPhone = <cfqueryparam value="#arguments.structForm.userPhone#" cfsqltype="varchar">
                OR
                    fldEmail = <cfqueryparam value="#arguments.structForm.userEmail#" cfsqltype="varchar">
                AND
                    fldRoleId = <cfqueryparam value='1' cfsqltype="varchar">
                AND
                    fldActive = 1
            </cfquery>
            <cfif queryRecordCount(local.qryCheckUser)>
                <cfset local.structAddUserReturn["error"] = true>
                <cfset local.structAddUserReturn["errorMessage"] = "User Already Exists">
            <cfelse>
                <cfquery>
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

    <cffunction  name="selectRandomProducts" description="Function to select random products" >
        <cfquery name="local.qryRandomProducts">
        	SELECT 
            TOP 12
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

    <cffunction  name="selectDistinctSubCategory" access="remote" returnformat="JSON">
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

    <cffunction  name="selectSubcategory">
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



    <cffunction  name="logoutUser" access="remote">
        <cfset structClear(session)>
        <cflocation  url="../userHome.cfm" addToken="no">
    </cffunction>


    <cffunction  name="selectAllProducts" description="Function to select all products">
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
				tpi.fldImageFileName AS imageName   ,
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
        </cfquery>
        <cfreturn local.qrySelectAllProducts>
    </cffunction>

    <cffunction  name="selectSubcategoryProducts" description="Select products according to subcategory">
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
				tblProductImages as tpi
			ON
				tp.fldProduct_ID=tpi.fldProductId
            WHERE 
                tp.fldActive = 1
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
				tblProductImages as tpi
			ON
				tp.fldProduct_ID=tpi.fldProductId
            WHERE 
                tp.fldActive = 1
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

    <cffunction  name="selectProductImages">
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

    <cffunction  name="selectSearchProducts" returntype="query">
        <cfargument  name="search">
        <cfquery name="local.qrySelectSearchProducts">
            SELECT 
                tp.fldProduct_ID AS productId,
                tp.fldProductName AS productName,
                tp.fldDescription AS productDesc,
                tp.fldPrice AS productPrice,
                tp.fldTax AS tax,
                tp.fldSubCategoryId AS subcategoryId,
                tb.fldBrandName AS brandName,
				tpi.fldImageFileName AS productImage
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
			AND
            (
			    	tp.fldProductName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
			    OR
			    	tp.fldDescription LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
			    OR
			    	tb.fldBrandName LIKE <cfqueryparam value='%#arguments.search#%' cfsqltype="varchar">
            )
        </cfquery>
        <cfreturn local.qrySelectSearchProducts>
    </cffunction>


</cfcomponent>