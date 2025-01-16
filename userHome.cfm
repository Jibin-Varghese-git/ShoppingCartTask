<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/userSignin.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <cfset local.objUserShoppingCart = createObject("component","components/userShoppingCart")>
        <header class="py-2 px-3 d-flex justify-content-between align-item-center">
            <a href="" class="d-flex"> 
                <div class="headerImageDiv">
                    <img src="Assets/Images/iconCartUser.png" alt="No Image Found">
                </div>
                <h5 class="logoHeading ms-1 mt-3">E-CART</h5>
            </a>
            <div class="loginBtnClass mt-1">
                <button name="loginBtn" onClick="fnUserLogout()" type="button"><i class="fa-solid fa-arrow-right-to-bracket" style="color: #ccc2ff;"></i>Logout</button>
            </div>  
        </header>
        <div class="mainContainer px-2">
            <div class="categoryListingHeader mt-2 p-2">
                <cfset structCategoryListing = local.objUserShoppingCart.selectCategory()>
                <cfoutput>
                    <cfloop collection="#structCategoryListing#" item="categoryId">
                        <button type="button" class="categoryBtn" value="#categoryId#">#structCategoryListing[categoryId]#</button>
                    </cfloop>
                </cfoutput>
            </div>
            <div class="homeImage mt-3">
                <img src="Assets/Images/homeImage3.webp">
            </div>
<!-- Product Listing  -->
            <div class="productListingContainer bg-white my-3 p-3">
                <div class="productListingSubContainer">
                    <cfset qryRandomProducts = local.objUserShoppingCart.selectRandomProducts()>

                    <cfoutput>
                        <cfloop query="qryRandomProducts">
                            <div class="card p-2 my-3">
                                <div class="productImageDiv">
                                    <img src="Assets/productImages/#qryRandomProducts.fldImageFileName#" class="card-img-top" alt="No Image Found" height="200" width="50">
                                </div>
                                <div class="card-body d-flex flex-column align-items-center">
                                    <h5 class="card-title">#qryRandomProducts.fldProductName#</h5>
                                    <span class="fw-bold text-wrap ">#qryRandomProducts.fldBrandName#</span>
                                    <span class="text-success fw-bold">Rs:#qryRandomProducts.fldPrice#</span>
                                    <div class="productListingBtns w-100 d-flex flex-column align-items-center">
                                        <button class="cartBtn w-50 p-2 my-1" value="#qryRandomProducts.fldProduct_ID#">Add to Cart</button>
                                        <button class="buyBtn w-50 p-2 mt-1" value="#qryRandomProducts.fldProduct_ID#">Buy Now</button>
                                    </div>
                                </div>
                            </div>
                     </cfloop>
                    </cfoutput>
                    
                </div>
            </div>

        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="js/userScript.js" async defer></script>
    </body>
</html>