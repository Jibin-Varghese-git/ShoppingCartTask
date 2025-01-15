<cffunction  name="fnAddUser">
    <cfargument  name="structForm">
    <cfset local.saltString = generateSecretKey(("AES"),128)>
    <cfset local.password = arguments.structForm.password & local.saltString>
    <cfset local.hashedPassword = hash(local.password,"SHA-256", "UTF-8")>
    <cfquery name="local.qryCheckUser">
        SELECT
            fldEmail
        FROM
            tblUser
        WHERE
            fldPhone = <cfqueryparam value="#arguments.structForm.userPhone#" cfsqltype="cf_sql_varchar">
        OR
            fldEmail = <cfqueryparam value="#arguments.structForm.userEmail#" cfsqltype="cf_sql_varchar">
        AND
            fldRoleId = <cfqueryparam value='1' cfsqltype="cf_sql_varchar">
        AND
            fldActive = 1
    </cfquery>
    <cfif queryRecordCount(local.qryCheckUser)>
        <cfset local.result = false>
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
                    <cfqueryparam value="#arguments.structForm.firstName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.structForm.lastName#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.structForm.userPhone#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#arguments.structForm.userEmail#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#local.saltString#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value='1' cfsqltype="cf_sql_varchar">
                )
        </cfquery>
        <cfset local.result = true>
    </cfif> 
        <cfreturn local.result>   
</cffunction>