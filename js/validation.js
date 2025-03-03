function checkAddress(){
    var firstName = document.getElementById("firstName").value;
    var addressline1 = document.getElementById("addressline1").value;
    var city = document.getElementById("city").value;
    var state = document.getElementById("state").value;
    var pincode = document.getElementById("pincode").value;
    var phoneNumber = document.getElementById("phoneNumber").value;
    var pincodeRegex = /^[0-9]{6}$/;
    var flag = true;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;

    document.getElementById("errorFirstName").innerHTML=" ";
    document.getElementById("errorAddressline1").innerHTML=" ";
    document.getElementById("errorCity").innerHTML=" ";
    document.getElementById("errorState").innerHTML=" ";
    document.getElementById("errorPincode").innerHTML=" ";
    document.getElementById("errorPhoneNumber").innerHTML=" ";

    var  flag = commonValidation(phoneNumber,"errorPhoneNumber")
    if(phoneNumber.trim().length == 0)
    {
        document.getElementById("errorPhoneNumber").innerHTML="Enter the phone Number"
        document.getElementById("phoneNumber").focus();
        flag = false;
    }else if(phonePattern.test(phoneNumber) === false)
    {
        document.getElementById("errorPhoneNumber").innerHTML="Invalid Phone Number";
        document.getElementById("phoneNumber").focus();
        flag = false;
    }

    if(pincode.trim().length == 0)
    {
        document.getElementById("errorPincode").innerHTML="Enter the Pincode";
        document.getElementById("pincode").focus();
        flag = false;
    }else if(pincodeRegex.test(pincode) === false){
        document.getElementById("errorPincode").innerHTML="Invalid Pincode";
        document.getElementById("pincode").focus();
        flag = false;
    }

    if(state.trim().length == 0)
    {
        document.getElementById("errorState").innerHTML="Enter the State";
        document.getElementById("state").focus();
        flag = false;
    }

    if(city.trim().length == 0)
    {
        document.getElementById("errorCity").innerHTML="Enter the City";
        document.getElementById("city").focus();
        flag = false;
    }

    if(addressline1.trim().length == 0)
    {
        document.getElementById("errorAddressline1").innerHTML="Enter the address";
        document.getElementById("addressline1").focus();
        flag = false;
    }

    if(firstName.trim().length == 0)
    {
        document.getElementById("errorFirstName").innerHTML="Enter the first name";
        document.getElementById("firstName").focus();
        flag = false;
    }

    if(flag == false)
    {
        event.preventDefault()
    }
}


function fnLoginValidation(){
    let userName = document.getElementById("userName").value;
    let password = document.getElementById("password").value;
    let flag = true
    document.getElementById("errorUserName").innerHTML="";
    document.getElementById("errorPassword").innerHTML="";
    if(document.getElementById("errorUserEntry")){
        document.getElementById("errorUserEntry").innerHTML="";
    }
    
    if(userName.trim().length < 1)
    {
        document.getElementById("errorUserName").innerHTML="Enter the Username";
        flag = false;
    }

    if(password.trim().length <1)
    {
        document.getElementById("errorPassword").innerHTML="Enter the Password";
        flag = false;
    }

    if(flag == false)
    {
        event.preventDefault()
    }
}

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

