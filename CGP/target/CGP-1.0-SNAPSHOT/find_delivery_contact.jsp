<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Find Delivery Contact</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            width: 400px;
            text-align: center;
        }

        h2 {
            color: #0072ff;
            font-weight: 600;
            margin-bottom: 25px;
            font-size: 24px;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 20px;
            border: 2px solid #0072ff;
            border-radius: 8px;
            font-size: 16px;
            transition: 0.3s;
        }

        input[type="text"]:focus {
            outline: none;
            border-color: #00c6ff;
            box-shadow: 0 0 5px rgba(0, 198, 255, 0.5);
        }

        .btn {
            background-color: #0072ff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn:hover {
            background-color: #005ecb;
            transform: scale(1.05);
        }

        .note {
            margin-top: 15px;
            font-size: 13px;
            color: #777;
        }
    </style>
    <script>
        function searchContact() {
            const orderId = document.getElementById("order_id").value.trim();
            if (orderId === "") {
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
        <button class="btn" onclick="searchContact()">Search</button>
        <p class="note">You will be redirected to contact info page.</p>
    </div>
</body>
</html>
