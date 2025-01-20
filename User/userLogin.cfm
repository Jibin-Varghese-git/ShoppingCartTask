<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="../bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/userSignin.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <header class="py-2 px-3 d-flex justify-content-between align-item-center">
            <a href="" class="d-flex"> 
                <div class="headerImageDiv">
                    <img src="../Assets/Images/iconCartUser.png" alt="No Image Found">
                </div>
                <h5 class="logoHeading ms-1 mt-3">E-CART</h5>
            </a>
            <div class="loginBtnClass mt-1">
                <a href="userSignup.cfm"> <button name="loginBtn" onClick="" type="button"><i class="fa-solid fa-arrow-right-to-bracket" style="color: #ccc2ff;"></i> Sign Up</button></a>
            </div>  
        </header>
        <div class="mainContainerLogin p-4 mt-3">
            <div class="containerLogin mt-5 py-2 px-4 ">
                <div class="signupHeading my-1">
                    <h2>LOGIN</h2>
                </div>
                <form method="post" class="">
                    <div class="subContainerLogin d-flex flex-column justify-content-between mt-3">
                    <div class="userInputFields ms-4 mt-3 d-flex justify-content-around">
                        <span>Username</span>
                        <div class="ms-3">
                            <input type="text" class="userNameLogin" name="userNameLogin" id="userNameLogin"><br>
                            <span class="errorUserName text-danger" id="errorUserName"></span>
                        </div>
                    </div>
                    <div class="userInputFields ms-4 mt-3 d-flex justify-content-around">
                        <span>Password</span>
                        <div class=" ms-3">
                            <input type="password" class="passwordLogin" name="passwordLogin" id="passwordLogin"><br>
                            <span class="errorPasswordLogin text-danger" id="errorPasswordLogin"></span>
                        </div>
                    </div>
                    <cfif structKeyExists(form,"btnLogin")>
                        <cfset local.objUserShoppingCart = createObject("component","components/userShoppingCart")>
                        <cfset local.structUserLoginReturn = local.objUserShoppingCart.userLogin(structForm = form)>
                        <cfif NOT local.structUserLoginReturn["error"]>
                            <cflocation  url="userHome.cfm" addToken="no">
                        <cfelse>
                            <cfoutput>
                                <span class="text-danger fw-bold ms-5">#local.structUserLoginReturn["errorMessage"]#</span>
                            </cfoutput>
                        </cfif>
                    </cfif>
                    <div class="d-flex justify-content-center">
                        <button type="submit" name="btnLogin" id="btnLogin" class="btnLogin py-2 px-3" onclick="fnLoginValidation()">LOGIN</button>
                    </div>
                    </div>
                </form>
            </div>
        </div>
       
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>