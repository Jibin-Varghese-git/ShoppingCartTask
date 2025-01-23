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
        <cfset productListingCart = local.objUserShoppingCart.selectProductCart()>
        <cfinclude  template="userHeader.cfm">
        <cfoutput>
            <div class="mainContainer px-2 d-flex">

                <div class="cartSubcontainerLeft my-3  p-4 d-flex flex-column align-items-center">
                    <div class="cartHeading w-100 p-3 d-flex justify-content-between">
                        <h4>USER CART</h4>
                        <h5 class="me-2">Items : #queryRecordCount(productListingCart)#</h5>
                    </div>
                    <div class="productListingContainerCart pt-3">
                        <hr class="my-4">
<!---                  Product        --->
                        <cfloop query="productListingCart">
                            <div class="row mb-4 d-flex justify-content-between align-items-center">
                                <div class="col-md-2 col-lg-2 col-xl-2">
                                  <img
                                    src="../Assets/productImages/#productListingCart.imageName#"
                                    class="img-fluid rounded-3" alt="Cotton T-shirt">
                                </div>
                                <div class="col-md-3 col-lg-3 col-xl-3">
                                  <h6 class="text-muted">#productListingCart.productName#</h6>
                                  <h6 class="mb-0">#productListingCart.brandName#</h6>
                                </div>
                                <div class="col-md-3 col-lg-3 col-xl-2 d-flex">
                                  <button data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2">
                                    <i class="fas fa-minus"></i>
                                  </button>

                                  <input id="form1" class="cartQuantity" min="0" name="quantity" value="#productListingCart.productQuantity#" type="number"
                                    class="form-control form-control-sm px-2" />

                                  <button data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2">
                                    <i class="fas fa-plus"></i>
                                  </button>
                                </div>
                                <div class="col-md-3 col-lg-2 col-xl-2 offset-lg-1">
                                  <h6 class="mb-0">#productListingCart.productQuantity * (productListingCart.price + productListingCart.tax)#</h6>
                                </div>
                                <div class="col-md-1 col-lg-1 col-xl-1 text-end">
                                  <button value="#productListingCart.cartId#" class="border-0 bg-transparent"><i class="fas fa-times"></i></button>
                                </div>
                            </div>
                            <hr class="my-4">
                        </cfloop>
                    </div>
                </div>

                <div class="cartSubcontainerRight my-3 ms-3 p-2">
                    <div class="w-100 bg-body-tertiary">
                        <div class="p-5">
                            <h3 class="fw-bold mb-5 mt-2 pt-1">Summary</h3>
                            <hr class="my-4">

                            <div class="d-flex justify-content-between mb-4">
                              <h5 class="text-uppercase"> </h5>
                              <h5> 132.00</h5>
                            </div>


                            <div class="d-flex justify-content-between mb-4 pb-2">
                              <h5 class="text-uppercase">Delivery Charge </h5>
                              <h5> 132.00</h5>
                            </div>
                            <hr class="my-2">
                            <div class="d-flex justify-content-between mb-5">
                              <h5 class="text-uppercase">Total price</h5>
                              <h5> 137.00</h5>
                            </div>

                            <button  type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-dark btn-block btn-lg"
                              data-mdb-ripple-color="dark">Register</button>
                        </div>
                    </div>
                </div>

            </div>
        </cfoutput>
        <cfinclude  template="userFooter.cfm"></cfinclude>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>