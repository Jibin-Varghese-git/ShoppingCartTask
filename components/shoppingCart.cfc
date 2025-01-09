<cfcomponent>

    <cffunction  name="fnAdminLogin">
        <cfargument  name="structAdminDetails">
            <cfset structClear(session)>
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
                    fldEmail = <cfqueryparam value="#arguments.structAdminDetails.userName#" cfsqltype="cf_sql_varchar">
                OR 
                    fldPhone = <cfqueryparam value="#arguments.structAdminDetails.userName#" cfsqltype="cf_sql_varchar">
                AND
                    fldRoleId = <cfqueryparam value='0' cfsqltype="cf_sql_varchar">
                AND
                    fldActive = <cfqueryparam value='0' cfsqltype="cf_sql_varchar">
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

</cfcomponent>