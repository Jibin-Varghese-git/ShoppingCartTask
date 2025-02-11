<cfcomponent>
    <cfset this.datasource="dataSource_shoppingCart">
    <cfset this.sessionmanagement = "true">

    <cffunction  name="onrequestStart" returntype="any"> 
        <cfargument name="requestpage">

       <cfset local.arrayIncludes = ["/user/userOrder.cfm",
            "/User/userOrderHistory.cfm",
            "/User/userCart.cfm",
            "/User/userProfile.cfm"
        ]>
        <cfif NOT((NOT arrayContainsNocase(local.arrayIncludes,arguments.requestpage)) OR structKeyExists(session, "structUserDetails"))>
            <cflocation  url="userLogin.cfm" addToken="no">
         </cfif> 
    </cffunction> 

<!---     <cffunction  name="onError" returntype="void"> 
        <cfargument name="Exception" required=true/>
        <cfargument name="EventName" type="String" required=true/>
        <cflocation  url="errorPage.cfm?exception=#arguments.Exception#" addToken="no">
    </cffunction>--->

</cfcomponent>
