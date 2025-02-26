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
        <cfset variables.productListingCart = local.objUserShoppingCart.selectProductCart()>
        <cfset totalProductPrice = 0>
        <cfset totalTax = 0>
        <cfinclude  template="userHeader.cfm">
        <cfoutput>
            <div class="mainContainer px-2 d-flex">

                <div class="cartSubcontainerLeft my-3  p-4 d-flex flex-column align-items-center">
                    <div class="cartHeading w-100 p-3 d-flex justify-content-between">
                        <h4>USER CART</h4>
                        <div class="d-flex">
                          <h5 class="me-2">Items : </h5>
                          <h5 class="me-2" id="cartItemQuantity">#queryRecordCount(variables.productListingCart)#</h5>
                        </div>
                    </div>
                    <div class="productListingContainerCart pt-3">
                        <hr class="my-4">
<!---                  Product        --->
                        <cfloop query="variables.productListingCart">
                            <div class="row mb-4 d-flex justify-content-between align-items-center" id="#variables.productListingCart.cartId#">
                                <div class="col-md-2 col-lg-2 col-xl-2">
                                  <a href="userProduct.cfm?productId=#variables.productListingCart.productId#">
                                  <img
                                    src="../Assets/productImages/#variables.productListingCart.imageName#"
                                    class="img-fluid rounded-3" alt="Cotton T-shirt">
                                  </a>
                                </div>
                                <div class="col-md-3 col-lg-3 col-xl-3">
                                  <h6 class="text-muted">#variables.productListingCart.productName#</h6>
                                  <h6 class="mb-0">#variables.productListingCart.brandName#</h6>
                                </div>
                                <div class="col-md-3 col-lg-3 col-xl-2 d-flex">
                                  <button data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2" class="qtyDeleteBtn" id="#variables.productListingCart.cartId#DeleteBtn" onclick="removeQuantity({cartId:#variables.productListingCart.cartId#})">
                                    <i class="fas fa-minus"></i>
                                  </button>
                                  <input id="#variables.productListingCart.cartId#Input" class="cartQuantity" min="0" name="quantity" value="#variables.productListingCart.productQuantity#" type="text"
                                    class="form-control form-control-sm px-2"disabled/>

                                  <button data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2" onclick="addQuantity({cartId:#variables.productListingCart.cartId#})">
                                    <i class="fas fa-plus"></i>
                                  </button>
                                </div>
                                <div class="col-md-3 col-lg-2 col-xl-2 offset-lg-1 d-flex">
                                  <h6><i class="fa-solid fa-indian-rupee-sign"></i></h6>
                                  <h6 class="mb-0" id="#variables.productListingCart.cartId#ProductPrice">#variables.productListingCart.productQuantity * variables.productListingCart.price#</h6>
                                  <input type="hidden" value="#variables.productListingCart.tax#" id="#variables.productListingCart.cartId#ProductTax">
                                </div>
                                <div class="col-md-1 col-lg-1 col-xl-1 text-end">
                                  <button  class="border-0 bg-transparent" onclick="removeCartItem({cartId:#variables.productListingCart.cartId#})"><i class="fas fa-times"></i></button>
                                </div>
                                <hr class="my-4">
                            </div>
                            <cfset totalProductPrice += (variables.productListingCart.price * variables.productListingCart.productQuantity)>
                            <cfset totaltax += (variables.productListingCart.tax * variables.productListingCart.productQuantity)>
                        </cfloop>
                    </div>
                </div>

                <div class="cartSubcontainerRight my-3 ms-3 p-2">
                    <div class="w-100 bg-body-tertiary">
                        <div class="p-5">
                            <h3 class="fw-bold mb-5 mt-2 pt-1">Summary</h3>
                            <hr class="my-4">

                            <div class="d-flex justify-content-between mb-4">
                              <h5 class="text-uppercase">Products Price</h5>
                              <div class="d-flex">
                                <span class="me-1"><i class="fa-solid fa-indian-rupee-sign"></i></span>
                                <h5 id="totalProductPrice">#totalProductPrice#</h5>
                              </div>
                            </div>


                            <div class="d-flex justify-content-between mb-4 pb-2">
                              <h5 class="text-uppercase">Total Tax</h5>
                              <div class="d-flex">
                                <span class="me-1"><i class="fa-solid fa-indian-rupee-sign"></i></span>
                                <h5 id="totalTax">#totaltax#</h5>
                              </div>
                            </div>
                            <hr class="my-2">
                            <div class="d-flex justify-content-between mb-5">
                              <h5 class="text-uppercase">Total price</h5>
                              <div class="d-flex">
                                <span class="me-1"><i class="fa-solid fa-indian-rupee-sign"></i></span>
                                <h5 id="totalPrice">#totalProductPrice + totaltax#</h5>
                              </div>
                            </div>
                            <a href="userOrder.cfm?redirected=cart"  type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-dark btn-block btn-lg"
                              data-mdb-ripple-color="dark" id="placeOrderCartBtn">Place Order</a>
                        </div>
                    </div>
                </div>
              
            </div>
        </cfoutput>
        <cfinclude  template="userFooter.cfm"></cfinclude>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>