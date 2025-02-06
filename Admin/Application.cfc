<cfcomponent>
    <cfset this.datasource="dataSource_shoppingCart">
    <cfset this.sessionmanagement = "true">

    <cffunction  name="onApplicationStart"> 
        <cfif structKeyExists(session, "structUserDetails") AND session.structUserDetails['roleId'] EQ 0>
            <cfset application.objShoppingCart = createObject("component", "components.shoppingCart")>
        </cfif>
    </cffunction>
    
    <cffunction  name="onrequestStart" returntype="any">
        <cfargument name="requestpage">
        
        <cfset local.arrayExculdes = ["/Admin/adminLogin.cfm"]>
        <cfif NOT (arrayContains(local.arrayExculdes,arguments.requestpage) OR (structKeyExists(session, "structUserDetails") AND session.structUserDetails['roleId'] EQ 0))>
            <cflocation  url="adminLogin.cfm" addToken="no">
        </cfif>

        <cfif structKeyExists(url, "reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
    </cffunction>

<!---     <cffunction  name="onRequestStart" returntype="any"> 
        <cfif >
        </cfif>
    </cffunction>--->
</cfcomponent>