<!DOCTYPE html>
<html>
    <head>
        <title>ADMIN LOGIN</title>
        <link rel="stylesheet" href="../bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <cfset local.objShoppingCart = createObject("component", "components.shoppingCart")>
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
                    <button name="logoutBtn" onClick="fnLogout()" type="submit"><img src="../Assets/Images/logoutIcon.png" alt="No Image Found">Logout</button>
                </div>  
            </div>
        </header>
    <cfset result=local.objShoppingCart.fnSelectSubCategory(categoryId=url.catId)> 
    <cfset CategoryName=local.objShoppingCart.fnSelectCategoryName(categoryId=url.catId)>
        <div class="mainContentDivCategory p-5">
            <div class="categoryDiv my-3 py-2 px-3">
                <div class="categoryHeading p-2 d-flex justify-content-between my-2">
                    <cfoutput>
                        <div class="backBtnProductdiv m-2">
                            <a href="adminCategory.cfm"><span><i class="fa-solid fa-backward"></i> #CategoryName#</span></a>
                            <span class="tooltiptext">Back</span>
                        </div>
                        <button type="button" value="#url.catId#" onClick="fnModalAddSubCategory(this)" data-bs-toggle="modal" data-bs-target="##modalAddSubCategory">Add New <img src="../Assets/Images/sendIcon.png" alt="No Image Found" height="20" width="20"></button>
                    </cfoutput>
                </div>
                <div class="categoryListingDiv">
                    <cfoutput>
                        <cfloop collection="#result#" item="item">
                            <div class="singleItemCategory border borer-danger p-2 my-2 d-flex justify-content-between" id="#item#">
                                <span>#result[item]#</span>
                                <div class="categoryButtons">
                                    <div class="editBtnSubCatdiv">
                                        <button type="button" class="editSubCategory" value="#item#" data-bs-toggle="modal" data-bs-target="##modalAddSubCategory" onClick="fnModalEditSubCategory(this)"><img src="../Assets/Images/editIcon2.png" alt="No Image Found" height="25" width="25"></button>
                                        <span class="tooltiptext">Edit</span>
                                    </div>
                                    <div class="deleteBtnSubCatdiv">
                                        <button type="button" class="deleteSubCategory" id="deleteSubCategory" onClick="fnDeleteSubCategory(this)" value="#item#"><img src="../Assets/Images/deleteIcon2.png" alt="No Image Found" height="25" width="25"></button>
                                        <span class="tooltiptext">delete</span>
                                    </div>
                                    <div class="forwardBtnSubCatdiv">
                                        <a href="adminProducts.cfm?categoryId=#url.catId#&subcategoryId=#item#"><img src="../Assets/Images/sendIconGreen.png" alt="No Image Found" height="25" width="25"></a>
                                    <span class="tooltiptext">Product</span>
                                    </div>
                                </div>
                            </div>
                        </cfloop>
                    </cfoutput>
                </div>
            </div>
        </div>
           <div class="modal fade" id="modalAddSubCategory" tabindex="-1" aria-labelledby="static" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post">
                    <div class="modal-content modalSubcategory d-flex  flex-column justify-content-between px-3 pt-4">
                        <div class="modalInputCategory">
                            <cfset categoryListingValues=local.objShoppingCart.fnSelectCategory()>
                            <span class="ms-5 my-2" id="categoryListingHeading">Category</span><br>
                            <select class="w-100 my-2" name="categoryListing" id="categoryListing">
                                <cfoutput>
                                    <cfloop query="categoryListingValues">
                                        <option value="#categoryListingValues.fldCategory_ID#">#categoryListingValues.fldCategoryName#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>
                            <input type="text" class="newSubcategoryName mt-4 w-100" id="newSubcategoryName"><br>
                            <span id="errorNewSubcategory" class="text-danger fw-bold fs-6"></span><br>
                            <span class="ms-5" id="subcategoryModalHeading">Edit Subcategory</span>
                        </div>
                        <div class="modal-footer">
                            <cfoutput>
                                <button type="button" class="btnModalClose p-2" onClick="fnCloseModalSubCategory()"  data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btnAddSubcategory  p-2" value="" id="btnAddSubcategory" onClick="fnAddSubcategory(this)">Edit Subcategory</button>
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