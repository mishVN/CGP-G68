<!DOCTYPE html>
<html>
<head>
    <title>Find Delivery Contact</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 350px;
        }

        h2 {
            margin-bottom: 30px;
            color: #333;
        }

        input {
            padding: 12px;
            width: 80%;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .btn {
            padding: 12px 25px;
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            display: inline-block;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #218838;
        }
    </style>
    <script>
        function searchContact() {
            const orderId = document.getElementById("order_id").value;
            if (orderId.trim() === "") {
                alert("Please enter an Order ID");
                return;
            }
            window.location.href = "get_contact.jsp?order_id=" + encodeURIComponent(orderId);
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Find Delivery Contact</h2>
        <input type="text" id="order_id" placeholder="Enter Order ID">
        <br>
        <a class="btn" href="javascript:void(0);" onclick="searchContact()">Search</a>
    </div>
</body>
</html>