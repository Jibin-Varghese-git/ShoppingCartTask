function fnValAdminLogin(){
    let userName=document.getElementById("userName").value;
    let password=document.getElementById("password").value;
    document.getElementById("errorUserName").innerHTML=" ";
    document.getElementById("errorPassword").innerHTML=" ";

    if(userName.length < 1)
    {
        document.getElementById("errorUserName").innerHTML="Enter Username";
        event.preventDefault();
    }

    if(password.length < 1)
    {
        document.getElementById("errorPassword").innerHTML="Enter Password";
        event.preventDefault();
    }
}

function fnLogout(){
    if(confirm("Do you want to logout?"))
        {
            $.ajax({
                type:"GET",
                url:"components/shoppingCart.cfc?method=fnLogout",
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