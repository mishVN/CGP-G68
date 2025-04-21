<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Customer Support</title>
  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f0f2f5;
    }

    header {
      background-color: #043659;
      color: #ffffff;
      padding: 30px 20px;
      text-align: center;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    }

    header h1 {
      font-size: 2rem;
      margin: 0;
    }

    .main-container {
      max-width: 600px;
      margin: 40px auto;
      background-color: #ffffff;
      padding: 40px 30px;
      border-radius: 16px;
      box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
    }

    .main-container h2 {
      margin-bottom: 25px;
      color: #043659;
      font-size: 24px;
    }

    input[type="text"] {
      width: 100%;
      padding: 14px;
      margin-bottom: 20px;
      border: 2px solid #0072ff;
      border-radius: 10px;
      font-size: 16px;
      transition: border-color 0.3s, box-shadow 0.3s;
    }

    input[type="text"]:focus {
      border-color: #00c6ff;
      box-shadow: 0 0 6px rgba(0, 198, 255, 0.5);
      outline: none;
    }

    .btn {
      background: linear-gradient(135deg, #0072ff, #00c6ff);
      color: white;
      padding: 14px 28px;
      font-size: 16px;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .btn:hover {
      transform: scale(1.05);
      background: linear-gradient(135deg, #005ecb, #009dcc);
    }

    .note {
      font-size: 14px;
      color: #777;
      margin-top: 15px;
    }

    /* Responsive layout */
    @media (max-width: 600px) {
      .main-container {
        margin: 20px;
        padding: 30px 20px;
      }
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

  <header>
    <h1>Customer Support</h1>
  </header>

  <div class="main-container">
    <h2>Find Delivery Contact</h2>
    <input type="text" id="order_id" placeholder="Enter Order ID">
    <button class="btn" onclick="searchContact()">Search</button>
    <p class="note">You will be redirected to the contact info page.</p>
  </div>

</body>
</html>
