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
        <cfinclude  template="userHeader.cfm">
        <cfset subcategoryListing=local.objUserShoppingCart.selectDistinctSubCategory(url.categoryId)>
        <cfset productListing = local.objUserShoppingCart.selectAllProducts()>
        <div class="categoryMainContainer mt-2 px-2">
            <cfif NOT queryRecordCount(subcategoryListing)>
                <h1>No Products Found</h1>
            </cfif>
            <cfloop query="subcategoryListing"> 
                <div class="categorySubcontainer  my-3 ps-5 pe-3 py-3">
                    <cfoutput>
                        <div class="w-100">
                            <a href="userSubCategory.cfm?subcategoryId=#subcategoryListing.fldSubCategory_ID#" class="text-decoration-none text-black"><h3>#subcategoryListing.fldSubCategoryName#</h3></a>
                        </div>
                        <cfset countVariable = 0>
                        <cfloop query="productListing">
                            <cfif countVariable LT 5>
                                <cfif subcategoryListing.fldSubCategory_ID EQ productListing.subcategoryId>
                                    <div class="card p-2 m-3">
                                        <a href="userProduct.cfm?productId=#productListing.productId#" class="text-decoration-none">
                                           <div class="productImageDiv">
                                               <img src="../Assets/productImages/#productListing.imageName#" class="card-img-top" alt="No Image Found" height="200" width="50">
                                           </div>
                                           <div class="card-body d-flex flex-column align-items-center">
                                               <h5 class="card-title text-truncate">#productListing.productName#</h5>
                                               <span class="fw-bold text-wrap ">#productListing.brandName#</span>
                                               <span class="price fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>#productListing.price#</span>
                                           </div>
                                        </a>
                                    </div>
                                   <cfset countVariable++>
                                </cfif>
                            </cfif>
                        </cfloop>
                    </cfoutput>
                </div>
            </cfloop>
        </div>
        <cfinclude  template="userFooter.cfm">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>