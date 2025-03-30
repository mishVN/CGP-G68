<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

    <%
        int itemCode = 0;
        String itemName = "";
        String itemDescription = "";
        String itemImage = "";
        String itemPrice = "";
        String currentUsername = "";

        try {
            itemCode = Integer.parseInt(request.getParameter("item"));

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            // Fetch item details
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM items WHERE item_code = ?");
            stmt.setInt(1, itemCode);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                itemName = rs.getString("item_name");
                itemDescription = rs.getString("item_description");
                itemImage = rs.getString("img_url");
                itemPrice = rs.getString("price");
            }
            rs.close();
            stmt.close();

            // Fetch current username from temp_login table
            stmt = conn.prepareStatement("SELECT username FROM temp_login_shop");
            rs = stmt.executeQuery();
            if (rs.next()) {
                currentUsername = rs.getString("username");
            }
            rs.close();
            stmt.close();

            // Fetch feedback for this item
            List<Map<String, String>> feedbackList = new ArrayList<>();
            stmt = conn.prepareStatement("SELECT username, feedback, date FROM item_feedback WHERE item_code = ?");
            stmt.setInt(1, itemCode);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> feedbackData = new HashMap<>();
                feedbackData.put("username", rs.getString("username"));
                feedbackData.put("feedback", rs.getString("feedback"));
                feedbackData.put("date", rs.getString("date"));
                feedbackList.add(feedbackData);
            }
            rs.close();
            stmt.close();
            conn.close();

            request.setAttribute("feedbackList", feedbackList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= itemName %> - Details</title>
        <style>
            body {
                font-family: "Poppins", sans-serif;
                background-color: #f8f9fa;
                margin: 0;
                padding: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
            }

            .item-container {
        margin-top: 30px;
        background: white;
        width: 80%;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        animation: slideIn 0.5s ease-in-out;
        display: flex; /* Makes image & details sit side by side */
        flex-direction: row; /* Ensures they are in a row */
        align-items: center; /* Aligns them vertically */
        justify-content: space-between; /* Adds spacing */
    }

    .item-image {
        width: 50%;
        max-height: 400px; /* Ensures image height is balanced */
        border-radius: 10px;
        object-fit: cover;
    }

    .item-details {
        width: 50%;
        padding: 20px;
        text-align: left; /* Ensures text stays aligned to left */
    }

    /* Responsive design for smaller screens */
    @media (max-width: 768px) {
        .item-container {
            flex-direction: column; /* Stack items vertically */
            width: 90%;
            text-align: center;
        }

        .item-image {
            width: 100%;
            max-height: 300px;
        }

        .item-details {
            width: 100%;
        }
    }

            .item-title {
                font-size: 28px;
                font-weight: bold;
                color: #333;
                margin-bottom: 10px;
            }

            .item-description {
                font-size: 16px;
                color: #666;
                line-height: 1.5;
            }

            .item-price {
                font-size: 22px;
                font-weight: bold;
                color: #e44d26;
                margin-top: 15px;
            }

            .feedback-section {
               
            }

            .feedback-card {
                background: #f1f1f1;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 10px;
                transition: transform 0.3s;
            }

            .feedback-card:hover {
                transform: scale(1.02);
            }

            .feedback-input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-top: 10px;
            }

            .btn-submit {
                background-color: #28a745;
                color: white;
                padding: 10px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin-top: 10px;
            }

            .btn-submit:hover {
                opacity: 0.8;
            }

            @keyframes fadeIn {
                0% { opacity: 0; transform: translateY(-10px); }
                100% { opacity: 1; transform: translateY(0); }
            }

            @keyframes slideIn {
                0% { opacity: 0; transform: translateX(-10px); }
                100% { opacity: 1; transform: translateX(0); }
            }
            .button-container {
                margin-top: 20px;
                display: flex;
                gap: 10px;
            }

            .btn {
                padding: 12px 16px;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-back {
                background-color: #6c757d;
                color: white;
            }

            .btn-cart {
                background-color: #ff9800;
                color: white;
            }

            .btn-buy {
                background-color: #28a745;
                color: white;
            }

            .btn:hover {
                opacity: 0.8;
            }

            @keyframes fadeIn {
                0% { opacity: 0; transform: translateY(-10px); }
                100% { opacity: 1; transform: translateY(0); }
            }

            @media (max-width: 768px) {
                .item-container {
                    flex-direction: column;
                    text-align: center;
                }

                .item-image {
                    width: 100%;
                    height: 250px;
                }

                .item-details {
                    width: 100%;
                }

                .button-container {
                    justify-content: center;
                }
            }
                .quantity-container {
                margin-top: 15px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .quantity-btn {
                width: 40px;
                height: 40px;
                font-size: 20px;
                border: none;
                background-color: #ff9800;
                color: white;
                border-radius: 5px;
                cursor: pointer;
                transition: 0.3s;
            }

            .quantity-btn:hover {
                background-color: #e68a00;
            }

            .quantity-input {
                width: 50px;
                text-align: center;
                font-size: 18px;
                border: 1px solid #ccc;
                border-radius: 5px;
                padding: 5px;
            }

            .total-price {
                font-size: 20px;
                font-weight: bold;
                color: #28a745;
                margin-top: 10px;
            }
            .main-container{
                margin-top: 30px;
                background: white;
                width: 80%;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                animation: slideIn 0.5s ease-in-out;
            }

        </style>
    </head>
    <body>
<div class="main-container">
    <div class="item-container">
        <img src="<%= itemImage %>" alt="<%= itemName %>" class="item-image">
        <div class="item-details">
            <h2 class="item-title"><%= itemName %></h2>
            <p class="item-description"><%= itemDescription %></p>
            <p class="item-price"><strong>Price:</strong> Rs. <%= itemPrice %></p>

            <div class="quantity-container">
                <button class="quantity-btn" onclick="changeQuantity(-1)">-</button>
                <input type="text" id="quantity" class="quantity-input" value="1" readonly>
                <button class="quantity-btn" onclick="changeQuantity(1)">+</button>
            </div>

            <p class="total-price" id="totalPrice">Total: Rs. <%= itemPrice %></p>

            <div class="button-container">
                <button class="btn btn-back" onclick="history.back()">Go Back</button>
                <button class="btn btn-cart" onclick="addToCart()">Add to Cart</button>
                <button class="btn btn-buy" onclick="buyNow()">Buy Now</button>
                <button class="btn btn-cart" onclick="location.href='cart.jsp'">View Cart</button>

            </div>

        </div>
    </div>
    <script>
        // Convert price to a number
        var price = parseFloat(<%= itemPrice %>);
        var quantityInput = document.getElementById("quantity");
        var totalPriceDisplay = document.getElementById("totalPrice");

        // ? Update quantity and ensure min value is 1
        function changeQuantity(amount) {
            var quantity = parseInt(quantityInput.value) + amount;
            if (quantity < 1) quantity = 1; // Prevent negative quantity
            quantityInput.value = quantity;
            updateTotal();
        }

        // ? Calculate and display total price
        function updateTotal() {
            var quantity = parseInt(quantityInput.value);
            var total = (price * quantity).toFixed(2); // Fix floating point issues
            totalPriceDisplay.innerText = "Total: Rs. " + total;
        }

       
    function addToCart() {
    var itemCode = "<%= itemCode %>";
    var quantity = parseInt(document.getElementById("quantity").value);

    if (isNaN(quantity) || quantity <= 0) {
        alert("Please enter a valid quantity!");
        return;
    }

    // Fetch current cart from session storage
    var cart = JSON.parse(sessionStorage.getItem("cart")) || {};

    // Update quantity if item already exists
    if (cart[itemCode]) {
        cart[itemCode] += quantity;
    } else {
        cart[itemCode] = quantity;
    }

    // Save updated cart back to session storage
    sessionStorage.setItem("cart", JSON.stringify(cart));
    alert("Added to cart successfully!");

    // Send data to session in server-side JSP
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "update_cart.jsp", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send("itemCode=" + itemCode + "&quantity=" + quantity);
}


        // ? Redirect to Payment with quantity
        function buyNow() {
            var quantity = document.getElementById("quantity").value;
            window.location.href = "placeoder.jsp?item=<%= itemCode %>&quantity=" + quantity;
        }

    </script>


   <div class="feedback-section">
    <h2>Customer Feedback</h2>

    <!-- Feedback Form (Now at the Top) -->
    <form method="post">
        <input type="hidden" name="itemCode" value="<%= itemCode %>">
        <input type="hidden" name="username" value="<%= currentUsername %>">
        <textarea name="feedback" class="feedback-input" placeholder="Write your feedback..." required></textarea>
        <button type="submit" class="btn-submit">Submit Feedback</button>
    </form>

    <!-- Feedback List (Now Below the Form, Newest First) -->
    <div id="feedbackList">
        <% 
            List<Map<String, String>> feedbackList = (List<Map<String, String>>) request.getAttribute("feedbackList");
            if (feedbackList != null && !feedbackList.isEmpty()) { 
                Collections.reverse(feedbackList); // Reverse to show latest first
                for (Map<String, String> feedback : feedbackList) { 
        %>
            <div class="feedback-card">
                <p><strong><%= feedback.get("username") %></strong> (on <%= feedback.get("date") %>)</p>
                <p><%= feedback.get("feedback") %></p>
            </div>
        <% 
                } 
            } else { 
        %>
            <p>No feedback yet.</p>
        <% } %>
    </div>


    <%
        // Handle feedback submission
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String feedbackText = request.getParameter("feedback");
            String username = request.getParameter("username");
            String date = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

            if (feedbackText != null && !feedbackText.trim().isEmpty() && username != null) {
                try {
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                    PreparedStatement stmt = conn.prepareStatement("INSERT INTO item_feedback (item_code, username, feedback, date) VALUES (?, ?, ?, ?)");
                    stmt.setInt(1, itemCode);
                    stmt.setString(2, username);
                    stmt.setString(3, feedbackText);
                    stmt.setString(4, date);
                    stmt.executeUpdate();
                    stmt.close();
                    conn.close();

                    response.sendRedirect("description_page.jsp?item=" + itemCode);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    %>
<div>
    </body>
    </html>