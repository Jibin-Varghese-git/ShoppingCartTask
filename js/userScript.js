if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}

function logoutUser(){
    Swal.fire({
        title: "Do you want to logout!",
        text: "Are you sure?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!"
      }).then((result) => {
        if (result.isConfirmed) {

            $.ajax({
                type:"POST",
                url:"components/userShoppingCart.cfc?method=logoutUser",
                success:function(result){
                    if(result)
                    {
                        location.reload();
                    }
                }
            });
        }
      });
}

function customFilter(){

    if($('#filter1').is(':checked')) 
    {
        $("#filterMin").prop('disabled', true);
        $("#filterMax").prop('disabled', true);
    }
    else if($('#filter2').is(':checked'))
    {
        $("#filterMin").prop('disabled', true);
        $("#filterMax").prop('disabled', true);
      
    }
    else if($('#filter3').is(':checked'))
    {
        $("#filterMin").prop('disabled', true);
        $("#filterMax").prop('disabled', true);
    }
    else if($('#customFilter').is(':checked'))
    {
        $("#filterMin").prop('disabled', false);
        $("#filterMax").prop('disabled', false);
    }
}

function filterPrice(filterArguments)
{ 
    if($('#filter1').is(':checked')) 
    { 
       var minValue=0;
       var maxValue=1000;
    }
    else if($('#filter2').is(':checked'))
    {
        var minValue=1000;
        var maxValue=10000;
      
    }
    else if($('#filter3').is(':checked'))
    {
        var minValue=10000;
        var maxValue=20000;
    }
    else if($('#customFilter').is(':checked'))
    {
        var minValue = $('#filterMin').val()
        var maxValue = $('#filterMax').val()
    }
    if(minValue < 0 || maxValue< 0){
        alert("Value should be greater than 0")
    }
    else{
        $.ajax({
            type:"POST",
            url:"components/userShoppingCart.cfc",
            data:{  subcategoryId : filterArguments.subcategoryId,
                    minValue : minValue,
                    maxValue : maxValue,
                    search : filterArguments.search,
                    method:"filterProducts"
                },
            success:function(result){

                $("#productContainerSubcategory").empty()
                if(result)
                {
                    arrayFilterProducts = JSON.parse(result);
                    $('#viewmoreBtn').remove();
                    $('#dropdownMenuClickableInside').dropdown('toggle');
                    arrayFilterProducts.forEach(element => {
                        var singleProduct = `
                            <a href="userProduct.cfm?productId=${element.PRODUCTID}" class="text-decoration-none">
                                <div class="card p-2 m-3">
                                    <div class="productImageDiv">
                                        <img src="../Assets/productImages/${element.PRODUCTIMAGE}" class="card-img-top" alt="No Image Found" height="200" width="50">
                                    </div>
                                    <div class="card-body d-flex flex-column align-items-center">
                                        <h5 class="card-title text-truncate">${element.PRODUCTNAME}</h5>
                                        <span class="fw-bold text-wrap ">${element.BRANDNAME}</span>
                                        <span class="price fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>${element.PRODUCTPRICE}</span>
                                    </div>
                                </div>
                            </a>`
                        $('#productContainerSubcategory').append(singleProduct)
                    });
                }
            }
        });
    }
}

function viewMore(listExcludedProductId,arguments){
    var structArguments = new Object();
    if(arguments.search){
        structArguments.search = arguments.search;
    }
    if(arguments.sort){
        structArguments.sort = arguments.sort;
    }
    if(arguments.subCategoryId){
        structArguments.subCategoryId = arguments.subCategoryId;
    }
    structArguments.limit = 5;
    structArguments.listExcludedProductId = listExcludedProductId.value;
    $.ajax({
        type : "POST",
        url : "components/userShoppingCart.cfc?method=selectSubcategoryProducts",
        data : structArguments,
        success : function(result){
            if(result){
                var structProductsDetails = JSON.parse(result);
                structProductsDetails.forEach(element => {
                    var singleProduct = `
                        <a href="userProduct.cfm?productId=${element.PRODUCTID}" class="text-decoration-none">
                            <div class="card p-2 m-3">
                                <div class="productImageDiv">
                                    <img src="../Assets/productImages/${element.PRODUCTIMAGE}" class="card-img-top" alt="No Image Found" height="200" width="50">
                                </div>
                                <div class="card-body d-flex flex-column align-items-center">
                                    <h5 class="card-title text-truncate">${element.PRODUCTNAME}</h5>
                                    <span class="fw-bold text-wrap ">${element.BRANDNAME}</span>
                                    <span class="price fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>${element.PRODUCTPRICE}</span>
                                </div>
                            </div>
                         </a>`
                    $('#productContainerSubcategory').append(singleProduct);
                    listExcludedProductId.value = listExcludedProductId.value + ',' + element.PRODUCTID
                });
                if(listExcludedProductId.value.split(",").length == document.getElementById("productCountHidden").value){
                    document.getElementById("viewmoreBtnDiv").remove()
                }
            }
        }
    });
}

