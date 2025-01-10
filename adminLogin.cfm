<!DOCTYPE html>

<html>
    <head>
        <title>ADMIN LOGIN</title>
        <link rel="stylesheet" href="bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>

        <header class="p-2">
            <div class="headerDiv p-1 d-flex  justify-content-between">
                <div class="headerCartName">
                    <a href="" class="d-flex"> 
                        <div class="headerImageDiv">
                            <img src="Assets/Images/shoppingCart_icon2.png" alt="No Image Found">
                        </div>
                        <h5 class="color-white ms-2 mt-2">E-CART</h5>
                    </a>
                </div>
                <div class="headerHeadingDiv">
                    <span>ADMIN</span>
                </div>
            </div>
        </header>

        <div class="mainContentDiv p-5">
            <div class="loginDiv my-3 px-5 py-4">
                <form method="post">    
                    <div class="d-flex flex-column justify-content-center mt-5 pt-2"> 
                        <div class="loginDivHeading px-5 py-2">
                            <span class="ms-4">ADMIN LOGIN</span>
                        </div>               
                        <input type="text" name="Username" placeholder="Username" id="userName" class="my-3">
                        <div id="errorUserName"  class="text-danger fw-bold"></div>
                        <input type="password" name="password" placeholder="Password" id="password" class="my-3">
                        <div id="errorPassword" class="text-danger fw-bold"></div>
                        <button type="submit" name="loginBtn" class="mt-3" onClick="fnValAdminLogin()">LOGIN</button>
                    </div>
                </form>
                <cfif structKeyExists(form, "loginBtn")>
                    <cfset result = application.objShoppingCart.fnAdminLogin(form)>
                    <cfif NOT result>
                        <span class="fw-bold text-danger">Invalid Username or Password</span>
                    </cfif>
                </cfif>
            </div>
        </div>
     
        <script src="js/script.js"></script>
    </body>
</html>