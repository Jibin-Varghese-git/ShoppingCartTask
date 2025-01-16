<cfcomponent>
    <cfset this.datasource="dataSource_shoppingCart">
    <cfset this.sessionmanagement = "true">
    
    <cffunction  name="onApplicationStart">
        <cfset application.objShoppingCart = createObject("component", "components.shoppingCart")>
    </cffunction>
    
    <cffunction  name="onrequest" returntype="any">
        <cfargument name="requestpage">
        <cfset local.arrayExculdes = ["/adminLogin.cfm"]>
        <cfif arrayContains(local.arrayExculdes,arguments.requestpage)>
            <cfinclude  template="#arguments.requestpage#" >
        <cfelseif structKeyExists(session, "structUserDetails")>
            <cfinclude  template="#arguments.requestpage#">
        <cfelse>
            <cfinclude  template="adminLogin.cfm">
        </cfif>
    </cffunction>
<!---     <cffunction  name="onRequestStart" returntype="any"> 
        <cfif >
        </cfif>
    </cffunction>--->
</cfcomponent>