function removeCartItem(cartDetails){
    Swal.fire({
        title: "Are you sure?",
        text: "You won't be able to revert this!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!",
        allowOutsideClick: false
      }).then((result) => {
        if (result.isConfirmed) {

            var cartItemQuantity=document.getElementById("cartItemQuantity").innerHTML;
            var cartItemQuantityHeader=document.getElementById("cartItemQuantity").innerHTML;
            var price=document.getElementById(cartDetails.cartId+"ProductPrice").innerHTML;
            var tax=document.getElementById(cartDetails.cartId+"ProductTax").value;
            var totalProductPrice=document.getElementById("totalProductPrice").innerHTML;
            var totalTax=document.getElementById("totalTax").innerHTML;
            
            totalProductPrice=parseFloat(totalProductPrice) - price;
            totalTax=parseFloat(totalTax) - parseFloat(tax);
            
            $.ajax({
                type : "POST",
                url : "components/userShoppingCart.cfc?method=removeCartProduct",
                data : {cartId:cartDetails.cartId},
                success : function(result){
                    if(result)
                    {
                        document.getElementById(cartDetails.cartId).remove();
                        document.getElementById("cartItemQuantity").innerHTML=cartItemQuantity - 1;
                        cartItemQuantityHeader -= 1
                        if(cartItemQuantityHeader == 0){
                            document.getElementById("cartItemQuantityHeader").style.display="none"
                        }else if(cartItemQuantityHeader > 10){
                            document.getElementById("cartItemQuantityHeader").innerHTML="10+"
                        }else{
                            document.getElementById("cartItemQuantityHeader").innerHTML=cartItemQuantityHeader;
                        }
                        document.getElementById("totalProductPrice").innerHTML = totalProductPrice.toFixed(2);
                        if(totalProductPrice < 1){
                            document.getElementById("totalProductPrice").innerHTML = 0;
                            document.getElementById("totalTax").innerHTML = 0;
                            document.getElementById("totalPrice").innerHTML= 0;
                            document.getElementById("placeOrderCartBtn").remove()
                        }
                        else{
                            document.getElementById("totalTax").innerHTML = totalTax.toFixed(2);
                            document.getElementById("totalPrice").innerHTML=(totalProductPrice + totalTax).toFixed(2);
                        }
                        checkQuantity()
                    }
                }
            });
        Swal.fire({
            title: "Removed!",
            text: "Item has been removed from the cart.",
            icon: "success",
            allowOutsideClick: false
          });
        }
      });
    
}

$(document).ready(function() {
    
    checkQuantityOrder();
    checkQuantity();
    if($("#verifyCardBtn"))
    {
        $("#verifyCardBtn").focus();
    }
    if($("#continuePayBtn")){
        $("#continuePayBtn").attr("disabled", true);
    }
});

function checkQuantity(){
    var quantity=$('.cartQuantity');
    for (let index = 0; index < quantity.length; index++) {
        if(quantity[index].value == 1)
        {
            quantity[index].previousElementSibling.disabled = true;
        }
        else{
            quantity[index].previousElementSibling.disabled =  false;
        }
    }

    var cartItemQuantityHeader=document.getElementById("cartItemQuantityHeader").innerHTML;
    if(cartItemQuantityHeader < 1 && document.getElementById("placeOrderCartBtn")){
        document.getElementById("placeOrderCartBtn").remove()
    }
    else if(document.getElementById("placeOrderCartBtn")){
        document.getElementById("placeOrderCartBtn").style.pointer="default"
    }
}

