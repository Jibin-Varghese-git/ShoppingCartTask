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
        <div class="mainContainer px-2">
            <div class="categoryListingHeader mt-2 p-2">
                <cfset structCategoryListing = local.objUserShoppingCart.selectCategory()>
                <cfset subCategoryListing = local.objUserShoppingCart.selectSubcategory()>
                <cfoutput>
                    <cfloop collection="#structCategoryListing#" item="categoryId">
                        <div class="subcategoryTooltip">
                            <a href="userCategory.cfm?categoryId=#categoryId#"><button type="button" class="categoryBtn" value="#categoryId#">#structCategoryListing[categoryId]#</button>
                            <div class="tooltipContainer d-flex flex-column justify-content-between p-1">
                                <cfloop query="subCategoryListing">
                                    <cfif subCategoryListing.fldCategoryId EQ categoryId>
                                        <a href="userSubcategory.cfm?subcategoryId=#subCategoryListing.fldSubCategory_ID#" class="text-decoration-none"><div class="tooltiptext p-1 mt-1">#subCategoryListing.fldSubCategoryName#</div></a>
                                    </cfif>
                                </cfloop>
                            </div>
                        </div>
                    </cfloop>
                </cfoutput>
            </div>
            <div class="homeImage mt-3">
                <div id="carouselExampleAutoplaying" class="carousel slide w-100" data-bs-ride="carousel">
                    <div class="carousel-inner">
                      <div class="carousel-item active">
                        <img src="../Assets/Images/homeImage3.webp" class="d-block w-100" alt="...">
                      </div>
                      <div class="carousel-item">
                        <img src="../Assets/Images/homeImage4.webp" class="d-block w-100" alt="...">
                      </div>
                      <div class="carousel-item">
                        <img src="../Assets/Images/homeImage7.jpg" class="d-block w-100" alt="...">
                      </div>
                      <div class="carousel-item">
                        <img src="../Assets/Images/homeImage8.jpg" class="d-block w-100" alt="...">
                      </div>
                      <div class="carousel-item">
                        <img src="../Assets/Images/homeImage9.jpg" class="d-block w-100" alt="...">
                      </div>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="prev">
                      <span class="carousel-control-prev-icon bg-secondary" aria-hidden="true"></span>
                      <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="next">
                      <span class="carousel-control-next-icon bg-secondary" aria-hidden="true"></span>
                      <span class="visually-hidden">Next</span>
                    </button>
                <div>
            </div>
<!-- Product Listing  -->
            <div class="productListingContainer bg-white  my-3 ps-5 pe-3 py-3">
                <div class="productListingSubContainer">
                    <cfset qryRandomProducts = local.objUserShoppingCart.selectRandomProducts()>
                    <cfoutput>
                         <div class="w-100">
                            <h3>Random Products</h3>
                        </div>
                        <cfloop query="qryRandomProducts">
                            <div class="card p-2 m-3">
                                <a href="userProduct.cfm?productId=#qryRandomProducts.fldProduct_ID#" class="text-decoration-none">
                                    <div class="productImageDiv">
                                        <img src="../Assets/productImages/#qryRandomProducts.fldImageFileName#" class="card-img-top" alt="No Image Found" height="200" width="50">
                                    </div>
                                    <div class="card-body d-flex flex-column align-items-center">
                                        <h5 class="card-title text-truncate">#qryRandomProducts.fldProductName#</h5>
                                        <span class="fw-bold text-wrap ">#qryRandomProducts.fldBrandName#</span>
                                        <span class="productPrice fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>#qryRandomProducts.fldPrice#</span>
                                    </div>
                                </a>
                            </div>
                     </cfloop>
                    </cfoutput>
                </div>
            </div>
        </div>
        <cfinclude  template="userFooter.cfm"></cfinclude>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>