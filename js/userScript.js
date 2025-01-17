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