function addQuantity(cartDetails){
    var quantity=document.getElementById(cartDetails.cartId+"Input").value;
    var price=document.getElementById(cartDetails.cartId+"ProductPrice").innerHTML;
    var tax=document.getElementById(cartDetails.cartId+"ProductTax").value;
    var totalProductPrice=document.getElementById("totalProductPrice").innerHTML;
    var totalTax=document.getElementById("totalTax").innerHTML;

    price=price/quantity;
    totalProductPrice=parseFloat(totalProductPrice) + price;
    totalTax=parseFloat(totalTax) + parseFloat(tax);

    $.ajax({
       type : "POST",
        url : "components/userShoppingCart.cfc?method=cartUpdate",
        data : {cartId : cartDetails.cartId,quantity : parseInt(quantity)+1},
        success : function(result){
            if(result)
            {
                returnValue=JSON.parse(result)
                if(returnValue.success){
                    document.getElementById(cartDetails.cartId+"Input").value=parseInt(quantity)+1;
                    document.getElementById(cartDetails.cartId+"ProductPrice").innerHTML=(parseInt(quantity)+1)*price;
                    document.getElementById("totalProductPrice").innerHTML = totalProductPrice
                    document.getElementById("totalTax").innerHTML =  totalTax.toFixed(2);
                    document.getElementById("totalPrice").innerHTML= Math.round((totalProductPrice + totalTax).toFixed(2));
                    checkQuantity();
                }
                else{
                    alert("Value Cannot be less than 1");
                    location.reload()
                }
                
            }
        }
    });
}


function removeQuantity(cartDetails){
    var quantity=document.getElementById(cartDetails.cartId+"Input").value;
    var price=document.getElementById(cartDetails.cartId+"ProductPrice").innerHTML;
    var tax=document.getElementById(cartDetails.cartId+"ProductTax").value;
    var totalProductPrice=document.getElementById("totalProductPrice").innerHTML;
    var totalTax=document.getElementById("totalTax").innerHTML;

    price=price/quantity;
    totalProductPrice=parseFloat(totalProductPrice) - price;
    totalTax=parseFloat(totalTax) - parseFloat(tax);

    $.ajax({
        type : "POST",
        url : "components/userShoppingCart.cfc?method=cartUpdate",
        data : {cartId : cartDetails.cartId,quantity : parseInt(quantity)-1},
         success : function(result){
            if(result){
                returnValue=JSON.parse(result)
                if(returnValue.success){
                    document.getElementById(cartDetails.cartId+"Input").value=parseInt(quantity)-1;
                    document.getElementById(cartDetails.cartId+"ProductPrice").innerHTML=(parseInt(quantity)-1)*price;
                    document.getElementById("totalProductPrice").innerHTML = totalProductPrice;
                    document.getElementById("totalTax").innerHTML = totalTax.toFixed(2);
                    document.getElementById("totalPrice").innerHTML=Math.round((totalProductPrice + totalTax).toFixed(2));
                    checkQuantity()
                }
                else{
                    alert("Quantity Cannot be less than 1");
                    location.reload()
                }
            }
           
        }
    });
}


function closeAddressModal(){
    document.getElementById("errorFirstName").innerHTML=" ";
    document.getElementById("errorAddressline1").innerHTML=" ";
    document.getElementById("errorCity").innerHTML=" ";
    document.getElementById("errorState").innerHTML=" ";
    document.getElementById("errorPincode").innerHTML=" ";
    document.getElementById("errorPhoneNumber").innerHTML=" ";
    if(document.getElementById("formAddressModal"))
    {
        document.getElementById("formAddressModal").reset();
    }else{
        document.getElementById("OrderPageForm").reset()
    }

}

function removeAddress(addressId){
    Swal.fire({
        title: "Are you sure?",
        text: "You won't be able to revert this!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, delete it!",
        allowOutsideClick: false
      }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type : "POST",
                url : "components/userShoppingCart.cfc?method=removeAddress",
                data : {addressId : addressId.value},
                success: function(result){
                    if(result){
                        document.getElementById(addressId.value).remove();
                    }
                }
            });
            Swal.fire({
                title: "Deleted!",
                text: "Your file has been deleted.",
                icon: "success",
                allowOutsideClick: false
            });
        }
    });
}

