<!DOCTYPE html>
<html>
    <head>
        <title>ADMIN LOGIN</title>
        <link rel="stylesheet" href="../bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        
        <header class="p-2">
            <div class="headerDiv p-1 d-flex  justify-content-between">
                <div class="headerCartName">
                    <a href="" class="d-flex"> 
                        <div class="headerImageDiv">
                            <img src="../Assets/Images/shoppingCart_icon2.png" alt="No Image Found">
                        </div>
                        <h5 class="color-white ms-2 mt-2">E-CART</h5>
                    </a>
                </div>
                <div class="headerHeadingDiv">
                    <cfoutput>
                    <span>Welcome #session.structUserDetails["firstName"]# #session.structUserDetails["lastName"]#</span>
                    </cfoutput>
                </div>
                <div class="logoutBtnClass">
                <a href="../User/userHome.cfm" class="userHomePageAdminBtn btn">User Home Page</a>
                    <button name="logoutBtn" onClick="fnLogout()" type="submit"><img src="../Assets/Images/logoutIcon.png" alt="No Image Found">Logout</button>
                </div>  
            </div>
        </header>
        <cfset variables.ProductListing=application.objShoppingCart.fnSelectProduct(subcategoryId=url.subcategoryId)>
        <cfset variables.subCategoryName=application.objShoppingCart.fnSelectSubcategoryDetails(subcategoryId=url.subcategoryId)>
        <div class="mainContentDivProduct p-5">
            <div class="productDiv my-3 py-2 px-3">
                <div class="categoryHeading p-2 d-flex justify-content-between my-2">
                    <cfoutput>
                        <div class="backBtnProductdiv m-2">
                            <a href="adminSubCategory.cfm?catId=#url.categoryId#"><span><i class="fa-solid fa-backward"></i> #variables.subCategoryName["subcategoryName"]#</span></a>
                            <span class="tooltiptext">Back</span>
                        </div>
                        <button type="button" value="#url.subcategoryId#" onClick="openProductModal({categoryId:#url.categoryId#,subcategoryId:#url.subcategoryId#})" data-bs-toggle="modal" data-bs-target="##modalAddProducts">Add New <img src="../Assets/Images/sendIcon.png" alt="No Image Found" height="20" width="20"></button>
                    </cfoutput>
                </div>
                <div class="productListingDiv">
                    <cfoutput>
                        <cfloop query="variables.ProductListing">
                            <div class="singleItemCategory  p-2 my-2 d-flex justify-content-between " id="#variables.ProductListing.fldProduct_ID#">
                                <cfset imagePath = "../Assets/productImages/">
                                <button type="button" class="productThumbNail" onclick="fnImageModal({productId:#variables.ProductListing.fldProduct_ID#})" data-bs-toggle="modal" data-bs-target="##modalImageShow"><img src="#imagePath##variables.ProductListing.fldImageFileName#" alt="Image Not Found"></button>
                                <div class="productNameDiv text-truncate">
                                    <span class="text-nowrap">#variables.ProductListing.fldProductName#</span><br>
                                    <span class="fs-6">#variables.ProductListing.fldBrandName#</span><br>
                                    <span class="fw-bold fs-5">Price : <i class="fa-solid fa-indian-rupee-sign"></i> #variables.ProductListing.fldPrice#</span>
                                </div>
                                <div class="categoryButtons d-flex flex-column">
                                    <div class="editBtnProductdiv m-2">
                                        <button type="button" class="editProduct" value="#variables.ProductListing.fldProduct_ID#" data-bs-toggle="modal" data-bs-target="##modalAddProducts" onClick="fnEditProductModal({categoryId:#url.categoryId#,subcategoryId:#url.subcategoryId#,productId:#variables.ProductListing.fldProduct_ID#})"><img src="../Assets/Images/editIcon2.png" alt="No Image Found" height="30" width="30"></button>
                                        <span class="tooltiptext">Edit</span>
                                    </div>
                                    <div class="deleteBtnProductdiv m-2">
                                        <button type="button" class="deleteProduct" id="deleteCategory" onClick="fnDeleteProduct(this)" value="#variables.ProductListing.fldProduct_ID#"><img src="../Assets/Images/deleteIcon2.png" alt="No Image Found" height="30" width="30  "></button>
                                        <span class="tooltiptext">Delete</span>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    </cfoutput>
                </div>
            </div>
        </div>
        <div class="modal fade" id="modalImageShow" tabindex="-1" aria-labelledby="static" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post">
                    <div class="modal-content imageView d-flex  flex-column justify-content-between  px-5 pt-3">
                        <div class="">
                            <div id="carouselExample" class="carousel  carousel-dark slide">
                                <div class="carousel-inner carouselImageView p-2" id="carouselInner">
                                </div>
                                <button class="carousel-control-prev"  type="button" data-bs-target="#carouselExample" data-bs-slide="prev">
                                  <span class="carousel-control-prev-icon btn btn-dark" aria-hidden="true"></span>
                                  <span class="visually-hidden">Previous</span>
                                </button>
                                <button class="carousel-control-next" type="button" data-bs-target="#carouselExample" data-bs-slide="next">
                                  <span class="carousel-control-next-icon btn btn-dark" aria-hidden="true"></span>
                                  <span class="visually-hidden">Next</span>
                                </button>
                            </div>
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btnModalClose p-2" onClick=""  data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </form>
            </div>
          </div>
        <div class="modal fade" id="modalAddProducts" tabindex="-1" aria-labelledby="static" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" id="productForm"  enctype="multipart/form-data">
                    <div class="modal-content  modalAddProducts d-flex  flex-column justify-content-between px-3 pt-4">
                        <div class="modalInputProducts">
                            <div class="modalAddProductsHeading">
                                <span id="modalAddProductsHeading">Add Product</span>
                            </div>
                            <div class="modalAddProductsBody">
                                    <cfset variables.categoryListingValues=application.objShoppingCart.fnSelectCategoryName()> 
                                    <span class="my-2">Category</span>
                                    <select  class="w-100 my-2" name="CategoryListing" id="CategoryListing" onchange="fnGetCategory()">
                                        <cfoutput>
                                            <cfloop query="variables.categoryListingValues"> 
                                                <option value="#variables.categoryListingValues.fldCategory_ID#">#variables.categoryListingValues.fldCategoryName#</option>
                                            </cfloop> 
                                        </cfoutput>
                                    </select>
                                    
                                    <span class="my-2">Subcategory</span>
                                    <cfset variables.subcategoryListing=application.objShoppingCart.fnSelectSubCategory(categoryId=url.categoryId)>
                                    <select  class="w-100 my-2" name="subcategoryListing" id="subcategoryListing" >
                                        <cfoutput>
                                            <cfloop collection="#variables.subcategoryListing#"  item="item"> 
                                                <option value="#item#">#variables.subcategoryListing[item]#</option>
                                            </cfloop> 
                                        </cfoutput>
                                    </select>
                                    <span class="my-2">Product Name</span>
                                    <input type="text" class="productName mt-2 w-100" name="productName" id="productName"><br>
                                    <span id="errorProductName" class="text-danger fw-bold fs-6"></span><br>
                                    <span class="my-2">Product Brand</span>
                                    <cfset variables.brandListing=application.objShoppingCart.fnSelectBrand()>
                                    <select  class="w-100 my-2" name="brandListing" id="brandListing" >
                                        <cfoutput>
                                            <cfloop query="variables.brandListing"> 
                                                <option value="#variables.brandListing.fldBrand_ID#">#variables.brandListing.fldBrandName#</option>
                                            </cfloop> 
                                        </cfoutput>
                                    </select>
                                    <span class="my-2">Product Description</span>
                                    <input type="text" class="productDescription mt-2 w-100" name="productDescription" id="productDescription"><br>
                                    <span id="errorProductDescription" class="text-danger fw-bold fs-6"></span><br>
                                    <span class="my-2">Product Price</span>
                                    <input type="number" step="0.01" class="productPrice mt-2 w-100" name="productPrice" id="productPrice"><br>
                                    <span id="errorProductPrice" class="text-danger fw-bold fs-6"></span><br>
                                    <span class="my-2">Product Tax</span>
                                    <input type="number" step="0.01" class="productTax mt-2 w-100" name="productTax" id="productTax"><br>
                                    <span id="errorProductTax" class="text-danger fw-bold fs-6"></span><br>
                                    <span class="my-2">Product Image</span>
                                    <input type="file" class="productImage mt-2 w-100" name="productImages" id="productImages" multiple><br>
                                    <span id="errorProductImage" class="text-danger fw-bold fs-6"></span><br>
                                    <input type="hidden" name="hiddenProductId"  value=" " id="hiddenProductId">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <cfoutput>
                                <button type="button" class="btnModalClose p-2" onClick="fnCloseProduct()"  data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btnAddProducts  p-2" value="" onclick="fnProductModalValidation()" id="btnAddProducts">Add Product</button>
                            </cfoutput>
                        </div>
                    </div>
                </form>
            </div>
          </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/script.js"></script>
    </body>
</html>