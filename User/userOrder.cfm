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
    <cfset variables.objUserShoppingCart = createObject("component","components/userShoppingCart")>
    <cfset variables.addressQuery = variables.objUserShoppingCart.selectAddress()>
    <cfif structKeyExists(url, "productId")>
        <cfset variables.productListing = variables.objUserShoppingCart.selectAllProducts(url.productId)>
    </cfif>
    <body>
        <cfinclude  template="userHeader.cfm">
        <div class="mainContainerOrder border border-danger p-3">
            <div class="subcontainerOrder p-2">

                <div class="innerSubcontainerOrder">
                    <div class="container1 p-2 my-2">
                        <div class="container1Heading px-5 py-3">
                            <h4>1.Delivery Address</h4>
                        </div>
                        <div class="container1Content p-3 d-flex justify-content-between">
                            <cfoutput>
                                <div class="addressPart">
                                    <div class="w-50 d-flex justify-content-between">
                                        <span class="fw-bold mx-2 text-nowrap" id="addressUserName">#variables.addressQuery.firstName# #variables.addressQuery.lastName#</span>
                                        <span class="fw-bold mx-2" id="addressUserPhoneNumber">#variables.addressQuery.phoneNumber#</span>
                                    </div>
                                    <div class="p-3">
                                        <span id="addressUserAddressline1">#variables.addressQuery.addressline1#,</span>
                                        <span id="addressUserAddressline2">#variables.addressQuery.addressline2#,</span>
                                        <span id="addressUserCity">#variables.addressQuery.city#,</span>
                                        <span id="addressUserState">#variables.addressQuery.state#</span>
                                    </div>
                                    <span class="ms-3" id="addressUserPincode">#variables.addressQuery.pincode#</span>
                                    <input type="hidden" id="addressIdHidden" name="selectedAddressId" value="#variables.addressQuery.addressId#">
                                </div>
                            </cfoutput>
                            <div class="btnPart">
                                <button data-bs-toggle="modal" data-bs-target="#modalChangeAddress">Change Address</button>
                            </div>
                        </div>
                    </div>

                    <div class="container2 p-2 my-2">
                        <div class="container2Heading px-5 py-3">
                            <h4>2.Product Information</h4>
                        </div>
                        <hr>
                        <cfset variables.totalPrice = 0>
                        <cfoutput>
                            <cfloop query="variables.productListing">
                                <div class="container2Content p-3 d-flex justify-content-between overflow-hidden">
                                    <div class="productImage">
                                        <img src="../Assets/productImages/#variables.productListing.imageName#" class="img-fluid rounded-3" alt="No image found">
                                    </div>
                                    <div class="productNameDesc d-flex flex-column justify-content-between">
                                        <div class="productName text-truncate">
                                            <span>#variables.productListing.productName#</span>
                                        </div>
                                        <div class="productDesc">
                                            <p class="w-100 ">#variables.productListing.productDesc#</p>
                                        </div>
                                    </div>
                                    <div class="productPrice">
                                        <span class="fw-bold fs-5"><i class="fa-solid fa-indian-rupee-sign"></i> #variables.productListing.price#</span><br>
                                        <span>Tax : <i class="fa-solid fa-indian-rupee-sign"></i> #variables.productListing.tax#</span>
                                    </div>
                                    <cfset variables.totalPrice = #variables.productListing.price# + #variables.productListing.tax#>
                                    <div class="productQty">
                                        <div class="d-flex">
                                            <button data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2" class="qtyDeleteBtn" id="#productListingCart.cartId#DeleteBtn" onclick="">
                                              <i class="fas fa-minus"></i>
                                            </button>
                                            <input id="" class="cartQuantity" min="0" name="quantity" value="1" type="text" class="form-control form-control-sm px-2"disabled/>
                                            <button data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2" onclick="">
                                              <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </cfoutput>
                        <hr>
                    </div>
                </div>
                <div class="paymentBtnContainer d-flex justify-content-between p-3">
                <cfoutput>
                    <span>Price : <i class="fa-solid fa-indian-rupee-sign"></i> #variables.totalPrice#</span>
                </cfoutput>
                    <button class><i class="fa-solid fa-money-check"></i> Continue to Payment</button>
                </div>

            </div>
        </div>
        <cfinclude  template="userFooter.cfm">

        <!-- Modal Change Address -->
        <div class="modalChangeAddress modal fade" id="modalChangeAddress" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">Select Address</h1>
                        <button type="button" class="btn-close bg-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="POST" id="formProfileEdit">
                        <div class="selectAddressModal modal-body px-5">
                            <cfset variables.flag = 0>
                            <cfoutput>
                                <cfloop query="variables.addressQuery">
                                    <div class="modalSingleAddress px-5 py-3 m-2 d-flex border justify-content-between" id="#variables.addressQuery.addressId#">
                                        <div class="modalInput me-4 d-flex flex-column justify-content-between pt-4">
                                            <input type="radio" name="selectedAddress" class="selectedAddress"
                                                id="#variables.addressQuery.addressId#Input"
                                                value="#variables.addressQuery.addressId#"
                                                <cfif variables.flag EQ 0>
                                                checked
                                                </cfif>
                                            >
                                            <cfset variables.flag++>
                                        </div>
                                        <div class="w-100 ms-3">
                                            <div class="d-flex justify-content-between">
                                                <span id="#variables.addressQuery.addressId#userName">#variables.addressQuery.firstName# #variables.addressQuery.lastName#</span>
                                                <span id="#variables.addressQuery.addressId#userPhoneNumber">#variables.addressQuery.phoneNumber#</span>
                                            </div>
                                            <div class="d-flex">
                                                <span id="#variables.addressQuery.addressId#addressline1">#variables.addressQuery.addressline1#,</span>
                                                <span id="#variables.addressQuery.addressId#addressline2">#variables.addressQuery.addressline2#,</span>
                                                <span id="#variables.addressQuery.addressId#city">#variables.addressQuery.city#,</span>
                                                <span id="#variables.addressQuery.addressId#state">#variables.addressQuery.state#</span>
                                            </div>
                                            <span id="#variables.addressQuery.addressId#pincode">#variables.addressQuery.pincode#</span>
                                        </div>
                                    </div>
                                </cfloop>
                            </cfoutput>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="">Close</button>
                            <button type="button" name="editProfileSubmitBtn" id="editProfileSubmitBtn" value=" " class="btn btn-primary" onclick="changeAddress()">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>    
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>