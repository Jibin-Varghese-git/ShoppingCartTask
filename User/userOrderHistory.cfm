<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Order History</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="../bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/userSignin.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
		<cfset local.objUserShoppingCart = createObject("component","components/userShoppingCart")>
		<cfset variables.orderHistoryCount = local.objUserShoppingCart.orderHistoryCount()>
		<cfif structKeyExists(url, "page")>
			<cfset variables.orderedItemListing=local.objUserShoppingCart.selectOrderedItemsTable(pageValue=url.page)>	
		<cfelseif structKeyExists(url, "search")>
			<cfset variables.orderedItemListing=local.objUserShoppingCart.selectOrderedItemsTable(search=url.search)>
		<cfelse>
			<cfset variables.orderedItemListing=local.objUserShoppingCart.selectOrderedItemsTable(pageValue=1)>
		</cfif>
		<cfinclude  template="userHeader.cfm">
		<div class="mainContainerHistory p-2">
			<div class="headContainerHistory pt-2 px-3 py-1 mb-2 d-flex justify-content-between">
				<div class="headingOrderHistory">
					<span>Order History</span>
				</div>
				<div class="searchbarDivOrder d-flex w-100">
					<form method="post" class="w-100">
						<div class="orderSearchDiv d-flex">
							<input type="text" class="searchInputOrder w-75 p-2" name="searchInputOrder" id="searchInputOrder" placeholder="Search order using the order id" required>
							<button type="submit" name="searchOrderBtn"><i class="fa-solid fa-magnifying-glass"></i></button>
						</div>
					</form>
				</div>	
			</div>
			<cfif structKeyExists(form, "searchOrderBtn")>
				<cflocation  url="userOrderHistory.cfm?search=#form.SEARCHINPUTORDER#" addToken="no">
			</cfif>
			<div class="subContainerHistory">
				<cfoutput>
				<cfif queryrecordcount(variables.orderedItemListing) LT 1>
					<div class="p-3">
						<h3>No Orders Found</h3>
					</div>
				<cfelse>
					<div class="p-3">
						<cfif structKeyExists(url, "search")>
							<h3>Search results for "#url.search#"</h3>
						</cfif>
					</div>
				</cfif>
				</cfoutput>
				<cfoutput query="variables.orderedItemListing" group="orderId">
					<div class="singleOrderHistoryContainer p-2" id="#variables.orderedItemListing.orderId#">
						<div class="singleOrderHistory rounded-4">
							<div class="singleOrderHeading py-2 px-3 d-flex justify-content-between rounded-4 rounded-bottom-0">
								<div>
									<span class="heading">Order Id :</span>
									<span>#variables.orderedItemListing.orderId#</span>
								</div>
								<div>
									<span class="heading">Order Date:</span>
									<cfset variables.date = dateFormat(variables.orderedItemListing.orderDate,"dd-mm-yyyy")>
									<span>#variables.date#</span>
								</div>
								<div>
									<button class="pdfBtnOrder" value="#variables.orderedItemListing.orderId#" onclick="invoiceDownload(this)">
										<i class="fa-solid fa-file-pdf" style="color: ##ad0000;"></i>
										<span class="tooltiptext">Invoice</span>
									</button>	
								</div>
							</div>
							<cfoutput>
								<div class="productContainer d-flex justify-content-between p-3">
									<div class="imageDiv">
										<img class="rounded" src="../Assets/productImages/#variables.orderedItemListing.imageName#" alt="No Image Found">
									</div>
									<div class="productDetailsContainer p-2">
										<span class="productHeading mb-3">#variables.orderedItemListing.productName#</span><br>
										<span class="productDesc text-truncate">#variables.orderedItemListing.description#</span>
									</div>
									<div class="quantityContainer  p-2">
										<span class="qty">Quantity : </span>
										<span>#variables.orderedItemListing.quantity#</span>
									</div>
								</div>
								<hr class="m-0">
							</cfoutput>
							<div class="singleOrderFooter px-3 d-flex justify-content-between p-3 rounded-4 rounded-top-0">
								<div>
									<span>Total Amount :</span>
									<i class="fa-solid fa-indian-rupee-sign"></i>
									<span>#variables.orderedItemListing.totalPrice + variables.orderedItemListing.totalTax#</span>
								</div>
								<div>
									<span>Delivery Address:</span>
									<span>
									#variables.orderedItemListing.addressline1#,
									#variables.orderedItemListing.addressline2#,
									#variables.orderedItemListing.city#,
									#variables.orderedItemListing.state#,
									#variables.orderedItemListing.pincode#
									</span>
								</div>
							</div>
						</div>
					</div>
				</cfoutput>
				<cfif structKeyExists(url, "page") AND variables.orderHistoryCount.itemCount GT 0>
					<cfoutput>
						<div class="py-4 w-100 d-flex justify-content-center border">
							<nav aria-label="Page navigation example">
  								<ul class="pagination">
  								  	<li class="page-item">
										<a 
											class="page-link" 
											href="userOrderHistory.cfm?page=
												<cfif url.page EQ 1>
													1
												<cfelse>
													#url.page -1#
												</cfif>
										">
											Previous
										</a>
									</li>
									<cfloop index="i" from="#url.page#" to="#round(variables.orderHistoryCount.itemCount/5)#">
										<li class="page-item"><a class="page-link" href="userOrderHistory.cfm?page=#i#">#i#</a></li>
									</cfloop>
  									<li class="page-item">
										<a
											class="page-link"
											href="userOrderHistory.cfm?page=
												<cfif url.page EQ round(variables.orderHistoryCount.itemCount/5)>
													#round(variables.orderHistoryCount.itemCount/5)#
												<cfelse>
													#url.page + 1#
												</cfif>
											"
										>
											Next
										</a>
									</li>
  								</ul>
							</nav>
						</div>
					</cfoutput>
				</cfif>
			</div>
		</div>
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	 	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="../js/userScript.js" async defer></script>
    </body>
</html>