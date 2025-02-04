<cffunction  name="sentEmailUser">
        <cfargument  name="orderId">
            <cfdump  var="#arguments#"  abort>
        <cfmail to = "jibin052001@gmail.com" from = "jibinvarghese05101999@gmail.com" subject = "Thank you for your order"> 
            Your order has been confirmed.
            You can check your order using the orderId : #arguments.orderId#
        </cfmail> 
    </cffunction>