<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" 
          content="width=device-width, 
                   initial-scale=1.0">
    <title>
        404 Page Not Found
    </title>
    <link rel="stylesheet" 
          href="../css/errorStyle.css">
</head>

<body>
    <div class="error-container">
        <div>
            <h1> 404 </h1>
            <cfoutput>
                <p>
                    #url.exception#
                </p>
            </cfoutput>
            <a href="userHome.cfm">
                Go Back to Home
            </a>
        </div>
    </div>
</body>

</html>