function profileModalOpen(userDetails){
    document.getElementById("userFirstName").value=userDetails.userFirstName;
    document.getElementById("userLastName").value=userDetails.userLastName;
    document.getElementById("userEmail").value=userDetails.userEmail;
    document.getElementById("userPhoneNumber").value=userDetails.userPhoneNumber;
    document.getElementById("editProfileSubmitBtn").value=userDetails.userId;
}

function editUserProfle(){
    document.getElementById("errorUserFirstName").innerHTML=" ";
    document.getElementById("errorUserEmail").innerHTML=" ";
    document.getElementById("errorUserPhoneNumber").innerHTML=" ";
    document.getElementById("userProfileEditError").innerHTML=" ";
    var userFirstName = document.getElementById("userFirstName").value;
    var userLastName = document.getElementById("userLastName").value;
    var userEmail = document.getElementById("userEmail").value;
    var userPhoneNumber = document.getElementById("userPhoneNumber").value;
    var userId = document.getElementById("editProfileSubmitBtn").value;
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var flag = true;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;

    document.getElementById("errorUserFirstName").innerHTML=" ";
    document.getElementById("errorUserEmail").innerHTML=" ";
    document.getElementById("errorUserPhoneNumber").innerHTML=" ";

    if(userPhoneNumber.trim().length <1)
    {
        document.getElementById("errorUserPhoneNumber").innerHTML="Enter Phone number";
        document.getElementById("userPhoneNumber").focus();
        flag = false;
    }else if(phonePattern.test(userPhoneNumber) === false){
        document.getElementById("errorUserPhoneNumber").innerHTML="Invalid Input";
        document.getElementById("userPhoneNumber").focus();
        flag = false;
    }

    if(userEmail.trim().length <1)
        {
            document.getElementById("errorUserEmail").innerHTML="Enter  email";
            document.getElementById("userEmail").focus();
            flag = false;
        }else if(emailPattern.test(userEmail) == false){
            document.getElementById("errorUserEmail").innerHTML="Invalid Format";
            document.getElementById("userEmail").focus();
            flag = false;
        }

        if(userFirstName.trim().length <1)
        {
            document.getElementById("errorUserFirstName").innerHTML="Enter first name";
            document.getElementById("userFirstName").focus();
            flag = false;
        }

    if(flag == false)
    {
        event.preventDefault()
    }
    else{
        $.ajax({
            type : "POST",
            url : "components/userShoppingCart.cfc?method=editUserProfile",
            data : {userId : userId,
                    userFirstName : userFirstName,
                    userLastName : userLastName,
                    userEmail : userEmail,
                    userPhoneNumber : userPhoneNumber
                    },
            success : function(result){
                if(result)
                {
                    userEdit=JSON.parse(result)
                    if(userEdit.error == false){
                        document.getElementById("profilUserName").innerHTML=userFirstName + " " + userLastName;
                        document.getElementById("profileEmail").innerHTML="email : " + userEmail
                        $("#modalEditProfile").modal("hide")
                        document.getElementById("editProfileBtn").addEventListener('click', function(){
                            profileModalOpen({
                                userId: `${userId}`,
                                userFirstName: `${userFirstName}`,
                                userLastName: `${userLastName}`,
                                userPhoneNumber: `${userPhoneNumber}`,
                                userEmail: `${userEmail}`
                            });
                        });
                        Swal.fire({
                            position: "center-end",
                            icon: "success",
                            title: "Profile edited successfully!",
                            toast:true,
                            showConfirmButton: false,
                            timer: 2000
                          });
                    }
                    else{
                        document.getElementById("userProfileEditError").innerHTML=userEdit.errorMessage;
                    }
                }
            }
        });
    }
}

function userProfileModalClose(){
    document.getElementById("errorUserFirstName").innerHTML=" ";
    document.getElementById("errorUserEmail").innerHTML=" ";
    document.getElementById("errorUserPhoneNumber").innerHTML=" ";
    document.getElementById("userProfileEditError").innerHTML=" ";
    document.getElementById("formProfileEdit").reset();
}

