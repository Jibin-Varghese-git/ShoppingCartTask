<cfoutput>
    <cfset local.objUserShoppingCart = createObject("component","components/userShoppingCart")>
    <header class="py-2 px-3 d-flex justify-content-between align-item-center">
        <a href="userHome.cfm" class="d-flex"> 
            <div class="headerImageDiv">
                <img src="../Assets/Images/iconCartUser.png" alt="No Image Found">
            </div>
            <h5 class="logoHeading ms-1 mt-3">E-CART</h5>
        </a>
        <div class="searchbarDiv d-flex">
            <form method="post">
                <input type="text" class="searchInput" name="searchInput" id="searchInput" required>
                <button name="searchBtn" class="searchBtn" type="submit"><i class="fa-solid fa-magnifying-glass" ></i></button>
            </form>
        </div>
        <div class="headerBtnClass mt-1">
            
            
            <a href="userCart.cfm" class="cartBtnHeader mx-3">
                <div class="cartTooltip">
                   <i class="fa-solid fa-cart-shopping"></i>
                    <cfif structKeyExists(session,"structUserDetails")> 
                        <cfset productListingCart = local.objUserShoppingCart.selectProductCart()>
                        <cfoutput>
                            <span class="badge" id="cartItemQuantityHeader">#queryRecordCount(productListingCart)#</span>
                        </cfoutput>
                   </cfif> 
                    <span class="tooltiptext">Cart</span>
                </div>
            </a>
         
            <div class="profileTooltip">
                <a href="userProfile.cfm" class="profileBtn mx-3"><i class="fa-solid fa-user" ></i></a>
                <span class="tooltiptext">Profile</span>
            </div>
                <cfif structKeyExists(session,"structUserDetails")>
                    <button name="logoutBtn" onClick="logoutUser()" type="button"><i class="fa-solid fa-arrow-right-to-bracket" ></i>Logout</button>
                <cfelse>
                    <a href="userLogin.cfm"><button name="loginBtn" onClick="" type="button"><i class="fa-solid fa-arrow-right-to-bracket" ></i>Login</button></a>
                </cfif>

        </div>  
        <cfif structKeyExists(form, "searchBtn")>
            <cfif len(trim(form.searchInput)) GT 0>
                <cflocation  url="userSubcategory.cfm?search=#trim(form.searchInput)#" addToken="no">
            </cfif>
        </cfif>
    </header>
</cfoutput>