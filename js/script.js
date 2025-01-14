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

function openProductModal(structProduct){
    document.getElementById("CategoryListing").value=structProduct.categoryId;
    document.getElementById("subcategoryListing").value=structProduct.subcategoryId;
}

function fnProductModalValidation(){
    event.preventDefault()  
    var error = false;
    let productName = document.getElementById("productName").value;
    let productDescription = document.getElementById("productDescription").value;
    let productPrice = document.getElementById("productPrice").value;
    let productTax = document.getElementById("productTax").value;
    let productImage = document.getElementById("productImage").value;
    let productId = document.getElementById("btnAddProducts").value;
    if(productName.length < 1)
    {
        document.getElementById("errorProductName").innerHTML="Enter the product name"
        error=true;
    }
    if(productDescription.length < 1)
    {
        document.getElementById("errorProductDescription").innerHTML="Enter the product description"
        error=true;
    }
    if(productPrice.length < 1)
    {
        document.getElementById("errorProductPrice").innerHTML="Enter the product Price"
        error=true;
    }
    if(productTax.length < 1)
    {
        document.getElementById("errorProductTax").innerHTML="Enter the product Tax"
        error=true;    }
   
    
    if(error){
        event.preventDefault()
    }
    else {
      
        if(productId.length < 1){
            if(productImage.length < 1)
            {
                document.getElementById("errorProductImage").innerHTML="Choose the image"
                event.preventDefault();    
            }
            else{
                var formData=new FormData(document.getElementById("productForm"));
                formData.forEach(function(value, key) {
                    console.log(key, value);
                });
                $.ajax({
                    type:"POST",
                    url:"components/shoppingCart.cfc?method=fnAddProduct",
                    data: formData,
                    processData:false,
                    contentType:false,
                    success:function(result){
                        alert(result)
                        if(result == "true")
                        {
                           location.reload()
                        }
                        else
                        {
                            document.getElementById("errorProductName").innerHTML="Product name already exist";
                            event.preventDefault();
                        }
                    }
                });
            }
        }
        else{
            var formData=new FormData(document.getElementById("productForm"));
            formData.forEach(function(value, key) {
                console.log(key, value);
            });
            $.ajax({
                type:"POST",
                url:"components/shoppingCart.cfc?method=fnUpdateProduct",
                data: formData,
                processData:false,
                contentType:false,
                success:function(result){
                    if(result)
                    {
                       location.reload()
                    }
                }
            });
        }
    } 
}

function fnEditProductModal(structProduct){
    console.log(structProduct.productId)
    $.ajax({
        type:"POST",
        url:"components/shoppingCart.cfc?method=fnSelectSingleProduct",
        data:{productId:structProduct.productId},
        success:function(result){
            if(result)
            {
               structProductDetails=JSON.parse(result);
               document.getElementById("CategoryListing").value=structProduct.categoryId;
               document.getElementById("subcategoryListing").value=structProduct.subcategoryId;
               document.getElementById("productName").value=structProductDetails.productName;
               document.getElementById("brandListing").value=structProductDetails.brandId;
               document.getElementById("productDescription").value=structProductDetails.description;
               document.getElementById("productPrice").value=structProductDetails.price;
               document.getElementById("productTax").value=structProductDetails.tax;
               document.getElementById("hiddenProductId").value=structProduct.productId
               document.getElementById("btnAddProducts").value=structProduct.productId;
            }
        }
    });
}


function fnDeleteProduct(productId)
{
    if(confirm("Do you want to Delete this item?"))
    {
        $.ajax({
            type:"GET",
            url:"components/shoppingCart.cfc?method=fnDeleteProduct",
            data:{productId : productId.value},
            success:function(result){
                if(result)
                {
                    document.getElementById(productId.value).remove();
                }
            }
        });
    } 
}

function fnImageModal(structImage){
    $.ajax({
        type:"GET",
        url:"components/shoppingCart.cfc?method=fnSelectImage",
        data:{productId : structImage.productId},
        success:function(result){
            if(result)
            {
                structImageDetails = JSON.parse(result);
                const carouselContainer = document.getElementById('carouselInner');
                const btnContainer=document.getElementById("btnImageModal")
                var active = 1; 
                carouselContainer.innerHTML = ''; 
                btnContainer .innerHTML = '';  
                for (var key in structImageDetails) {
                    if (structImageDetails.hasOwnProperty(key)) {
                        console.log(structImageDetails[key]);
                        console.log(key);
                        const carouselSubContainer = document.createElement('div');
                        carouselSubContainer.classList.add('carousel-item');
                        if (active == 1) {
                            carouselSubContainer.classList.add('active');
                            active=0; 
                        }
                        const image = document.createElement('img');
                        image.src = structImageDetails[key];
                        image.width=100;
                        image.height=100;
                        image.alt = `Image ${key}`;
                        carouselSubContainer.append(image);
                        carouselContainer.append(carouselSubContainer);

                        // Create a div container for the buttons inside the carousel item
                        const buttonContainer = document.createElement('div');
                        buttonContainer.classList.add('button-container'); // Optional: Add a class for styling buttons
                                    
                        // Create "Delete" button
                        const deleteBtn = document.createElement('button');
                        deleteBtn.textContent = 'Delete';
                        deleteBtn.value = key;
                                    
                        // Correct way to assign onclick event (using a function reference)
                        deleteBtn.onclick = function() {
                            fnProductDelete(key);  // Pass key to the delete function
                        };
                    
                        // Create "Set as Thumbnail" button
                        const thumbnailBtn = document.createElement('button');
                        thumbnailBtn.textContent = 'Set as Thumbnail';
                        thumbnailBtn.value = key;
                    
                        // Correct way to assign onclick event (using a function reference)
                        thumbnailBtn.onclick = function() {
                            fnSetThumbnail(key);  // Pass key to the set thumbnail function
                        };
                    
                        // Append buttons to the button container
                        buttonContainer.append(deleteBtn, thumbnailBtn);
                    
                        // Append the button container to the carousel item
                        carouselSubContainer.append(buttonContainer);


                    }
                }
                
                
            }
        }
    });
}

function fnProductDelete(){
    console.log()
}

function fnSetThumbnail(){

}