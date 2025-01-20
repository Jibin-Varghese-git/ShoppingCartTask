function fnsignupValidation(){
    let firstName = document.getElementById("firstName").value;
    let lastName = document.getElementById("lastName").value;
    let userEmail = document.getElementById("userEmail").value;
    let userPhone = document.getElementById("userPhone").value;
    let password = document.getElementById("password").value;
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var flag = true;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4}$/;

    document.getElementById("errorFirstName").innerHTML=" ";
    document.getElementById("errorEmailId").innerHTML=" ";
    document.getElementById("errorPhone").innerHTML=" ";
    document.getElementById("errorPassword").innerHTML=" ";

    if(firstName.trim().length <1)
    {
        document.getElementById("errorFirstName").innerHTML="Enter the first name";
        flag = false;
    }

    if(userEmail.trim().length <1)
    {
        document.getElementById("errorEmailId").innerHTML="Enter the email";
        flag = false;
    }else if(emailPattern.test(userEmail) == false){
        document.getElementById("errorEmailId").innerHTML="Invalid Format";
        flag = false;
    }

    if(userPhone.trim().length <1)
    {
        document.getElementById("errorPhone").innerHTML="Enter the Phone number";
        flag = false;
    }else if(phonePattern.test(userPhone) === false){
        document.getElementById("errorPhone").innerHTML="Invalid Input";
        flag = false;
    }

    if(password.trim().length <1)
    {
        document.getElementById("errorPassword").innerHTML="Enter the password";
        flag = false;    
    }else if(password.length < 6){
        document.getElementById("errorPassword").innerHTML="Must Contain 6 characters";
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

function filterPrice(subcategoryId)
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
        data:{  subcategoryId : subcategoryId,
                minValue : minValue,
                maxValue : maxValue
            },
        success:function(result){
            if(result)
            {
                arrayFilterProducts = JSON.parse(result)
                console.log(arrayFilterProducts) 
                $('[name=filter]').prop('checked', false);
                $('#filterMin').val(' ')
                $('#filterMax').val(' ')
                $("#productContainer").empty()
                arrayFilterProducts.forEach(element => {
                    var singleProduct = `
                        <a href="userProduct?productId=${element.PRODUCTID}" class="text-decoration-none">
                            <div class="card p-2 my-3">
                                <div class="productImageDiv">
                                    <img src="../Assets/productImages/${element.PRODUCTIMAGE}" class="card-img-top" alt="No Image Found" height="200" width="50">
                                </div>
                                <div class="card-body d-flex flex-column align-items-center">
                                    <h5 class="card-title">${element.PRODUCTNAME}</h5>
                                    <span class="fw-bold text-wrap ">${element.PRODUCTBRAND}</span>
                                    <span class="text-success fw-bold"><i class="fa-solid fa-indian-rupee-sign"></i>${element.PRODUCTPRICE}</span>
                                </div>
                            </div>
                        </a>`
                    $('#productContainer').append(singleProduct)
                });
            }
        }
    });

}
