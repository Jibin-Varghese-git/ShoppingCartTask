<cfcomponent>
    <cfset this.datasource="dataSource_shoppingCart">
    <cfset this.sessionmanagement = "true">
    
    <cffunction  name="onApplicationStart">
        <cfset application.objShoppingCart = createObject("component", "components.shoppingCart")>
    </cffunction>
    
    <cffunction  name="onrequestStart" returntype="any">
        <cfargument name="requestpage">
        <cfset local.arrayExculdes = ["/ShoppingCartTask/Admin/adminLogin.cfm"]>
        <cfif NOT (arrayContains(local.arrayExculdes,arguments.requestpage) OR structKeyExists(session, "structUserDetails"))>
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