<cfcomponent>

    <cffunction  name="fnAdminLogin">
        <cfargument  name="structAdminDetails">
        <cfset local.structAdminLoginReturn = structNew()>
        <cfset local.structAdminLoginReturn["error"] = false>
        <cfif Len(trim(arguments.structAdminDetails.userName)) EQ 0>
            <cfset local.structAdminLoginReturn["error"] = true>
            <cfset local.structAdminLoginReturn["errorMessage"] = "Enter the username">
        </cfif>
        <cfif Len(trim(arguments.structAdminDetails.password)) EQ 0>
            <cfset local.structAdminLoginReturn["error"] = true>
            <cfset local.structAdminLoginReturn["errorMessage"] = "Enter the password">
        </cfif>
        <cfif  NOT local.structAdminLoginReturn["error"]>
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
                    (fldEmail = <cfqueryparam value="#arguments.structAdminDetails.userName#" cfsqltype="varchar">
                OR 
                    fldPhone = <cfqueryparam value="#arguments.structAdminDetails.userName#" cfsqltype="varchar">)
                AND
                    fldRoleId = <cfqueryparam value=0 cfsqltype="integer">
                AND
                    fldActive = 1
            </cfquery>
            <cfif queryRecordCount(local.qrySelectAdmin)>
                <cfset local.password = arguments.structAdminDetails.password & local.qrySelectAdmin.fldUserSaltString>
                <cfset local.hashedPassword = hash(local.password,"SHA-256","UTF-8")>
                <cfif local.hashedPassword EQ local.qrySelectAdmin.fldHashedPassword>
                    <cfset session.structUserDetails["userId"] = local.qrySelectAdmin.flduser_ID>
                    <cfset session.structUserDetails["firstName"] = local.qrySelectAdmin.fldFirstName>
                    <cfset session.structUserDetails["lastName"] = local.qrySelectAdmin.fldLastName>
                    <cfset session.structUserDetails["phone"] = local.qrySelectAdmin.fldPhone>
                    <cfset session.structUserDetails["email"] = local.qrySelectAdmin.fldEmail>
                    <cfset session.structUserDetails["roleId"] = local.qrySelectAdmin.fldRoleId>
                    <cfset local.structAdminLoginReturn["error"] = false>
                <cfelse>
                    <cfset local.structAdminLoginReturn["error"] = true>
                    <cfset local.structAdminLoginReturn["errorMessage"] = "Invalid password">                
                </cfif>
            <cfelse>
                <cfset local.structAdminLoginReturn["error"] = true>
                <cfset local.structAdminLoginReturn["errorMessage"] = "Invalid Username">
            </cfif>
        </cfif>
        <cfreturn local.structAdminLoginReturn>
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
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
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
                        <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">,
                        <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="varchar">
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
                fldActive = <cfqueryparam value='0' cfsqltype="integer">
            WHERE
                fldCategory_ID = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
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
                fldCategory_ID = <cfqueryparam value="#arguments.categoryId#" cfsqltype="varchar">
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
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
            AND
                fldActive = 1
            AND NOT 
                fldcategory_ID = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
        </cfquery>
        <cfif qrycategoryNameCount.categoryNameCount LT 1> 
            <cfset local.todayDate = now()>
            <cfquery name="qryUpdateCategory">
                UPDATE 
                    tblCategory
                SET
                    fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">,
                    fldUpdatedBy = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="varchar">,
                    fldUpdatedDate = <cfqueryparam value="#local.todayDate#" cfsqltype="date">
                WHERE
                    fldcategory_ID=<cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
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
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            AND
                fldActive = 1
        </cfquery>
        <cfset local.structSubCategoryDetails = structNew()>
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
                fldSubCategoryName = <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="varchar">
            AND
                fldActive = 1
            AND
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="varchar">
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
                        <cfqueryparam value="#arguments.categoryId#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="varchar">,
                        <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="varchar">
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
                fldSubCategory_Id = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="integer">
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
                fldSubCategoryName = <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="varchar">
            AND
                fldActive = 1
            AND
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            AND NOT 
                fldSubCategory_ID = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="integer">
        </cfquery>
        <cfif qrySubcategoryNameCount.subcategoryNameCount LT 1> 
            <cfset local.todayDate = now()>
            <cfquery name="qryUpdateCategory">
                UPDATE 
                    tblSubCategory
                SET
                    fldSubCategoryName = <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="varchar">,
                    fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">,
                    fldUpdatedBy = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="varchar">,
                    fldUpdatedDate = <cfqueryparam value="#local.todayDate#" cfsqltype="date">
                WHERE
                    fldSubCategory_ID=<cfqueryparam value="#arguments.subcategoryId#" cfsqltype="integer">
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
                fldActive = <cfqueryparam value='0' cfsqltype="integer">
            WHERE
                fldSubCategory_ID = <cfqueryparam value="#arguments.subcategoryId#" cfsqltype="integer">
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

    <cffunction  name="fnAddProduct" access="remote" returnFormat="plain">
        <cfargument  name="subcategoryListing">
        <cfargument  name="productName">
        <cfargument  name="brandListing">
        <cfargument  name="productImages">
        <cfargument  name="productDescription">
        <cfargument  name="productPrice">
        <cfargument  name="productTax">

        <cfquery name="local.qryProductNameCheck">
            SELECT
                count(fldProductName) AS productNameCount
            FROM
                tblProduct
            WHERE
                fldProductName = <cfqueryparam value="#trim(arguments.productName)#" cfsqltype="varchar">
            AND
                fldActive = 1
            AND
                fldSubCategoryId = <cfqueryparam value="#arguments.subcategoryListing#" cfsqltype="varchar">
        </cfquery>
        <cfif local.qryProductNameCheck.productNameCount LT 1>
            <cfset local.imageLocation="../../Assets/productImages">
            <cfif NOT directoryExists(expandPath(local.imageLocation))>
                <cfset directoryCreate(expandPath(local.imageLocation))>
            </cfif>
            <cffile action="uploadall"
                    destination="#expandPath(local.imageLocation)#"
                    nameConflict="MakeUnique"
                    result="local.fileNames"        
            >

            <cfquery result="local.qryAddProducts">
                INSERT INTO
                    tblProduct
                    (
                        fldSubCategoryId,
                        fldProductName,
                        fldBrandId,
                        fldDescription,
                        fldPrice,
                        fldTax,
                        fldCreatedBy 
                    )
                VALUES
                    (
                        <cfqueryparam value="#arguments.subcategoryListing#" cfsqltype="integer">,
                        <cfqueryparam value="#trim(arguments.productName)#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.brandListing#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.productDescription#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.productPrice#" cfsqltype="decimal" scale="2">,
                        <cfqueryparam value="#arguments.productTax#" cfsqltype="decimal" scale="2">,
                        <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
                    )
            </cfquery>
            <cfset local.defaultValue = 1>
            <cfloop array="#local.fileNames#" index="local.arrayFileName">
                <cfquery>
                    INSERT INTO
                        tblProductImages
                        (
                            fldProductId,
                            fldImageFileName,
                            fldDefaultImage,
                            fldCreatedBy
                        )   
                    VALUES
                        (
                            <cfqueryparam value="#local.qryAddProducts.GENERATEDKEY#" cfsqltype="integer">,
                            <cfqueryparam value="#local.arrayFileName.SERVERFILE#" cfsqltype="varchar">,
                            <cfqueryparam value="#local.defaultValue#" cfsqltype="integer">,
                            <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
                        )
                </cfquery>
                <cfset local.defaultValue = 0>
            </cfloop>
            <cfset local.result=true>
        <cfelse>
            <cfset local.result=false>
        </cfif>
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="fnSelectProduct" access="remote">
        <cfargument  name="subCategoryId">
        
        <cfquery name="local.qrySelectProductDetails">
            SELECT
                tp.fldProduct_ID,
                tp.fldProductName,
                tp.fldDescription,
                tp.fldPrice,
                tp.fldTax,
                tpi.fldProductImage_ID,
                tpi.fldImageFileName,
                tb.fldBrandName
            FROM
                tblBrands as tb
            INNER JOIN 
                tblProduct AS tp
            ON
                tb.fldBrand_Id=tp.fldBrandId
            INNER JOIN
                tblProductImages AS tpi
            ON
                tp.fldProduct_ID=tpi.fldProductId
            WHERE
                fldSUbCategoryId=<cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            AND
                tp.fldActive=1
            AND
                tpi.fldActive=1
            AND
                tpi.fldDefaultImage=1
        </cfquery>
        <cfreturn local.qrySelectProductDetails>
    </cffunction>

    <cffunction  name="fnSelectSingleProduct"  access="remote" returnFormat="JSON">
        <cfargument  name="productId">
        <cfquery name="local.qrySingleSelectProduct">
            SELECT
                tp.fldProduct_ID,
                tp.fldProductName,
                tp.fldDescription,
                tp.fldPrice,
                tp.fldTax,
                tpi.fldProductImage_ID,
                tpi.fldImageFileName,
                tb.fldBrandName,
                tp.fldBrandId
            FROM
                tblBrands as tb
            INNER JOIN 
                tblProduct AS tp
            ON
                tb.fldBrand_Id=tp.fldBrandId
            INNER JOIN
                tblProductImages AS tpi
            ON
                tp.fldProduct_ID=tpi.fldProductId
            WHERE
                tp.fldProduct_ID=<cfqueryparam value="#arguments.productId#" cfsqltype="integer">
            AND
                tp.fldActive=1
            AND
                tpi.fldActive=1
        </cfquery>
        <cfset structProductDetails["productName"] = local.qrySingleSelectProduct.fldProductName>
        <cfset structProductDetails["description"] = local.qrySingleSelectProduct.fldDescription>
        <cfset structProductDetails["price"] = local.qrySingleSelectProduct.fldPrice>
        <cfset structProductDetails["brandId"] = local.qrySingleSelectProduct.fldBrandId>
        <cfset structProductDetails["tax"] = local.qrySingleSelectProduct.fldtax>
        <cfreturn structProductDetails>
    </cffunction>

    <cffunction  name="fnUpdateProduct" access="remote" returnFormat="plain">
        <cfargument  name="subcategoryListing">
        <cfargument  name="productName">
        <cfargument  name="brandListing">
        <cfargument  name="productImages">
        <cfargument  name="productDescription">
        <cfargument  name="productPrice">
        <cfargument  name="productTax">
        <cfargument  name="hiddenProductId">
        <cfquery name="local.qryProductNameCheck">
            SELECT
                count(fldProductName) AS productNameCount
            FROM
                tblProduct
            WHERE
                fldProductName = <cfqueryparam value="#trim(arguments.productName)#" cfsqltype="varchar">
            AND
                fldActive = 1
            AND
                fldSubCategoryId = <cfqueryparam value="#arguments.subcategoryListing#" cfsqltype="varchar">
            AND
                NOT
                fldProduct_ID = <cfqueryparam value="#arguments.hiddenProductId#" cfsqltype="decimal">
        </cfquery>
        <cfif local.qryProductNameCheck.productNameCount LT 1>
            <cfset local.imageLocation="../../Assets/productImages">
            <cfif NOT directoryExists(expandPath(local.imageLocation))>
                <cfset directoryCreate(expandPath(local.imageLocation))>
            </cfif>
            <cffile action="uploadall"
                    destination="#expandPath(local.imageLocation)#"
                    nameConflict="MakeUnique"
                    result="local.fileNames"        
            >
            <cfset local.today = now()>
            <cfquery name="local.qryUpdate">
                UPDATE
                    tblProduct
                SET
                    fldSubCategoryId = <cfqueryparam value="#arguments.subcategoryListing#" cfsqltype="integer">,
                    fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="varchar">,
                    fldBrandId = <cfqueryparam value="#arguments.brandListing#" cfsqltype="varchar">,
                    fldDescription =  <cfqueryparam value="#arguments.productDescription#" cfsqltype="varchar">,
                    fldPrice = <cfqueryparam value="#arguments.productPrice#" cfsqltype="decimal" scale="2">,
                    fldTax = <cfqueryparam value="#arguments.productTax#" cfsqltype="decimal" scale="2">,
                    fldUpdatedBy = <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">,
                    fldUpdatedDate = <cfqueryparam value="#local.today#" cfsqltype="date">
                WHERE
                    fldProduct_ID = <cfqueryparam value="#arguments.hiddenProductId#" cfsqltype="decimal">
                AND
                    fldActive = 1
            </cfquery>
            <cfset local.defaultValue = 0>
            <cfloop array="#local.fileNames#" index="local.arrayFileName">
                    <cfquery>
                        INSERT INTO
                            tblProductImages
                            (
                                fldProductId,
                                fldImageFileName,
                                fldDefaultImage,
                                fldCreatedBy
                            )   
                        VALUES
                            (
                                <cfqueryparam value="#arguments.hiddenProductId#" cfsqltype="integer">,
                                <cfqueryparam value="#local.arrayFileName.SERVERFILE#" cfsqltype="varchar">,
                                <cfqueryparam value="#local.defaultValue#" cfsqltype="integer">,
                                <cfqueryparam value="#session.structUserDetails["userId"]#" cfsqltype="integer">
                            )
                    </cfquery>
            </cfloop>
            <cfset local.result=true>
        <cfelse>
            <cfset local.result=false>
        </cfif>
        
        <cfreturn local.result>
    </cffunction>

    <cffunction  name="fnDeleteProduct" access="remote">
        <cfargument  name="productId">
        <cfquery name="local.deleteProduct">
            UPDATE
                tblProduct
            SET
                fldActive = 0
            WHERE
                fldProduct_ID =<cfqueryparam value="#arguments.productId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="fnSelectImage" access="remote" returnFormat="JSON">
        <cfargument  name="productId">
        <cfquery name="local.qrySelectImage">
            SELECT
                fldProductImage_ID, 
                fldImageFileName,
                fldDefaultImage
            FROM
                tblProductImages
            WHERE
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="decimal">
            AND
                fldActive = 1
            ORDER BY 
                fldDefaultImage
            DESC 
        </cfquery>

        <cfset local.imagePath="../Assets/productImages/">
        <cfloop query="local.qrySelectImage">
            <cfif local.qrySelectImage.fldDefaultImage EQ 1>
                <cfset local.structImageDetails["thumbnailImage"][local.qrySelectImage.fldProductImage_ID] = local.imagePath & local.qrySelectImage.fldImageFileName>
            <cfelse>
                <cfset local.structImageDetails["otherImages"][local.qrySelectImage.fldProductImage_ID] = local.imagePath & local.qrySelectImage.fldImageFileName>
            </cfif>
        </cfloop>
        <cfreturn local.structImageDetails>

    </cffunction>

    <cffunction  name="fnDeleteProductImage" access="remote">
        <cfargument  name="productImageId">
        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldActive = 0
            WHERE
                fldProductImage_ID = <cfqueryparam value="#arguments.productImageId#">
        </cfquery>
        <cfreturn true>
    </cffunction>

    <cffunction  name="fnSetThumbnail" access="remote">
        <cfargument  name="productImageId">
        <cfargument  name="productId">
        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = 0
            WHERE
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
        </cfquery>
        <cfquery>
            UPDATE
                tblProductImages
            SET
                fldDefaultImage = 1
            WHERE
                fldProductImage_ID = <cfqueryparam value="#arguments.productImageId#" cfsqltype="integer">
            AND
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
        </cfquery>
        <cfreturn true>
    </cffunction>

</cfcomponent>