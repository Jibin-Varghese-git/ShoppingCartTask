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
    <body>
        <cfinclude  template="userHeader.cfm">
        <div class="mainContainerProfile">
            <div class="subcontainerProfileTop my-2 p-3 d-flex">
                <div class="profileImage p-2 ms-3 me-5">
                    <img src="../Assets/Images/user (2).png" alt="No Image Found">
                </div>
                <div class="profileName w-100 px-3 d-flex">
                    <cfoutput>
                    <div class="mx-3">
                        <h4>HELLO , </h4>
                        <h5 class="ms-5 profilUserName" id="profilUserName">#session.structUserDetails["firstName"]# #session.structUserDetails["lastName"]#</h5>
                        <span class="profileEmail" id="profileEmail">email : #session.structUserDetails["email"]#</span>
                    </div>
                    <div class="d-flex flex-column justify-content-center mx-3">
                        <button class="editProfileBtn p-2" id="editProfileBtn" data-bs-toggle="modal" data-bs-target="##modalEditProfile" onclick="profileModalOpen({userId:#session.structUserDetails['userId']#,
                                                                                                                                                userFirstName:'#session.structUserDetails['firstName']#',
                                                                                                                                                userLastName:'#session.structUserDetails['lastName']#',
                                                                                                                                                userPhoneNumber:'#session.structUserDetails['phone']#',
                                                                                                                                                userEmail:'#session.structUserDetails['email']#'
                                                                                                                                                })">Edit Profile</button>
                    </div>
                    </cfoutput>
                </div>
            </div>
            <div class="subcontainerProfileBottom my-2 p-4">
                <div class="addressHeading ">
                    <h5>Profile Address</h5>
                </div>
                <div class="addressContainer border">
                    <cfoutput>
                        <cfloop query="variables.addressQuery">
                            <div class="singleAddress px-5 py-3 m-2 d-flex" id="#variables.addressQuery.addressId#">
                                <div class="w-100">
                                    <div class="w-50 d-flex justify-content-between">
                                        <span>#variables.addressQuery.firstName# #variables.addressQuery.lastName#</span>
                                        <span>#variables.addressQuery.phoneNumber#</span>
                                    </div>
                                    <div class="d-flex w-50">
                                        <span>#variables.addressQuery.addressline1#,</span>
                                        <span>#variables.addressQuery.addressline2#,</span>
                                        <span>#variables.addressQuery.city#,</span>
                                        <span>#variables.addressQuery.state#</span>
                                    </div>
                                    <span>#variables.addressQuery.pincode#</span>
                                </div>
                                <div class="d-flex flex-column justify-content-center">
                                    <button value="#variables.addressQuery.addressId#" class="removeAddressBtn p-3" onclick="removeAddress(this)"><i class="fa-solid fa-trash"></i></button>
                                </div>
                            </div>
                        </cfloop>
                    </cfoutput>
                </div>
                    
                <div class="addressBtn mt-2 w-100 d-flex justify-content-end">
                    <button class="addAddressBtn p-2 mx-2" data-bs-toggle="modal" data-bs-target="#modalAddAddress"><i class="fa-solid fa-plus"></i> Add New Address</button>
                    <button class="orderBtn p-2 mx-2"><i class="fa-solid fa-circle-info"></i> Order Details</button>
                </div>
            </div>
            <cfif structKeyExists(form, "addAddressBtn")>
                <cfset variables.result = variables.objUserShoppingCart.addAddress(form)>
                <cfif variables.result["error"] EQ false>
                    <cflocation  url="userProfile.cfm">
                </cfif>
            </cfif>
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

        <!-- Modal Edit Profile -->
        <div class="modalEditProfile modal fade" id="modalEditProfile" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">Add Address</h1>
                        <button type="button" class="btn-close bg-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form method="POST" id="formProfileEdit">
                        <div class="profileEditContent modal-body px-5">
                            <div class="subDiv w-100 p-2">
                                <div class="my-2">
                                    <span>First Name *</span>
                                    <input type="text" class="w-100" name="userFirstName" id="userFirstName">
                                    <span id="errorUserFirstName" class="text-danger"></span>
                                </div>
                                <div class="my-2">
                                    <span>Last Name</span>
                                    <input type="text" class="w-100"  name="userLastName" id="userLastName">
                                    <span id="errorUserLastName"></span>
                                </div>
                                <div class="my-2">
                                    <span>Email *</span>
                                    <input type="text" class="w-100"  name="userEmail" id="userEmail">
                                    <span id="errorUserEmail" class="text-danger"></span>
                                </div>
                                <div class="my-2">
                                    <span>Phone Number *</span>
                                    <input type="text" class="w-100" name="userPhoneNumber" id="userPhoneNumber">
                                    <span id="errorUserPhoneNumber" class="text-danger"></span>
                                </div>
                                <span class="userProfileEditError text-danger" id="userProfileEditError"></span>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="userProfileModalClose()">Close</button>
                            <button type="button" name="editProfileSubmitBtn" id="editProfileSubmitBtn" value=" " class="btn btn-primary" onclick="editUserProfle()">Submit</button>
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