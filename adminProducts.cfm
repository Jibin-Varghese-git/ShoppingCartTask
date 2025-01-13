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
                    <cfoutput>
                    <span>Welcome #session.structUserDetails["firstName"]# #session.structUserDetails["lastName"]#</span>
                    </cfoutput>
                </div>
                <div class="logoutBtnClass">
                    <button name="logoutBtn" onClick="fnLogout()" type="submit"><img src="Assets/Images/logoutIcon.png" alt="No Image Found">Logout</button>
                </div>  
            </div>
        </header>
<!---     <cfset result=application.objShoppingCart.fnSelectSubCategory(subcategoryId=url.subcategoryId)>  --->
    <cfset subCategoryName=application.objShoppingCart.fnSelectSubcategoryDetails(subcategoryId=url.subcategoryId)>
        <div class="mainContentDivCategory p-5">
            <div class="categoryDiv my-3 py-2 px-3">
                <div class="categoryHeading p-2 d-flex justify-content-between my-2">
                    <cfoutput>
                        <a href="adminSubCategory.cfm?catId=#url.categoryId#"><span>#subCategoryName["subcategoryName"]#</span></a>
                        <button type="button" value="#url.subcategoryId#" onClick="(this)" data-bs-toggle="modal" data-bs-target="##modalAddProducts">Add New <img src="Assets/Images/sendIcon.png" alt="No Image Found" height="20" width="20"></button>
                    </cfoutput>
                </div>
                <div class="categoryListingDiv">
                    <cfoutput>
<!---                         <cfloop query=""> --->
                            <div class="singleItemCategory border borer-danger p-2 my-2 d-flex justify-content-between" id="##">
                                <span>##</span>
                                <div class="categoryButtons">
                                    <button type="button" class="editSubCategory" value="##" data-bs-toggle="modal" data-bs-target="##modalAddProducts" onClick="(this)"><img src="Assets/Images/editIcon2.png" alt="No Image Found" height="25" width="25"></button>
                                    <button type="button" class="deleteCategory" id="deleteCategory" onClick="fnDeleteSubCategory(this)" value="##"><img src="Assets/Images/deleteIcon2.png" alt="No Image Found" height="25" width="25"></button>
                                    <a href="adminProducts.cfm?subcategoryId=##"><img src="Assets/Images/sendIconGreen.png" alt="No Image Found" height="25" width="25"></a>
                                </div>
                            </div>
<!---                         </cfloop> --->
                    </cfoutput>
                </div>
            </div>
        </div>
           <div class="modal fade" id="modalAddProducts" tabindex="-1" aria-labelledby="static" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post">
                    <div class="modal-content  modalAddProducts d-flex  flex-column justify-content-between px-3 pt-4">
                        <div class="modalInputProducts border">
                            <div class="modalAddProductsHeading">
                                <span>Add Products</span>
                            </div>
                            <div class="modalAddProductsBody">
                                <form method="post">
                                    <cfset categoryListingValues=application.objShoppingCart.fnSelectCategory()> 
                                    <span class="my-2">Category</span>
                                    <select  class="w-100 my-2" name="CategoryListing" id="CategoryListing" onchange="fnGetCategory()">
                                        <cfoutput>
                                            <cfloop query="categoryListingValues"> 
                                                <option value="#categoryListingValues.fldCategory_ID#">#categoryListingValues.fldCategoryName#</option>
                                            </cfloop> 
                                        </cfoutput>
                                    </select>
                                    <cfset categoryListingValues=application.objShoppingCart.fnSelectCategory()> 
                                    <span class="my-2">Subcategory</span>
                                    <cfset subcategoryListing=application.objShoppingCart.fnSelectSubCategory(categoryId=url.categoryId)>
                                    <select  class="w-100 my-2" name="subcategoryListing" id="subcategoryListing" >
                                        <cfoutput>
                                            <cfloop collection="#subcategoryListing#"  item="item"> 
                                                <option value="#item#">#subcategoryListing[item]#</option>
                                            </cfloop> 
                                        </cfoutput>
                                    </select>
                                    <span class="my-2">Product Name</span>
                                    <input type="text" class="productName mt-2 w-100" id="productName"><br>
                                    <span id="errorProductName" class="text-danger fw-bold fs-6"></span><br>
                                    <span class="my-2">Product Brand</span>
                                    <cfset brandListing=application.objShoppingCart.fnSelectBrand()>
                                    <select  class="w-100 my-2" name="brandListing" id="brandListing" >
                                        <cfoutput>
                                            <cfloop query="brandListing"> 
                                                <option value="#brandListing.fldBrand_ID#">#brandListing.fldBrandName#</option>
                                            </cfloop> 
                                        </cfoutput>
                                    </select>
                                    <span class="my-2">Product Description</span>
                                    <input type="text" class="productDescription mt-2 w-100" id="productDescription"><br>
                                    <span id="errorProductDescription" class="text-danger fw-bold fs-6"></span><br>
                                    <span class="my-2">Product Price</span>
                                    <input type="text" class="productPrice mt-2 w-100" id="productPrice"><br>
                                    <span id="errorProductPrice" class="text-danger fw-bold fs-6"></span><br>
                                    <span class="my-2">Product Tax</span>
                                    <input type="text" class="productTax mt-2 w-100" id="productTax"><br>
                                    <span id="errorProductTax" class="text-danger fw-bold fs-6"></span><br>
                                    <span class="my-2">Product Image</span>
                                    <input type="file" class="productImage mt-2 w-100" id="productImage" multiple><br>
                                    <span id="errorProductImage" class="text-danger fw-bold fs-6"></span><br>
                                </form>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <cfoutput>
                                <button type="button" class="btnModalClose p-2" onClick="()"  data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btnAddProducts  p-2" value="" id="btnAddProducts" onClick="fnProductModalValidation(this)">Edit Subcategory</button>
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
        <script src="js/script.js"></script>
    </body>
</html>