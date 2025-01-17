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
        <cfset local.objUserShoppingCart = createObject("component","components/userShoppingCart")>
        <header class="py-2 px-3 d-flex justify-content-between align-item-center">
            <a href="userHome.cfm" class="d-flex"> 
                <div class="headerImageDiv">
                    <img src="../Assets/Images/iconCartUser.png" alt="No Image Found">
                </div>
                <h5 class="logoHeading ms-1 mt-3">E-CART</h5>
            </a>
            <div class="searchbarDiv d-flex">
                <input type="text" class="searchInput" name="searchInput" id="searchInput">
                <button name="searchBtn" class="searchBtn" type="button"><i class="fa-solid fa-magnifying-glass" style="color: #ccc2ff;"></i></button>
            </div>
            <div class="headerBtnClass mt-1">
                <button name="cartBtn" onClick="" class="mx-2" type="button"><i class="fa-solid fa-cart-shopping" style="color: #d2c9ff;"></i></button>
                <button name="profileBtn" onClick="" class="mx-2" type="button"><i class="fa-solid fa-user" style="color: #d2c9ff;;"></i></button>
                <cfif structKeyExists(session,"structUserDetails")>
                    <button name="logoutBtn" onClick="logoutUser()" type="button"><i class="fa-solid fa-arrow-right-to-bracket" style="color: #ccc2ff;"></i>Logout</button>
                <cfelse>
                    <a href="userLogin.cfm"><button name="loginBtn" onClick="" type="button"><i class="fa-solid fa-arrow-right-to-bracket" style="color: #ccc2ff;"></i>Login</button></a>
                </cfif>
            </div>  
        </header>
        <cfset subcategoryListing=local.objUserShoppingCart.selectDistinctSubCategory(url.categoryId)>
        <cfset productListing = local.objUserShoppingCart.selectAllProducts()>
        <div class="categoryMainContainer mt-2 px-2">
            <cfif NOT queryRecordCount(subcategoryListing)>
                <h1>No Products Found</h1>
            </cfif>
            <cfloop query="subcategoryListing"> 
                <div class="categorySubcontainer mt-2 px-3 py-2">
                    <cfoutput>
                        <div class="w-100">
                            <h3>#subcategoryListing.fldSubCategoryName#</h3>
                        </div>
                        <cfloop query="productListing">
                            <cfif subcategoryListing.fldSubCategory_ID EQ productListing.fldSubCategoryId>
                               <a href="userProduct?productId=#productListing.fldProduct_ID#" class="text-decoration-none">
                                   <div class="card p-2 my-3">
                                       <div class="productImageDiv">
                                           <img src="../Assets/productImages/#productListing.fldImageFileName#" class="card-img-top" alt="No Image Found" height="200" width="50">
                                       </div>
                                       <div class="card-body d-flex flex-column align-items-center">
                                           <h5 class="card-title">#productListing.fldProductName#</h5>
                                           <span class="fw-bold text-wrap ">#productListing.fldBrandName#</span>
                                           <span class="text-success fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>#productListing.fldPrice#</span>
                                       </div>
                                   </div>
                               </a>
                            </cfif>
                        </cfloop>
                    </cfoutput>
                </div>
                
            </cfloop>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>