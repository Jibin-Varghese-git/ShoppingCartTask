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
        <cfset productListing=local.objUserShoppingCart.selectAllProducts(url.productId)>
        <cfset productImageListing = local.objUserShoppingCart.selectProductImages(url.productId)>  
        <div class="categoryMainContainer mt-2 px-2">
            <cfif NOT queryRecordCount(productListing)>
                <h1>No Products Found</h1>
            <cfelse>
                <div class="productSubContainer mt-2 px-3 py-2" id="productSubContainer">

                    <div class="imageContainer p-2">
                        <div id="carouselExampleRide" class="carousel slide" data-bs-ride="carousel">
                            <div class="carousel-inner">
                                <cfloop query="productImageListing">
                                    <cfoutput>
                                        <cfif productImageListing.defaultImage EQ 1>
                                            <div class="carousel-item active">
                                        <cfelse>
                                            <div class="carousel-item">
                                        </cfif>
                                            <img src="../Assets/productImages/#productImageListing.productImage#" class="d-block w-100" alt="...">
                                        </div>
                                    </cfoutput>
                                </cfloop>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleRide" data-bs-slide="prev">
                              <span class="carousel-control-prev-icon bg-secondary" aria-hidden="true"></span>
                              <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleRide" data-bs-slide="next">
                              <span class="carousel-control-next-icon bg-secondary" aria-hidden="true"></span>
                              <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    </div>

                    <cfoutput>
                        <div class="productDetails p-2">
                            <div class="pathOfProduct d-flex">
                                <a href="userCategory.cfm?categoryId=#productListing.categoryId#" class="mx-2"><span>#productListing.categoryName#</span></a>
                                <span><i class="fa-solid fa-chevron-right"></i></span>
                                <a href="userSubcategory.cfm?subcategoryId=#productListing.subcategoryId#" class="mx-2"><span>#productListing.subcategoryName#</span></a>
                                <span><i class="fa-solid fa-chevron-right"></i></span>
                                <span class="ms-2">#productListing.productName#</span>
                            </div>
                            <div class="productName w-100 d-flex justify-content-center">
                                <div><h2>#productListing.productName#</h2></div>
                            </div>
                            <div class="productDesc">
                                <div><h6 class="w-100">#productListing.productDesc#</h6></div>
                            </div>
                            <div class="productPrice w-100 overflow-hidden ">
                                <div class="d-flex w-100 m-2"><h5><i class="fa-solid fa-indian-rupee-sign"></i> #productListing.price# <sub>+#productListing.tax#(tax)</sub></h5></div>
                                <div class="ms-2 mt-4"><h4>Total Price : <i class="fa-solid fa-indian-rupee-sign"></i> #productListing.price + productListing.tax#</h4></div>
                            </div>
                            <div class="productListingBtns w-100 d-flex flex-column align-items-center">
                                <button class="cartBtn w-50 p-2 my-1" value="">Add to Cart</button>
                                <button class="buyBtn w-50 p-2 mt-1" value="">Buy Now</button>
                            </div>
                        </div>
                    </cfoutput>
                </div>
            </cfif>
<!---    Random product listing          --->
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
                                        <span class="price fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>#qryRandomProducts.fldPrice#</span>
                                    </div>
                                </a>
                            </div>
                     </cfloop>
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