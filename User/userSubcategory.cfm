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
        <cfif structKeyExists(url, "search") && structKeyExists(url, "sort")>
            <cfset subcategoryProductsListing=local.objUserShoppingCart.selectSubcategoryProducts(sort=url.sort,search=url.search)>
        <cfelseif  structKeyExists(url, "search")>
            <cfset subcategoryProductsListing=local.objUserShoppingCart.selectSubcategoryProducts(search=url.search)>
        <cfelseif structKeyExists(url, "sort") && structKeyExists(url, "subCategoryId")>
             <cfset subcategoryProductsListing=local.objUserShoppingCart.selectSubcategoryProducts(subcategoryId=url.subCategoryId,sort=url.sort)>
        <cfelse>
            <cfset subcategoryProductsListing=local.objUserShoppingCart.selectSubcategoryProducts(subcategoryId=url.subCategoryId)>
        </cfif>
        <div class="categoryMainContainer mt-2 px-2">
            <div class="categorySubcontainer mt-2 px-3 py-2" id="categorySubcontainer">
                <cfoutput>
                    <div class="w-100 px-2">
                       <cfif NOT queryRecordCount(subcategoryProductsListing)>
                            <h1>No Products Found</h1>
                        <cfelse>
                            <cfif structKeyExists(url, "search")>
                                <h3>Search Results for #url.search# </h3>
                            <cfelse>
                                <h3>#subcategoryProductsListing.subcategoryName#</h3>
                            </cfif>
                            <div class="d-flex justify-content-between px-2">
                                <div class="d-flex">
                                    <a class="text-decoration-none me-2" href="userSubcategory.cfm?<cfif structKeyExists(url, "subCategoryId")>subCategoryId=#url.subCategoryId#<cfelse>search=#url.search#</cfif>&sort=asc">Price:Low to High</a>
                                    <a class="text-decoration-none me-2" href="userSubcategory.cfm?<cfif structKeyExists(url, "subCategoryId")>subCategoryId=#url.subCategoryId#<cfelse>search=#url.search#</cfif>&sort=desc">Price:High to Low</a>
                                </div>
                                <div class="dropdown">
                                    <button class="btn btn-secondary" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fa-solid fa-arrow-down-short-wide"></i> Filter
                                    </button>
                                    <ul class="dropdown-menu p-2">
                                     <li><input type="radio" class="me-2" name="filter" id="filter1"><label>0-1000</label></li>
                                     <li><input type="radio" class="me-2" name="filter" id="filter2"><label>1000-10000</label></li>
                                     <li><input type="radio" class="me-2" name="filter" id="filter3"><label>10000-20000</label></li>
                                     <li><hr class="dropdown-divider"></li>
                                     <li><label>Min</label><input type="number" class="me-2" name="filter" id="filterMin"></li>
                                     <li><label>Max</label><input type="number" class="me-2" name="filter" id="filterMax"></li>
                                     <li><hr class="dropdown-divider"></li>
                                    <li><button class="dropdown-item" onclick="filterPrice({<cfif structKeyExists(url, "subCategoryId")>
                                                                                                subcategoryId:#url.subcategoryId#
                                                                                            <cfelse>
                                                                                                search:'#url.search#'
                                                                                            </cfif>
                                                                                            })" id="filterPrice">Submit</button></li>
                                    </ul>
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="productContainer d-flex flex-wrap  my-3 ps-5 pe-3 py-3 w-100" id="productContainer">
                        <cfloop query="subcategoryProductsListing">
                            <a href="userProduct.cfm?productId=#subcategoryProductsListing.productId#" class="text-decoration-none">
                                <div class="card p-2 m-3">
                                    <div class="productImageDiv">
                                        <img src="../Assets/productImages/#subcategoryProductsListing.productImage#" class="card-img-top" alt="No Image Found" height="200" width="50">
                                    </div>
                                    <div class="card-body d-flex flex-column align-items-center">
                                        <h5 class="card-title">#subcategoryProductsListing.productName#</h5>
                                        <span class="fw-bold text-wrap ">#subcategoryProductsListing.brandName#</span>
                                        <span class="text-success fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>#subcategoryProductsListing.productPrice#</span>
                                    </div>
                                </div>
                            </a>
                        </cfloop>
                    </div>
                </cfoutput>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>