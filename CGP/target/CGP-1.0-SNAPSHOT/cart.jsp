<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
            text-align: center;
        }
        .cart-container {
            width: 80%;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .cart-item {
            display: flex;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .cart-item img {
            width: 80px;
            height: 80px;
            border-radius: 5px;
            margin-right: 15px;
        }
        .cart-item-details {
            flex-grow: 1;
            text-align: left;
        }
        .cart-total {
            font-size: 18px;
            font-weight: bold;
            margin-top: 20px;
        }
        .btn-checkout, .btn-remove {
            margin-top: 10px;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-checkout {
            background-color: #28a745;
            color: white;
        }
        .btn-remove {
            background-color: #dc3545;
            color: white;
        }
        .btn-checkout:hover, .btn-remove:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>

<div class="cart-container">
    <h2>Your Shopping Cart</h2>

    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int totalPrice = 0;

        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart != null && !cart.isEmpty()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    int itemCode = entry.getKey();
                    int quantity = entry.getValue();

                    stmt = conn.prepareStatement("SELECT item_name, price, img_url FROM items WHERE item_code = ?");
                    stmt.setInt(1, itemCode);
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        String itemName = rs.getString("item_name");
                        int price = rs.getInt("price");
                        String imageUrl = rs.getString("img_url");
                        int itemTotal = price * quantity;
                        totalPrice += itemTotal;
    %>
                        <div class="cart-item">
                            <img src="<%= imageUrl %>" alt="Item Image">
                            <div class="cart-item-details">
                                <p><strong><%= itemName %></strong></p>
                                <p>Price: Rs. <%= price %></p>
                                <p>Quantity: <%= quantity %></p>
                                <p><strong>Total: Rs. <%= itemTotal %></strong></p>
                            </div>
                            <form action="remove_from_cart.jsp" method="post">
                                <input type="hidden" name="itemCode" value="<%= itemCode %>">
                                <button type="submit" class="btn-remove">Remove</button>
                            </form>
                        </div>
    <%
                    }
                    rs.close();
                    stmt.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (conn != null) conn.close();
            }
        } else {
    %>
        <p>Your cart is empty.</p>
    <%
        }
    %>

    <p class="cart-total">Total Price: Rs. <%= totalPrice %></p>

    <button class="btn-checkout" onclick="window.location.href='placeoder.jsp'">Buy Now</button>
</div>

</body>
</html>