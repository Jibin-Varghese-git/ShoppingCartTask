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
			INNER JOIN 
				tblProductImages as tpi
			ON
				tp.fldProduct_ID=tpi.fldProductId
            WHERE 
                tp.fldActive = 1
			AND
				tpi.fldDefaultImage = 1
            ORDER BY 
                NEWID()
        </cfquery>
        <cfreturn local.qryRandomProducts>
    </cffunction>

</cfcomponent>