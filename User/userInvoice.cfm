<cfset local.today = dateTimeFormat(now(),"dd-mm-yy-HH.nn.SS")>
<cfset local.filename = "#session.structUserDetails["firstName"]#" & "#local.today#">
    <cfset local.objUserShoppingCart = createObject("component","components/userShoppingCart")>
		<cfset variables.orderListing=local.objUserShoppingCart.selectOrderTable(arguments.orderId)>
		<cfset variables.orderedItemListing=local.objUserShoppingCart.selectOrderedItemsTable(arguments.orderId)>
<cfdocument  format="PDF" filename="../Assets/Invoices/#local.filename#.pdf" overwrite="true">
    <cfoutput>
        <div class="mainContainer">
            <div class="heading">
            <span>ORDER INVOICE</span>
            </div>
            <div class="userDetails">
                <div class="userDetailsContainer1">
                    <span>User Name :</span>
                    <span>#variables.orderListing.firstName# #variables.orderListing.lastName#</span>
                </div>
                <div class="userDetailsContainer1">
                    <span>Contact No :</span>
                    <span>#variables.orderListing.phoneNumber#</span>
                </div>
                <cfset variables.orderDate=dateFormat(#variables.orderListing.orderDate#,"dd-mm-yyyy")>
                <div class="userDetailsContainer1">
                    <span>Ordered Date : #variables.orderDate#</span>
                </div>
                <div class="userDetailsContainer1">
                        <span>Delivery Address :</span>
                        <span>#variables.orderListing.addressline1#,
                            #variables.orderListing.addressline2#,
                        </span>
                        <span>
                            #variables.orderListing.city#,
                            #variables.orderListing.state#,
                            #variables.orderListing.pincode#
                        </span>
            
                </div>
            </div>
            <div class="orderDetailDiv">
                <div>
                    <span>ORDER ID : #url.orderId#</span>
                </div>
            </div>
            <table border="1">
                <tr>
                    <th>
                        Product Name
                    </th>
                    <th>
                        Quantity
                    </th>
                    <th>
                        Price
                    </th>
                    <th>
                        Tax
                    </th>
                    <th>
                        Total Price
                    </th>
                </tr>
                <cfloop query="variables.orderedItemListing">
                    <tr>
                        <td>
                            #variables.orderedItemListing.productName#
                        </td>
                        <td>
                            #variables.orderedItemListing.quantity#
                        </td>
                        <td>
                            #variables.orderedItemListing.unitPrice#
                        </td>
                        <td>
                            #variables.orderedItemListing.unitTax#
                        </td>
                        <td>
                            #(variables.orderedItemListing.unitPrice *  variables.orderedItemListing.quantity) + (variables.orderedItemListing.unitTax *  variables.orderedItemListing.quantity)#
                        </td>
                    </tr>
                </cfloop>
            </table>
            <div class="totalPriceDiv">
                    <span>Total Price : #variables.orderListing.totalPrice + variables.orderListing.totalTax#/-</span>
            </div>
        </div>

        <style>
            .mainContainer{
                border: 1px solid;
                width: 90%;
                padding: 5px;
            }
            .mainContainer .heading{
                width: 93%;
                background-color: rgb(159, 122, 184);
                color:rgb(255, 255, 255);
                text-align: center;
                padding: 20px;
            }
            .heading span{
                font-size: 20px;
                font-weight: 700;
            }
            .userDetails .userDetailsContainer1{
                display: flex;
                margin: 10px;
                white-space: nowrap;
            }
            .userDetails .userDetailsContainer1 div{
                margin: 5px;
            }
            .orderdetailDiv{
                width: auto;
                background-color: rgb(148, 7, 77);
                padding: 15px;
                color: rgb(255, 255, 255);
                font-weight: 700;
            }
            table{
                width:100%;
                border: 1px solid;
                padding: 0;
            }
            th{
                padding:10px;
                white-space: nowrap;
                border: none;
            }
            td{
                padding :20px 25px;
                white-space: nowrap;
                border: none;
            }
            .totalPriceDiv{
                padding: 10px;
                font-size: 20px;
                font-weight: 800;
            }
        </style>
    </cfoutput>
</cfdocument>