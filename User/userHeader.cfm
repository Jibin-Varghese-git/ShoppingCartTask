<cfoutput>
    <header class="py-2 px-3 d-flex justify-content-between align-item-center">
            <a href="userHome.cfm" class="d-flex"> 
                <div class="headerImageDiv">
                    <img src="../Assets/Images/iconCartUser.png" alt="No Image Found">
                </div>
                <h5 class="logoHeading ms-1 mt-3">E-CART</h5>
            </a>
            <div class="searchbarDiv d-flex">
                <form method="post">
                    <input type="text" class="searchInput" name="searchInput" id="searchInput">
                    <button name="searchBtn" class="searchBtn" type="submit"><i class="fa-solid fa-magnifying-glass" ></i></button>
                </form>
            </div>
            <div class="headerBtnClass mt-1">
                <button name="cartBtn" onClick="" class="mx-2" type="button"><i class="fa-solid fa-cart-shopping" ></i></button>
                <button name="profileBtn" onClick="" class="mx-2" type="button"><i class="fa-solid fa-user" ></i></button>
                <cfif structKeyExists(session,"structUserDetails")>
                    <button name="logoutBtn" onClick="logoutUser()" type="button"><i class="fa-solid fa-arrow-right-to-bracket" ></i>Logout</button>
                <cfelse>
                    <a href="userLogin.cfm"><button name="loginBtn" onClick="" type="button"><i class="fa-solid fa-arrow-right-to-bracket" ></i>Login</button></a>
                </cfif>
            </div>  
            <cfif structKeyExists(form, "searchBtn")>
            <cflocation  url="userSubcategory.cfm?search=#form.searchInput#" addToken="no">
        </cfif>
    </header>
</cfoutput>