function changeAddress(){
    var selectedAddressId = document.querySelector('input[name="selectedAddress"]:checked').value;
    var userName = document.getElementById(selectedAddressId + "userName").innerHTML;
    var userPhoneNumber = document.getElementById(selectedAddressId + "userPhoneNumber").innerHTML;
    var addressline1 = document.getElementById(selectedAddressId + "addressline1").innerHTML;
    var addressline2 = document.getElementById(selectedAddressId + "addressline2").innerHTML;
    var city = document.getElementById(selectedAddressId + "city").innerHTML;
    var state = document.getElementById(selectedAddressId + "state").innerHTML;
    var pincode = document.getElementById(selectedAddressId + "pincode").innerHTML;
    document.getElementById("addressUserName").innerHTML = userName;
    document.getElementById("addressUserPhoneNumber").innerHTML = userPhoneNumber;
    document.getElementById("addressUserAddressline1").innerHTML = addressline1;
    document.getElementById("addressUserAddressline2").innerHTML = addressline2;
    document.getElementById("addressUserCity").innerHTML = city;
    document.getElementById("addressUserState").innerHTML = state;
    document.getElementById("addressUserPincode").innerHTML = pincode;
    document.getElementById("addressIdHidden").value = selectedAddressId;
    $("#modalChangeAddress").modal("hide");
}

function deleteQtyOrder(productId){
    var qty= document.getElementById(productId + "Input").value;
    var totalProductPrice = document.getElementById("totalProductPrice").innerHTML;
    var totalTax = document.getElementById("totalProductTax").innerHTML;

    totalProductPrice = totalProductPrice/qty;
    totalTax = totalTax/qty;
    qty=parseInt(qty) - 1;
    totalProductPrice = parseFloat(totalProductPrice) * qty;
    totalTax = parseFloat(totalTax) * qty;

    document.getElementById("totalProductPrice").innerHTML=totalProductPrice;
    document.getElementById("totalProductTax").innerHTML=totalTax;
    document.getElementById("totalPrice").innerHTML = totalProductPrice + totalTax;
    document.getElementById("totalPriceBtn").innerHTML = totalProductPrice + totalTax;
    document.getElementById(productId + "Input").value = qty;
    checkQuantityOrder()
}

function addQtyOrder(productId){
    var qty = document.getElementById(productId + "Input").value;
    var totalProductPrice = document.getElementById("totalProductPrice").innerHTML;
    var totalTax = document.getElementById("totalProductTax").innerHTML;

    totalProductPrice = totalProductPrice/qty;
    totalTax = totalTax/qty;
    qty=parseInt(qty) + 1;
    totalProductPrice = parseFloat(totalProductPrice) * qty;
    totalTax = parseFloat(totalTax) * qty;

    document.getElementById("totalProductPrice").innerHTML=totalProductPrice;
    document.getElementById("totalPriceHidden").value = totalProductPrice;
    document.getElementById("totalProductTax").innerHTML=totalTax;
    document.getElementById("totalTaxHidden").value=totalTax;
    document.getElementById("totalPrice").innerHTML = totalProductPrice + totalTax;
    document.getElementById("totalPriceBtn").innerHTML = totalProductPrice + totalTax;
    document.getElementById(productId + "Input").value = qty;
    checkQuantityOrder()
}


function checkQuantityOrder(){
    var quantity=$('.orderQuantity');
    console.log("qty :" +quantity)
    for (let index = 0; index < quantity.length; index++) {
        if(quantity[index].value ==1)
        {
            quantity[index].previousElementSibling.disabled = true;
        }
        else{
            quantity[index].previousElementSibling.disabled =  false;
        }
    }
}

