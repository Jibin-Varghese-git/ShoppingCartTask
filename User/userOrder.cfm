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
     <cfif structKeyExists(form, "addAddressBtn")>
            <cfset variables.result = variables.objUserShoppingCart.addAddress(form)>
    </cfif>
    <cfset variables.addressQuery = variables.objUserShoppingCart.selectAddress()>
    <cfif structKeyExists(url, "productId")>
        <cfset variables.productListing = variables.objUserShoppingCart.selectAllProducts(url.productId)>
    <cfelseif structKeyExists(url, "redirected") AND url.redirected EQ "cart">
        <cfset variables.productListing = variables.objUserShoppingCart.selectProductCart()>
    <cfelse>
        <cflocation  url="userHome.cfm">
    </cfif>
    <body>
        <cfinclude  template="userHeader.cfm">
        <div class="mainContainerOrder p-3">
            <form method="POST">
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
                            <div class="btnPart d-flex flex-column justify-content-between">
                                <button type="button" class="changeAddressBtn" data-bs-toggle="modal" data-bs-target="#modalChangeAddress">Change Address</button>
                                <button type="button" class="addAddressBtn" data-bs-toggle="modal"  data-bs-target="#modalAddAddress"><i class="fa-solid fa-plus"></i> Add Address</button>
                            </div>
                        </div>
                    </div>

                    <div class="container2 p-2 my-2">
                        <div class="container2Heading px-5 py-3">
                            <h4>2.Product Information</h4>
                        </div>
                        <cfset variables.totalProductPrice = 0>
                        <cfset variables.totalProductTax = 0>
                        <cfoutput>
                            <cfloop query="variables.productListing">
                                <hr>
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
                                        <div>
                                            <span><i class="fa-solid fa-indian-rupee-sign"></i></span>
                                            <span class="fw-bold fs-5">#variables.productListing.price#</span><br>
                                        </div>
                                        <div>
                                            <span>Tax : <i class="fa-solid fa-indian-rupee-sign"></i></span>
                                            <span>#variables.productListing.tax#</span>
                                        </div>
                                    </div>
                                    <div class="productQty">
                                        <div class="d-flex">
                                            <cfif NOT structKeyExists(variables.productListing, "productQuantity")>
                                                <cfset variables.totalProductPrice = variables.totalProductPrice + variables.productListing.price>
                                                <cfset variables.totalProductTax = variables.totalProductTax + variables.productListing.tax>
                                                <button type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2 qtyDeleteBtnOrder" id="#productListing.productId#deleteBtn" onclick="deleteQtyOrder(#productListing.productId#)">
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                            <cfelse>
                                                <cfset variables.totalProductPrice = variables.totalProductPrice + (variables.productListing.price * variables.productListing.productQuantity)>
                                                <cfset variables.totalProductTax = variables.totalProductTax + (variables.productListing.tax * variables.productListing.productQuantity)>
                                                <span class="me-2">Quantity : </span>
                                            </cfif>
                                            <input id="#productListing.productId#Input" class="orderQuantity"  min="0" name="orderQuantity" 
                                                value=
                                                    <cfif structKeyExists(variables.productListing, "productQuantity")>
                                                        #variables.productListing.productQuantity#
                                                    <cfelse>
                                                        1
                                                    </cfif>
                                                type="text" class="form-control form-control-sm px-2"readonly
                                             />
                                            <cfif NOT structKeyExists(variables.productListing, "productQuantity")>
                                                <button type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2 qtyAddBtnOrder" id="#productListing.productId#addBtn" onclick="addQtyOrder(#productListing.productId#)">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </cfoutput>
                        <hr>
                    </div>
                    <div class="container2 p-2 my-2">
                        <div class="container2Heading px-5 py-3">
                            <h4>3.Order Summary</h4>
                        </div>
                        <cfoutput>
                            <div class="container2Content p-3 d-flex flex-column justify-content-between " id="summaryContainer">
                                <div class=" w-50 d-flex justify-content-between">
                                    <span>Product Price  : </span>
                                    <div>
                                        <span><i class="fa-solid fa-indian-rupee-sign"></i></span>
                                        <span class="totalProductPrice" id="totalProductPrice">#variables.totalProductPrice#</span>
                                    </div>
                                </div>
                                <div class=" w-50 d-flex justify-content-between">
                                    <span>Product Tax: </span>
                                    <div>
                                        <span><i class="fa-solid fa-indian-rupee-sign"></i></span>
                                        <span class="totalProductTax" id="totalProductTax">#variables.totalProductTax#</span>
                                    </div>
                                </div>
                                <hr>
                                <div class=" w-50 d-flex justify-content-between">
                                    <span>Total Price: </span>
                                    <div>
                                        <span><i class="fa-solid fa-indian-rupee-sign"></i></span>
                                        <span class="totalPrice" id="totalPrice">#variables.totalProductPrice + variables.totalProductTax#</span>
                                    </div>
                                </div>
                            </div>
                        </cfoutput>
                    </div>
                    <div class="container2 p-2 my-2">
                        <div class="container2Heading px-5 py-3">
                            <h4>4.Verify Card</h4>
                        </div>
                        <div class="d-flex justify-content-center p-4">
                            <button id="verifyCardBtn" type="button" data-bs-toggle="modal"  data-bs-target="#modalCreditCard">
                                <div class="cardImage">
                                    <img src="../Assets/Images/icons8-credit-card.gif" alt="No image Found">
                                </div>
                                <span>Verify Card</span>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="paymentBtnContainer d-flex justify-content-between p-3">
                    <cfoutput>
                        <div>
                            <input type="hidden" name="totalPriceHidden" id="totalPriceHidden" value="#variables.totalProductPrice#">
                            <input type="hidden" name="totalTaxHidden" id="totalTaxHidden" value="#variables.totalProductTax    #">
                            <span>Total Price : <i class="fa-solid fa-indian-rupee-sign"></i></span>
                            <span id="totalPriceBtn" name="totalPriceBtn">#variables.totalProductTax + variables.totalProductPrice#</span>
                        </div>
                    </cfoutput>
                    <cfif queryRecordCount(variables.addressQuery)>
                        <button type="submit" name="continuePayBtn" id="continuePayBtn" value="111" ><i class="fa-solid fa-wallet"></i> Continue to Payment</button>
                    <cfelse>
                        <span class="text-Danger fw-bold">ADD ADDRESS</span>
                    </cfif>
                </div>
            </div>

            <cfif structKeyExists(url, "productId")>
                <cfoutput>
                    <input type="hidden" name="productIdHidden" value="#url.productId#">
                </cfoutput>
            </cfif>

            <cfif structKeyExists(form, "continuePayBtn")>
                <cfif structKeyExists(url, "productId")>
                    <cfset variables.result=variables.objUserShoppingCart.addOrderItems(form)>
                <cfelseif structKeyExists(url, "redirected") AND url.redirected EQ "cart">
                    <cfset variables.result=variables.objUserShoppingCart.cartToOrder(form)>
                </cfif>
            </cfif>
            </form>
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

        <!-- Modal Add Address -->
        <div class="modalAddAddress modal fade" id="modalAddAddress" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">Add Address</h1>
                        <button type="button" class="btn-close bg-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="POST" id="formAddressModal">
                        <div class="addressModalContent modal-body px-5">
                            <div class="subDiv w-100 p-2">
                                <div class="my-2">
                                    <span>First Name *</span>
                                    <input type="text" class="w-100" name="firstName" id="firstName">
                                    <span id="errorFirstName" class="text-danger"></span>
                                </div>
                                <div class="my-2">
                                    <span>Last Name</span>
                                    <input type="text" class="w-100"  name="lastName" id="lastName">
                                    <span id="errorLastName"></span>
                                </div>
                                <div class="my-2">
                                    <span>Addressline 1 *</span>
                                    <input type="text" class="w-100"  name="addressline1" id="addressline1">
                                    <span id="errorAddressline1" class="text-danger"></span>
                                </div>
                                <div class="my-2">
                                    <span>Addressline 2</span>
                                    <input type="text" class="w-100" name="addressline2" id="addressline2">
                                </div>
                                <div class="my-2">
                                    <span>City *</span>
                                    <input type="text" class="w-100" name="city" id="city">
                                    <span id="errorCity" class="text-danger"></span>
                                </div>
                                <div class="my-2">
                                    <span>State *</span>
                                    <input type="text" class="w-100" name="state" id="state">
                                    <span id="errorState" class="text-danger"></span>
                                </div>
                                <div class="my-2">
                                    <span>Pincode *</span>
                                    <input type="text" class="w-100" name="pincode" id="pincode">
                                    <span id="errorPincode" class="text-danger"></span>
                                </div>
                                <div class="my-2">
                                    <span>Phone Number *</span>
                                    <input type="text" class="w-100" name="phoneNumber" id="phoneNumber">
                                    <span id="errorPhoneNumber" class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="closeAddressModal()">Close</button>
                            <button type="submit" name="addAddressBtn" class="btn btn-primary" onclick="checkAddress()">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Credit  Card -->
        <div class="modalCreditCard modal fade" id="modalCreditCard" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header px-5">
                        <i class="fa-solid fa-lock"></i>
                        <span class="ms-2">This is a secure 128-bit SSL Encrypted payment.You're safe.</span>
                    </div>
                    <form method="POST" id="formCardModal">
                        <div class="modalCardBody modal-body">
                            <div class="subHeading d-flex w-100 justify-content-between px-2">
                                <div class="cardImage">
                                    <img src="../Assets/Images/icons8-credit-card.gif" alt="No image Found">
                                </div>
                                <h1 class="modal-title fs-5" id="staticBackdropLabel">Credit Card</h1>
                                <div class="checkImage">
                                    <img src="../Assets/Images/check.png" alt="No image Found">
                                </div>
                            </div>
                            <hr class="mt-0 mb-2">
                            <div class="cardDetailsConatainer p-4">
                                <div class="cardNumberContainer mb-2">
                                    <span>Card number<sub class="ms-2">The 16 digits in front of your card</sub></span>
                                    <input type="text" name="cardNumberInput" class="cardNumberInput w-100 mt-2" id="cardNumberInput">
                                    <span class="warningCardNumber text-danger fw-bold"></span>
                                </div>
                                <div class="cardDateAndCvv d-flex">
                                    <div class="cardDateContainer w-50">
                                        <span>Expiration Date</span>
                                        <div class="d-flex">
                                            <div>
                                                <Input type="text" placeholder="MM" class="cardExpiryMonth me-2" id="cardExpiryMonth"><br>
                                                <span class="warningCardMonth text-danger fw-bold"></span>
                                            </div>
                                            <span>/</span>
                                            <div>
                                                <Input type="text" placeholder="YY" class="cardExpiryYear ms-2" id="cardExpiryYear"><br>
                                                <span class="warningCardYear text-danger fw-bold"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="cardCvvContainer w-50 ">
                                        <span>CVV2/CVC2</span>
                                        <div class="d-flex">
                                            <div>
                                                <input type="text" class="cardCvvInput me-1" name="cardCvvInput" id="cardCvvInput">
                                                <span class="warningCardCvv text-danger fw-bold"></span>
                                            </div>
                                            <p>The last 3 digits displayed on the back of your card.</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="cardNameContainer">
                                    <span>Full name on card</span>
                                    <input type="text" name="cardNameInput" class="cardNameInput w-100 my-2" id="cardNameInput">
                                    <span class="warningCardName text-danger fw-bold"></span>
                                </div>
                            </div>
                            <span  class="fw-bold warningCardCommon text-danger ms-3"></span>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="modalCardCloseBtn p-2" data-bs-dismiss="modal" onclick="cardModalClose()">Close</button>
                            <button type="button" name="editProfileSubmitBtn" id="editProfileSubmitBtn" value=" " class="modalCardSubmitBtn p-2" onclick="checkCardDetails()">Submit</button>
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