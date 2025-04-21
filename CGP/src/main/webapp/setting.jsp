<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>setting</title>
    <style>
        /* Basic styling */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        header {
            background-color: green; /* Changed to green */
            color: #fff;
            text-align: center;
            padding: 20px;
        }

        h1 {
            margin: 0;
        }

        .container {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* 4 items in a row */
            grid-gap: 20px;
            margin: 20px;
        }

        .service {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .service:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
        }

        .service h3 {
            margin: 15px 0;
            color: #333;
        }

        .service p {
            color: #666;
        }

        /* Logo styling */
        .service img {
            width: 50px; /* Adjust the logo size */
            height: 50px;
            margin-bottom: 15px;
        }

        /* Responsive design for smaller screens */
        @media (max-width: 800px) {
            .container {
                grid-template-columns: repeat(2, 1fr); /* 2 items per row */
            }
        }

        @media (max-width: 500px) {
            .container {
                grid-template-columns: 1fr; /* 1 item per row */
            }
        }
    </style>
</head>
<body>

    <header>
        <h1>Setting</h1>
    </header>

    <div class="container">
        <a href="change_password.jsp"><div class="service">
         <img src="https://cdn-icons-png.freepik.com/256/11135/11135322.png?semt=ais_hybrid" alt="Service Logo 1">
            <h3>Change Password</h3>
            </div></a>
        
            <a href="customer_support.jsp"><div class="service">
            <img src="https://cdn-icons-png.freepik.com/256/8781/8781830.png?semt=ais_hybrid" alt="Service Logo 2">
            <h3>Customer Support</h3>
                </div></a>
        
        <a href="find_delivery_contact.jsp"><div class="service">
            <img src="https://i.pinimg.com/736x/fc/27/fb/fc27fb81e77cc56ba4ed981d7801ceb9.jpg" alt="Service Logo 2">
            <h3>Contact Delivery Boy</h3>
                </div></a>
        
        
    </div>

</body>
</html>