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
		<cfset variables.orderListing=local.objUserShoppingCart.selectOrderTable()>
		<cfset variables.orderedItemListing=local.objUserShoppingCart.selectOrderedItemsTable()>
		<cfinclude  template="userHeader.cfm">
		<div class="mainContainerHistory p-2">
			<div class="headContainerHistory pt-2 px-3 py-1 mb-2 d-flex justify-content-between">
				<div class="headingOrderHistory">
					<span>Order History</span>
				</div>
				<div class="searchbarDivOrder d-flex w-100">
            		<form method="post" class="w-100">
            		    <input type="text" oninput="searchOrder()" class="searchInputOrder w-100 p-2" name="searchInputOrder" id="searchInputOrder" placeholder="Search order using the order id" required>
            		</form>
        		</div>
			</div>
			<div class="subContainerHistory">
				<cfloop query="variables.orderListing">
					<cfoutput>
						<div class="singleOrderHistoryContainer p-2" id="#variables.orderListing.orderId#">
							<div class="singleOrderHistory rounded-4">
								<div class="singleOrderHeading py-2 px-3 d-flex justify-content-between rounded-4 rounded-bottom-0">
									<div>
										<span class="heading">Order Id :</span>
										<span>#variables.orderListing.orderId#</span>
									</div>
									<div>
										<span class="heading">Order Date:</span>
										<cfset variables.date =dateFormat(variables.orderListing.orderDate,"dd-mm-yyyy")>
										<span>#variables.date#</span>
									</div>
									<div>
										<button class="pdfBtnOrder" value="#variables.orderListing.orderId#" onclick="invoiceDownload(this)">
											<i class="fa-solid fa-file-pdf" style="color: ##ad0000;"></i>
											<span class="tooltiptext">Invoice</span>
										</button>	
									</div>
								</div>
								<cfloop query="variables.orderedItemListing">
									<cfif variables.orderedItemListing.orderId EQ variables.orderListing.orderId>
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
									</cfif>
								</cfloop>
								<div class="singleOrderFooter px-3 d-flex justify-content-between p-3 rounded-4 rounded-top-0">
									<div>
										<span>Total Amount :</span>
										<i class="fa-solid fa-indian-rupee-sign"></i>
										<span>#variables.orderListing.totalPrice + variables.orderListing.totalTax#</span>
									</div>
									<div>
										<span>Delivery Address:</span>
										<span>
										#variables.orderListing.addressline1#,
										#variables.orderListing.addressline2#,
										#variables.orderListing.city#,
										#variables.orderListing.state#,
										#variables.orderListing.pincode#
										</span>
									</div>
								</div>
							</div>
						</div>
					</cfoutput>
				</cfloop>

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