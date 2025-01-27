function fnsignupValidation(){
    let firstName = document.getElementById("firstName").value;
    let lastName = document.getElementById("lastName").value;
    let userEmail = document.getElementById("userEmail").value;
    let userPhone = document.getElementById("userPhone").value;
    let password = document.getElementById("password").value;
    let confirmPassword = document.getElementById("confirmPassword").value;
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var flag = true;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4}$/;
    alert(confirmPassword)
    document.getElementById("errorFirstName").innerHTML=" ";
    document.getElementById("errorEmailId").innerHTML=" ";
    document.getElementById("errorPhone").innerHTML=" ";
    document.getElementById("errorPassword").innerHTML=" ";
    document.getElementById("errorConfirmPassword").innerHTML=" ";

    if(firstName.trim().length <1)
    {
        document.getElementById("errorFirstName").innerHTML="Enter first name";
        flag = false;
    }

    if(userEmail.trim().length <1)
    {
        document.getElementById("errorEmailId").innerHTML="Enter  email";
        flag = false;
    }else if(emailPattern.test(userEmail) == false){
        document.getElementById("errorEmailId").innerHTML="Invalid Format";
        flag = false;
    }

    if(userPhone.trim().length <1)
    {
        document.getElementById("errorPhone").innerHTML="Enter Phone number";
        flag = false;
    }else if(phonePattern.test(userPhone) === false){
        document.getElementById("errorPhone").innerHTML="Invalid Input";
        flag = false;
    }

    if(password.trim().length <1)
    {
        document.getElementById("errorPassword").innerHTML="Enter  password";
        flag = false;    
    }else if(password.length < 6){
        document.getElementById("errorPassword").innerHTML="Must Contain 6 characters";
        flag = false;
    }
    else if(password.trim() != confirmPassword.trim()){
        document.getElementById("errorConfirmPassword").innerHTML="Password Missmatch";
        flag = false;
    }

    if(flag == false)
    {
        event.preventDefault()
    }
}

function fnLoginValidation(){
    let userName = document.getElementById("userNameLogin").value;
    let password = document.getElementById("passwordLogin").value;
    let flag = true

    if(userName.trim().length <1)
    {
        document.getElementById("errorUserName").innerHTML="Enter the Username";
        flag = false;
    }

    if(password.trim().length <1)
    {
        document.getElementById("errorPasswordLogin").innerHTML="Enter the Password";
        flag = false;
    }

    if(flag == false)
    {
        event.preventDefault()
    }
}

