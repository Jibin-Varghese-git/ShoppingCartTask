<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.datasource="dataSource_shoppingCart">
    <cfset this.sessionmanagement = "true">
    <cfset this.sessiontimeout=CreateTimeSpan(0,0,30,0)>

    <cffunction  name="onApplicationStart"> 
            <cfset application.objShoppingCart = createObject("component", "Admin.components.shoppingCart")>
    </cffunction>

    <cffunction  name="onrequestStart" returntype="any"> 
        <cfargument name="requestpage">
        
        
        <cfif FindNoCase("/Admin",arguments.requestPage)>
            <cfset local.arrayAdminExculdes = ["/Admin/adminLogin.cfm"]>
            <cfif NOT (arrayContains(local.arrayAdminExculdes,arguments.requestpage) OR (structKeyExists(session, "structAdminDetails") AND session.structAdminDetails['roleId'] EQ 0))>
                <cflocation  url="adminLogin.cfm" addToken="no">
            </cfif>
        <cfelse>
            <cfset local.arrayExcludes = [  "/user/userHome.cfm", 
                                            "/User/userLogin.cfm",
                                            "/User/userSignup.cfm",
                                            "/User/userCategory.cfm",
                                            "/User/userSubcategory.cfm",
                                            "/User/userProduct.cfm"
                                         ]>
            <cfif NOT((arrayContainsNocase(local.arrayExcludes,arguments.requestpage)) OR structKeyExists(session, "structUserDetails"))>
                <cflocation  url="userLogin.cfm" addToken="no">
            </cfif>
        </cfif>

          <cfif structKeyExists(url, "reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
    </cffunction>

    <cffunction  name="onError" returntype="void">
        <cfif FindNoCase("/Admin",CGI.script_name)>
            <cflocation  url="errorPageAdmin.cfm" addToken="no">
        <cfelse>
            <cflocation  url="errorPage.cfm" addToken="no">
        </cfif>
    </cffunction>

</cfcomponent>