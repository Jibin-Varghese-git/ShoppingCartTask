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

function fnDeleteCategory(categoryId)
{
    if(confirm("Do you want to Delete this item?"))
    {
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnDeleteCategory",
            data:{categoryId : categoryId.value},
            success:function(result){
                if(result)
                {
                    document.getElementById(categoryId.value).remove();
                }
            }
        });
    } 
}

function fnAddCategory(){
    let categoryName=document.getElementById("newCategoryName").value;
    let categoryId=document.getElementById("btnAddCategory").value;
    if(categoryName.length < 1)
    {
        document.getElementById("errorNewCategory").innerHTML="Enter the category name."
        event.preventDefault;
    }
    else if(categoryId.length > 0)
    {
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnUpdateCategory",
            data:{categoryName : categoryName , categoryId : categoryId},
            success:function(result){
                if(result == "true")
                {
                    location.reload()
                }
                else
                {
                    document.getElementById("errorNewCategory").innerHTML="CategoryName Already Exists"
                }
            }
        });
    }
    else
    {
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnAddCategory",
            data:{categoryName},
            success:function(result){
                if(result == "true")
                {
                    location.reload()
                }
                else
                {
                    document.getElementById("errorNewCategory").innerHTML="CategoryName Already Exists"
                }
            }
        });
    }
}

function fnCloseModal(){
    document.getElementById("errorNewCategory").innerHTML=" ";
    document.getElementById("newCategoryName").value=" ";
    document.getElementById("errorNewSubcategory").innerHTML=" ";
    document.getElementById("newSubcategoryName").value=" ";
}

function fnModalEditCategory(categoryId){
    alert(categoryId.value)
    document.getElementById("categoryModalHeading").innerHTML="Edit Category";
    document.getElementById("btnAddCategory").innerHTML="Edit Category";
    document.getElementById("btnAddCategory").value=categoryId.value;
    $.ajax({
        type:"GET",
        url:"components/shoppingCart.cfc?method=fnSelectCategoryName",
        data:{categoryId : categoryId.value},
        success:function(result){
            if(result)
            {
                document.getElementById("newCategoryName").value=result;
            }

        }
    });
}

function fnAddSubcategory(categoryId){
    
    let subcategoryName=document.getElementById("newSubcategoryName").value;
    if(subcategoryName.length < 1)
    {
        document.getElementById("errorNewSubcategory").innerHTML="Enter the category name."
        event.preventDefault;
    }
    else{
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnAddSubcategory",
            data:{subcategoryName : subcategoryName,categoryId : categoryId.value},
            success:function(result){
                if(result == "true")
                {
                    alert(result)
                    location.reload()
                }
                else
                {
                    alert(result)
                    document.getElementById("errorNewSubcategory").innerHTML="SubcategoryName Already Exists"
                }
            }
        });
    }
}