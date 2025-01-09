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

        <div class="mainContentDivCategory p-5">
            <div class="categoryDiv my-3 py-2 px-3">
                <div class="categoryHeading p-2 d-flex justify-content-between">
                    <span>Category</span>
                    <button type="button" data-bs-toggle="modal" data-bs-target="#modalAddCategory">Add New <img src="Assets/Images/sendIcon.png" alt="No Image Found" height="20" width="20"></button>
                </div>
            </div>
        </div>
        <div class="modal fade" id="modalAddCategory" tabindex="-1" aria-labelledby="static" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content d-flex  flex-column justify-content-between px-3 pt-4">
                    <div class="modalInputCategory">
                        <input type="text" class="modalCategoryName mt-4 w-100"><br>
                        <span class="ms-5">Category Name</span>
                    </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                      <button type="button" class="btn btn-primary">Save changes</button>
                    </div>
              </div>
            </div>
          </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="js/script.js"></script>
    </body>
</html>