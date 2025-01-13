<cfcomponent>

    <cffunction  name="fnAdminLogin">
        <cfargument  name="structAdminDetails">
            <cfquery name="local.qrySelectAdmin">
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
                    (fldEmail = <cfqueryparam value="#arguments.structAdminDetails.userName#" cfsqltype="cf_sql_varchar">
                OR 
                    fldPhone = <cfqueryparam value="#arguments.structAdminDetails.userName#" cfsqltype="cf_sql_varchar">)
                AND
                    fldRoleId = <cfqueryparam value='0' cfsqltype="cf_sql_varchar">
                AND
                    fldActive = 1
            </cfquery>
            <cfset local.password = arguments.structAdminDetails.password & local.qrySelectAdmin.fldUserSaltString>
            <cfset local.hashedPassword = hash(local.password,"SHA-256","UTF-8")>
            <cfif local.hashedPassword EQ local.qrySelectAdmin.fldHashedPassword>
                <cfset session.structUserDetails["userId"] = local.qrySelectAdmin.flduser_ID>
                <cfset session.structUserDetails["firstName"] = local.qrySelectAdmin.fldFirstName>
                <cfset session.structUserDetails["lastName"] = local.qrySelectAdmin.fldLastName>
                <cfset session.structUserDetails["phone"] = local.qrySelectAdmin.fldPhone>
                <cfset session.structUserDetails["email"] = local.qrySelectAdmin.fldEmail>
                <cfset session.structUserDetails["roleId"] = local.qrySelectAdmin.fldRoleId>
                <cfset local.result = true>
                <cflocation  url="adminCategory.cfm" addToken="no">
            <cfelse>
                <cfset local.result = false>
            </cfif>
            <cfreturn local.result>
    </cffunction>

    <cffunction  name="fnLogout" access="remote">
        <cfset structClear(session)>
        <cfreturn true>
    </cffunction>

    <cffunction  name="fnSelectCategory">
        <cfquery name="local.qrySelectCategory">
            SELECT
                fldCategory_ID,
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldActive = 1
        </cfquery>
        <cfreturn local.qrySelectCategory>
    </cffunction>

    <cffunction  name="fnAddCategory" access="remote" returnformat="plain">
        <cfargument  name="categoryName">
        <cfquery name="qrycategoryNameCount">
            SELECT
                count(fldCategoryName)
            AS
                categoryNameCount
            FROM
                tblCategory
            WHERE
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
            AND
                fldActive = 1
        </cfquery>
        <cfif qrycategoryNameCount.categoryNameCount LT 1> 
            <cfquery name="qryAddCategory">
                INSERT INTO
                    tblCategory
                    (
                        fldCategoryName,
                        fldCreatedBy
                    )
                VALUES
                    (
                        <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="cf_sql_varchar">
                    )
            </cfquery>
            <cfset local.result = true>
        <cfelse>
            <cfset local.result = false>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="fnDeleteCategory" access="remote" >
        <cfargument  name="categoryId">
        <cfquery name="deleteCategory">  
            UPDATE 
                tblCategory
            SET
                fldActive = <cfqueryparam value='0' cfsqltype="cf_sql_integer">
            WHERE
                fldCategory_ID = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="fnSelectCategoryName" access="remote" returnformat="plain">
        <cfargument  name="categoryId">
        <cfquery name="local.qrySelectCategoryName">
            SELECT
                fldCategoryName
            FROM
                tblCategory
            WHERE
                fldCategory_ID = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_varchar">
            AND
                fldActive = 1
        </cfquery>
        <cfreturn local.qrySelectCategoryName.fldCategoryName>
    </cffunction>

    <cffunction  name="fnUpdateCategory" access="remote" returnformat="plain">
        <cfargument  name="categoryName">
        <cfargument  name="categoryId">
        <cfquery name="local.qrycategoryNameCount">
            SELECT
                count(fldCategoryName)
            AS
                categoryNameCount
            FROM
                tblCategory
            WHERE 
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
            AND
                fldActive = 1
            AND NOT 
                fldcategory_ID = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif qrycategoryNameCount.categoryNameCount LT 1> 
            <cfset local.todayDate = now()>
            <cfquery name="qryUpdateCategory">
                UPDATE 
                    tblCategory
                SET
                    fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">,
                    fldUpdatedBy = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="cf_sql_varchar">,
                    fldUpdatedDate = <cfqueryparam value="#local.todayDate#" cfsqltype="cf_sql_date">
                WHERE
                    fldcategory_ID=<cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset local.result = true>
        <cfelse>
            <cfset local.result = false>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="fnSelectSubCategory" access="remote" returnformat="JSON">
        <cfargument  name="categoryId">
        <cfquery name="local.qrySelectSubCategory">
            SELECT
                fldSubCategory_ID,
                fldSubCategoryName
            FROM
                tblSubCategory
            WHERE
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
            AND
                fldActive = 1
        </cfquery>
        <cfloop query="local.qrySelectSubCategory">
            <cfset local.structSubCategoryDetails[local.qrySelectSubCategory.fldSubCategory_ID] = local.qrySelectSubCategory.fldSubCategoryName>
        </cfloop>
        <cfreturn local.structSubCategoryDetails>
    </cffunction>

    <cffunction  name="fnAddSubcategory" access="remote" returnformat="plain">
        <cfargument  name="subcategoryName">
        <cfargument  name="categoryId">
        <cfquery name="qrycategoryNameCount">
            SELECT
                count(fldSubCategoryName)
            AS
                subcategoryNameCount
            FROM
                tblSubCategory
            WHERE
                fldSubCategoryName = <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="cf_sql_varchar">
            AND
                fldActive = 1
            AND
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif qrycategoryNameCount.subcategoryNameCount LT 1> 
            <cfquery name="qryAddSubcategory">
                INSERT INTO
                    tblSubCategory
                    (
                        fldCategoryId,
                        fldSubCategoryName,
                        fldCreatedBy
                    )
                VALUES
                    (
                        <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="cf_sql_varchar">
                    )
            </cfquery>
            <cfset local.result = true>
        <cfelse>
            <cfset local.result = false>
        </cfif>
        <cfreturn local.result>
    </cffunction>


    <cffunction  name="fnSelectSubcategoryDetails" access="remote" returnformat="JSON">
        <cfargument  name="subcategoryId">
        <cfquery name="qrySelectSubcategoryDetails">
            SELECT
                fldSubCategory_ID,
                fldSubCategoryName,
                fldCategoryId
            FROM
                tblSubCategory
            WHERE
                fldSubCategory_Id = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset local.structSubcategoryDetails["subcategoryId"] = qrySelectSubcategoryDetails.fldSubCategory_ID>
        <cfset local.structSubcategoryDetails["subcategoryName"] = qrySelectSubcategoryDetails.fldSubCategoryName>
        <cfset local.structSubcategoryDetails["categoryId"] = qrySelectSubcategoryDetails.fldCategoryId>
        <cfreturn local.structSubcategoryDetails>
    </cffunction>

    <cffunction  name="fnUpdateSubcategory" access="remote" returnformat="plain">
        <cfargument  name="subcategoryName">
        <cfargument  name="categoryId">
        <cfargument  name="subcategoryId">
        <cfquery name="local.qrySubcategoryNameCount">
            SELECT
                count(fldSubCategoryName)
            AS
                subcategoryNameCount
            FROM
                tblSubCategory
            WHERE 
                fldSubCategoryName = <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="cf_sql_varchar">
            AND
                fldActive = 1
            AND
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
            AND NOT 
                fldSubCategory_ID = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif qrySubcategoryNameCount.subcategoryNameCount LT 1> 
            <cfset local.todayDate = now()>
            <cfquery name="qryUpdateCategory">
                UPDATE 
                    tblSubCategory
                SET
                    fldSubCategoryName = <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="cf_sql_varchar">,
                    fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">,
                    fldUpdatedBy = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="cf_sql_varchar">,
                    fldUpdatedDate = <cfqueryparam value="#local.todayDate#" cfsqltype="cf_sql_date">
                WHERE
                    fldSubCategory_ID=<cfqueryparam value="#arguments.subcategoryId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset local.result = true>
        <cfelse>
            <cfset local.result = false>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="fnDeleteSubcategory" access="remote" >
        <cfargument  name="subcategoryId">
        <cfquery name="deleteSubcategory">  
            UPDATE 
                tblSubCategory
            SET
                fldActive = <cfqueryparam value='0' cfsqltype="cf_sql_integer">
            WHERE
                fldSubCategory_ID = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="fnSelectBrand">
        <cfquery name="local.qrySelectBrand">
            SELECT 
                fldBrand_ID,
                fldBrandName
            FROM
                tblBrands
            WHERE
                fldActive = 1
        </cfquery>
        <cfreturn local.qrySelectBrand>
    </cffunction>

    <cffunction  name="fnAddProduct">
        <cfargument  name="productName">
        <cfargument  name="productDescription">
        <cfargument  name="productPrice">
        <cfargument  name="productTax">
        <cfargument  name="brandId">
        <cfargument  name="subCategoryId">

        <cfquery name="qryAddProducts">
            INSERT INTO
                tblProduct
            ()
        </cfquery>
    </cffunction>

</cfcomponent>