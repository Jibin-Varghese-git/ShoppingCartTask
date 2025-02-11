function fnValAdminLogin(){
    let userName=document.getElementById("userName").value;
    let password=document.getElementById("password").value;
    document.getElementById("errorUserName").innerHTML=" ";
    document.getElementById("errorPassword").innerHTML=" ";
    document.getElementById("errorUserEntry").innerHTML=" ";

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
    let categoryName=document.getElementById("newCategoryName").value.trim();
    let categoryId=document.getElementById("btnAddCategory").value.trim();
    if(categoryName.length < 1)
    {
        document.getElementById("errorNewCategory").innerHTML="Enter the category name."
        event.preventDefault;
    }
    else {
        if(categoryId.length > 0)
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
    let subcategoryName=document.getElementById("newSubcategoryName").value.trim();
    let categoryId=document.getElementById("categoryListing").value.trim();
    let subcategoryId=document.getElementById("btnAddSubcategory").value.trim();
    alert(subcategoryId)
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
    document.getElementById("btnAddSubcategory").value=" "
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
                document.getElementById("subcategoryModalHeading").innerHTML="Edit SubCategory";
                document.getElementById("btnAddSubcategory").innerHTML="Edit SubCategory"
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
    let productName = document.getElementById("productName").value.trim();
    let productDescription = document.getElementById("productDescription").value.trim();
    let productPrice = document.getElementById("productPrice").value.trim();
    let productTax = document.getElementById("productTax").value.trim();
    let productImage = document.getElementById("productImages").value.trim();
    let productId = document.getElementById("btnAddProducts").value.trim();

    document.getElementById("errorProductName").innerHTML=" "
    document.getElementById("errorProductDescription").innerHTML=" ";
    document.getElementById("errorProductPrice").innerHTML=" ";
    document.getElementById("errorProductTax").innerHTML=" ";
    document.getElementById("errorProductImage").innerHTML=" "

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
                        if(result == "false")
                        {
                            document.getElementById("errorProductName").innerHTML="Product name already exist";
                            event.preventDefault();
                           
                        }
                        else
                        {
                            location.reload()
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
                    if(result == "false")
                    {
                        document.getElementById("errorProductName").innerHTML="Product name already exist";
                        event.preventDefault();
                       
                    }
                    else
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
               document.getElementById("btnAddProducts").innerHTML="Edit Product"
               document.getElementById("modalAddProductsHeading").innerHTML="Edit Product"
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
                carouselContainer.innerHTML = '';

                var thumbnailImageKey=Object.keys(structImageDetails.thumbnailImage);
                const carouselSubContainer = document.createElement('div');
                carouselSubContainer.classList.add('carousel-item');
                carouselSubContainer.style.backgroundColor = '#f0f0f0';
                const image = document.createElement('img');
                image.src = structImageDetails.thumbnailImage[thumbnailImageKey];
                image.style.maxWidth = '27vw';
                image.style.maxHeight = '44vh';
                image.alt = `Image ${key}`;
                carouselSubContainer.append(image);
                carouselSubContainer.classList.add('active');
                carouselContainer.append(carouselSubContainer);
                
                for (var key in structImageDetails.otherImages) {
                    if (structImageDetails.otherImages.hasOwnProperty(key)) {
                        console.log(structImageDetails.otherImages[key]);
                        console.log(key);

                        const carouselSubContainer = document.createElement('div');
                        carouselSubContainer.classList.add('carousel-item');
                        carouselSubContainer.style.backgroundColor = '#f0f0f0';
                        const image = document.createElement('img');
                        image.src = structImageDetails.otherImages[key];
                        image.style.maxWidth = '27vw';
                        image.style.maxHeight = '44vh';
                        image.alt = `Image ${key}`;
                        carouselSubContainer.append(image);

                        const buttonContainer = document.createElement('div');
                        buttonContainer.classList.add('button-container');

                        const deleteBtn = document.createElement('button');
                        deleteBtn.textContent = 'Delete';
                        deleteBtn.value = key;
                        deleteBtn.type='button';
                        deleteBtn.style.margin = '5px';
                        deleteBtn.style.backgroundColor = '#e69696';
                        deleteBtn.onclick = function() {
                            fnProductDelete(this,structImage.productId);
                        };
                    
                        const thumbnailBtn = document.createElement('button');
                        thumbnailBtn.textContent = 'Set as Thumbnail';
                        thumbnailBtn.value = key;
                        thumbnailBtn.type='button';
                        thumbnailBtn.style.margin = '5px';
                        thumbnailBtn.style.backgroundColor = '#018749';
                        thumbnailBtn.onclick = function() {
                            fnSetThumbnail(this,structImage.productId);
                        }   
                        buttonContainer.append(deleteBtn, thumbnailBtn);
                        carouselSubContainer.append(buttonContainer);
                        carouselContainer.append(carouselSubContainer);
                    }
                }  
            }
        }
    });
}

function fnProductDelete(productImageId,productId){
    console.log(productImageId.value)
    $.ajax({
        type:"POST",
        url:"components/shoppingCart.cfc?method=fnDeleteProductImage",
        data:{productImageId : productImageId.value},
        success:function(result){
            if(result){
                fnImageModal({productId:productId});
            }
        }
    });
}

function fnSetThumbnail(productImageId,productId){
    console.log(productImageId.value,productId)
    $.ajax({
        type:"POST",
        url:"components/shoppingCart.cfc?method=fnSetThumbnail",
        data:{  productImageId : productImageId.value,
                productId  : productId
        },
        success:function(result){
            if(result){
                fnImageModal({productId:productId});
            }

        }
    });
}

function fnCloseProduct(){
    document.getElementById("productForm").reset();
    document.getElementById("btnAddProducts").innerHTML="Add Product";
    document.getElementById("modalAddProductsHeading").innerHTML="Add Product";
    document.getElementById("errorProductName").innerHTML=" ";
    document.getElementById("errorProductDescription").innerHTML=" ";
    document.getElementById("errorProductPrice").innerHTML=" ";
    document.getElementById("errorProductTax").innerHTML=" ";
    document.getElementById("errorProductImage").innerHTML=" "
}