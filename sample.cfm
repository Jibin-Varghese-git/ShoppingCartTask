<!DOCTYPE html>

<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="../bootstrap-5.3.3-dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/userSignin.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <div class="orderPlacedMainDiv border border-danger mt-5">
            <div class="confirmImageDiv border border-info">
                    <img src="Assets/Images/checkmark.gif" alt="No Image Found">
            </div>
            <div class="orderConfrimMessage">
                <span>Your Order has been Placed!</span><br>
                <span>Your Order Id is sent to the given mail id.</span>
            </div>
            <div class="orderConfirmBtnDiv d-flex p-2">
                <a href="userHome.cfm" class="homeBtn p-3 me-1 btn">
                    Go Back To Home
                </a>
                <a href="userOrderHistory.cfm" class="orderHistoryBtn p-3 ms-1 btn">
                    Order History
                </a>
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