function logoutUser(){
    if(confirm("Do you want to logout?"))
        {
            $.ajax({
                type:"GET",
                url:"components/userShoppingCart.cfc?method=logoutUser",
                success:function(result){
                    if(result)
                    {
                        location.reload();
                    }
                }
            });
        } 
        else{
            alert("error")
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
    else
    {
        var minValue = $('#filterMin').val()
        var maxValue = $('#filterMax').val()
    }
    $.ajax({
        type:"Post",
        url:"components/userShoppingCart.cfc?method=filterProducts",
        data:{  subcategoryId : filterArguments.subcategoryId,
                minValue : minValue,
                maxValue : maxValue,
                search : filterArguments.search
            },
        success:function(result){
            $("#productContainerSubcategory").empty()
            if(result)
            {
                arrayFilterProducts = JSON.parse(result)
                if(arrayFilterProducts.length < 10)
                {
                    $('#viewmoreBtn').remove()
                }
                $('[name=filter]').prop('checked', false);
                $('#filterMin').val(' ')
                $('#filterMax').val(' ')
                arrayFilterProducts.forEach(element => {
                    var singleProduct = `
                        <a href="userProduct.cfm?productId=${element.PRODUCTID}" class="text-decoration-none">
                            <div class="card p-2 m-3">
                                <div class="productImageDiv">
                                    <img src="../Assets/productImages/${element.PRODUCTIMAGE}" class="card-img-top" alt="No Image Found" height="200" width="50">
                                </div>
                                <div class="card-body d-flex flex-column align-items-center">
                                    <h5 class="card-title">${element.PRODUCTNAME}</h5>
                                    <span class="fw-bold text-wrap ">${element.BRANDNAME}</span>
                                    <span class="text-success fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>${element.PRODUCTPRICE}</span>
                                </div>
                            </div>
                        </a>`
                    $('#productContainerSubcategory').append(singleProduct)
                });
            }
        }
    });
}

function viewMore(){
    var btnValue=$('#viewmoreBtn').val()
    if(btnValue == "more")
    {
        $("#productContainerSubcategory").removeClass("productContainerSubcategory")
        $('#viewmoreBtn').html("View Less <i class='fa-solid fa-arrow-up-long' style='color: #bd8dc9;'></i>")
        $('#viewmoreBtn').prop("value","less")
    }
    else{
        $("#productContainerSubcategory").addClass("productContainerSubcategory")
        $('#viewmoreBtn').html("View More <i class='fa-solid fa-arrow-down' style='color: #bd8dc9;'></i>")
        $('#viewmoreBtn').prop("value","more")
    }
}

function removeCartItem(cartDetails){
    if(confirm("Do you want to Delete this item?"))
    {
        var cartItemQuantity=document.getElementById("cartItemQuantity").innerHTML;
        var cartItemQuantityHeader=document.getElementById("cartItemQuantityHeader").innerHTML;
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
                    document.getElementById("cartItemQuantityHeader").innerHTML=cartItemQuantityHeader - 1;
                    document.getElementById("totalProductPrice").innerHTML = totalProductPrice.toFixed(2);
                    if((totalProductPrice + totalTax) < 1){
                        document.getElementById("totalTax").innerHTML = 0;
                        document.getElementById("totalPrice").innerHTML= 0;
                    }
                    else{
                        document.getElementById("totalTax").innerHTML = totalTax.toFixed(2);
                        document.getElementById("totalPrice").innerHTML=(totalProductPrice + totalTax).toFixed(2);
                    }
                    checkQuantity()
                }
            }
        });
    }
}


$( document ).ready(function() {
    checkQuantity();
});

function checkQuantity(){
    var quantity=$('.cartQuantity');
    for (let index = 0; index < quantity.length; index++) {
        if(quantity[index].value ==1)
        {
            quantity[index].previousElementSibling.disabled = true;
        }
        else{
            quantity[index].previousElementSibling.disabled =  false;
        }
    }

    var cartItemQuantityHeader=document.getElementById("cartItemQuantityHeader").innerHTML;
    console.log(cartItemQuantityHeader)
    if(cartItemQuantityHeader < 1){
        document.getElementById("placeOrderCartBtn").disabled=true;
    }
    else{
        document.getElementById("placeOrderCartBtn").disabled=false;
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
    totalTax=parseFloat(totalTax)  + parseFloat(tax);

    document.getElementById(cartDetails.cartId+"Input").value=parseInt(quantity)+1;
    document.getElementById(cartDetails.cartId+"ProductPrice").innerHTML=(parseInt(quantity)+1)*price;
    document.getElementById("totalProductPrice").innerHTML = totalProductPrice.toFixed(2);
    document.getElementById("totalTax").innerHTML = totalTax.toFixed(2);
    document.getElementById("totalPrice").innerHTML=(totalProductPrice + totalTax).toFixed(2);

    $.ajax({
       type : "POST",
        url : "components/userShoppingCart.cfc?method=cartUpdate",
        data : {cartId : cartDetails.cartId,quantity : parseInt(quantity)+1},
        success : function(){}
    });
    checkQuantity();
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

    document.getElementById(cartDetails.cartId+"Input").value=parseInt(quantity)-1;
    document.getElementById(cartDetails.cartId+"ProductPrice").innerHTML=(parseInt(quantity)-1)*price;
    document.getElementById("totalProductPrice").innerHTML = totalProductPrice.toFixed(2);
    document.getElementById("totalTax").innerHTML = totalTax.toFixed(2);
    document.getElementById("totalPrice").innerHTML=(totalProductPrice + totalTax).toFixed(2);

    $.ajax({
        type : "POST",
        url : "components/userShoppingCart.cfc?method=cartUpdate",
        data : {cartId : cartDetails.cartId,quantity : parseInt(quantity)-1},
         success : function(result){
            if(result){
                checkQuantity()
            }
        }
    });
}