function checkCardDetails(){
    var cardNumber = $("#cardNumberInput").val();
    var cardMonth = $("#cardExpiryMonth").val();
    var cardYear = $("#cardExpiryYear").val();
    var cardCvv = $("#cardCvvInput").val();
    var cardName = $("#cardNameInput").val();
    var re16digit = /^\d{16}$/;
    var re3digit = /^\d{3}$/;
    var re2digit = /^\d{2}$/;
    var flag =true;

    $(".warningCardName").html(" ");
    $(".warningCardCvv").html(" ");
    $(".warningCardMonth").html(" ");
    $(".warningCardYear").html(" ");
    $(".warningCardNumber").html(" ");
    
    if(cardName.trim().length == 0){
        $(".warningCardName").html("Enter card holder name");
        $("#cardNameInput").focus();
        flag=false;
    }

    if(cardCvv.trim().length == 0){
        $(".warningCardCvv").html("Enter CVV");
        $("#cardCvvInput").focus();
        flag=false;
    }else if(re3digit.test(cardCvv) === false){
        $(".warningCardCvv").html("Invalid CVV");
        $("#cardCvvInput").focus();
        flag=false;
    }

    if(cardMonth.trim().length == 0){
        $(".warningCardMonth").html("Enter Month");
        $("#cardExpiryMonth").focus();
        flag=false;
    }else if(re2digit.test(cardMonth) === false){
        $(".warningCardMonth").html("Invalid Month");
        $("#cardExpiryMonth").focus();
        flag=false;
    }else if(cardMonth.trim() < 1 || cardMonth.trim() > 12){
        $(".warningCardMonth").html("Invalid Month");
        $("#cardExpiryMonth").focus();
        flag=false;
    }else if(cardYear.trim().length == 0){
        $(".warningCardYear").html("Enter Year");
        $("#cardExpiryYear").focus();
        flag=false;
    }else if(re2digit.test(cardYear) === false){
        $(".warningCardYear").html("Invalid Year");
        $("#cardExpiryYear").focus();
        flag=false;
    }

    if(cardNumber.trim().length == 0){
        $(".warningCardNumber").html("Enter Card Number");
        $("#cardNumberInput").focus();
        flag=false;
    }else if(re16digit.test(cardNumber) === false){
        $(".warningCardNumber").html("Invalid Card Number");
        $("#cardNumberInput").focus();
        flag=false;
    }

    if(flag == true){
        $.ajax({
             type : "POST",
            url : "components/userShoppingCart.cfc?method=checkCardDetails",
            data : {cardNumber : cardNumber,
                    cardMonth : cardMonth,
                    cardYear : cardYear,
                    cardCvv : cardCvv,
                    cardName : cardName
                    },
            success : function(result){
                if(result)
                {
                    cardReturn=JSON.parse(result)
                    console.log(cardReturn)
                    if(cardReturn.error)
                    {
                        $(".warningCardCommon").html(cardReturn.message);
                    }
                    else{
                        $("#modalCreditCard").modal("hide")
                        $("#verifyCardBtn").remove();
                        $("#continuePayBtn").attr("disabled", false);
                        Swal.fire({
                            title: "Card Verified!",
                            icon: "success",
                            draggable: true,
                            allowOutsideClick: false
                          });
                        $("#continuePayBtn").attr('style', 'background-color:#506bb3;');
                    }
                }
            }
        });
    }
}

function cardModalClose(){
    $(".warningCardName").html(" ");
    $(".warningCardCvv").html(" ");
    $(".warningCardMonth").html(" ");
    $(".warningCardYear").html(" ");
    $(".warningCardNumber").html(" ");
    $(".warningCardCommon").html(" ");
    $("#OrderPageForm")[0].reset();
}


function invoiceDownload(orderId){
    Swal.fire({
        title: "Invoice Download",
        text: "Do you want to download invoce!",
        icon: "question",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes!",
        allowOutsideClick: false
      }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                method : "POST",
                url : "components/userShoppingCart.cfc?method=invoiceDownload",
                data:{orderId : orderId.value},
                success : function(result){
                    if(result)
                    {
                        console.log(result)
                        download(result);
                    }
                }
            });
        }
      });
}

function download(fileUrl) 
{
    var createTag = document.createElement("a");
    createTag.setAttribute("href",fileUrl);
    createTag.setAttribute("download","");
    document.body.appendChild(createTag);
    createTag.click();
    createTag.remove();
}

function confirmOrder() {
    var flag = false;
    if ($(".selectedAddress").val().length < 1){
        alert("Select an address");
        flag = false;
    }else{
        flag=true;
    }
    return flag
}


window.addEventListener('pageshow', (event) => {
    if (event.persisted) {
      window.location.reload();
    }
});




