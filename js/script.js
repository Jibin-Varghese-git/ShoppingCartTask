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

function fnCloseModalCategory(){
    document.getElementById("errorNewCategory").innerHTML=" ";
    document.getElementById("newCategoryName").value=" ";
}

function fnModalEditCategory(categoryId){
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

function fnAddSubcategory(){
    let subcategoryName=document.getElementById("newSubcategoryName").value;
    let categoryId=document.getElementById("categoryListing").value;
    let subcategoryId=document.getElementById("btnAddSubcategory").value;
    console.log(categoryId ,"catid")
    console.log(subcategoryId,subcategoryName)
    if(subcategoryName.length < 1)
    {
        document.getElementById("errorNewSubcategory").innerHTML="Enter the category name."
        event.preventDefault;
    }
    else if(subcategoryId.length > 0)
    {
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnUpdateSubcategory",
            data:{subcategoryName : subcategoryName,categoryId : categoryId,subcategoryId : subcategoryId},
            success:function(result){
                if(result == "true")
                {
                    location.reload()
                }
                else
                {
                    document.getElementById("errorNewSubcategory").innerHTML="SubcategoryName Already Exists"
                }
            }
        });
    }
    else
    {
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnAddSubcategory",
            data:{subcategoryName : subcategoryName,categoryId : categoryId},
            success:function(result){
                if(result == "true")
                {
                    location.reload()
                }
                else
                {
                    document.getElementById("errorNewSubcategory").innerHTML="SubcategoryName Already Exists"
                }
            }
        });
    }
}

function fnCloseModalSubCategory(){
    document.getElementById("errorNewSubcategory").innerHTML=" ";
    document.getElementById("newSubcategoryName").value=" ";
}




function fnModalAddSubCategory(categoryId){ 
    document.getElementById("categoryListing").value=categoryId.value;
    document.getElementById("subcategoryModalHeading").innerHTML="Add SubCategory"
    document.getElementById("btnAddSubcategory").innerHTML="Add SubCategory"
}

function fnModalEditSubCategory(subcategoryId){

    $.ajax({
        type:"GET",
        url:"components/shoppingCart.cfc?method=fnSelectSubcategoryDetails",
        data:{subcategoryId : subcategoryId.value},
        success:function(result){
            if(result)
            {
                structSubcategoryDetails=JSON.parse(result)
                document.getElementById("newSubcategoryName").value=structSubcategoryDetails.subcategoryName;
                document.getElementById("categoryListing").value=structSubcategoryDetails.categoryId;
                document.getElementById("btnAddSubcategory").value=structSubcategoryDetails.subcategoryId;
                document.getElementById("subcategoryModalHeading").innerHTML="Edit SubCategory"
            }

        }
    });
}

function fnDeleteSubCategory(subcategoryId)
{
    if(confirm("Do you want to Delete this item?"))
    {
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnDeleteSubcategory",
            data:{subcategoryId : subcategoryId.value},
            success:function(result){
                if(result)
                {
                    document.getElementById(subcategoryId.value).remove();
                }
            }
        });
    } 
}

function fnGetCategory()
{
    let categoryId=document.getElementById("CategoryListing").value;
    let subCategory=document.getElementById("subcategoryListing");

    $.ajax({
        type:"GET",
        url:"components/shoppingCart.cfc?method=fnSelectSubCategory",
        data:{categoryId : categoryId},
        success:function(result){
            if(result)
            {
                subcategoryDetails=JSON.parse(result)
                while (subCategory.options.length) {
                    subCategory.remove(0);
                }
                for (var key in subcategoryDetails) {
                    if (subcategoryDetails.hasOwnProperty(key)) {
                      var option = document.createElement('option');
                      option.value = key; 
                      option.textContent = subcategoryDetails[key];
                      subCategory.appendChild(option);
                    }
                }
            }
        }
    });
}

function fnProductModalValidation(productId){
    let productName = document.getElementById("productName").value;
    let productDescription = document.getElementById("productDescription").value;
    let productPrice = document.getElementById("productPrice").value;
    let productTax = document.getElementById("productTax").value;
    let productImage = document.getElementById("productImage").value;
    let brandId = document.getElementById("brandListing").value;
    let subcategoryId = document.getElementById("brandListing").value
    if(productName.length < 1)
    {
        document.getElementById("errorProductName").innerHTML="Enter the product name"
        event.preventDefault();
    }
    if(productDescription.length < 1)
    {
        document.getElementById("errorProductDescription").innerHTML="Enter the product description"
        event.preventDefault();
    }
    if(productPrice.length < 1)
    {
        document.getElementById("errorProductPrice").innerHTML="Enter the product Price"
        event.preventDefault();
    }
    if(productTax.length < 1)
    {
        document.getElementById("errorProductTax").innerHTML="Enter the product Tax"
        event.preventDefault();
    }
    if(productImage.length < 1)
    {
        document.getElementById("errorProductImage").innerHTML="Choose the image"
        event.preventDefault();
    }

    if(productId.value.length < 1){
        alert("Insert")
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnAddProduct",
            data:{  productName : productName,
                productDescription : productDescription,
                productPrice : productPrice,
                productTax : productTax,
                brandId : brandId,
                subcategoryId : subcategoryId
            },
            success:function(result){
                if(result)
                {
                    document.getElementById(subcategoryId.value).remove();
                }
            }
        });
    }
    else{
        alert("Update")
    }
}