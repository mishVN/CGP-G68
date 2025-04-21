<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Retrieve the cart from the session
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    int totalPrice = 0;

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp"); // Redirect to cart if empty
        return; // Stop execution to prevent further errors
    }

    // Declare connection once
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

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
                int price = rs.getInt("price");
                totalPrice += price * quantity;
            }

            rs.close();
            stmt.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) conn.close();
    }
%>

<%
    if (request.getMethod().equalsIgnoreCase("post")) {
        // Retrieve form parameters
        String fullName = request.getParameter("full-name");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String province = request.getParameter("province");
        String deliveryMethod = request.getParameter("delevery");
        String phone = request.getParameter("phone");
        String addressName = request.getParameter("address-name");
        String saveAddress = request.getParameter("save-address");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            // Calculate total price including delivery
            int deliveryCost = 0;
            Map<String, Integer> deliveryCosts = new HashMap<>();
            deliveryCosts.put("Ampara", 700);
            deliveryCosts.put("Anuradhapura", 550);
            deliveryCosts.put("Badulla", 600);
            deliveryCosts.put("Batticaloa", 750);
            deliveryCosts.put("Colombo", 300);
            deliveryCosts.put("Galle", 450);
            deliveryCosts.put("Gampaha", 350);
            deliveryCosts.put("Hambantota", 500);
            deliveryCosts.put("Jaffna", 800);
            deliveryCosts.put("Kandy", 400);
            deliveryCosts.put("Kegalle", 420);
            deliveryCosts.put("Kilinochchi", 850);
            deliveryCosts.put("Kurunegala", 450);
            deliveryCosts.put("Mannar", 750);
            deliveryCosts.put("Matale", 430);
            deliveryCosts.put("Matara", 500);
            deliveryCosts.put("Monaragala", 600);
            deliveryCosts.put("Mullaitivu", 820);
            deliveryCosts.put("Nuwara Eliya", 480);
            deliveryCosts.put("Polonnaruwa", 520);
            deliveryCosts.put("Puttalam", 470);
            deliveryCosts.put("Ratnapura", 490);
            deliveryCosts.put("Trincomalee", 650);
            deliveryCosts.put("Vavuniya", 780);
            deliveryCosts.put("Kalutara", 360);

            if (deliveryCosts.containsKey(district)) {
                deliveryCost = deliveryCosts.get(district);
            }

            // Calculate total price
            if (cart != null && !cart.isEmpty()) {
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    int itemCode = entry.getKey();
                    int quantity = entry.getValue();

                    PreparedStatement itemStmt = conn.prepareStatement("SELECT price FROM items WHERE item_code = ?");
                    itemStmt.setInt(1, itemCode);

                    if (rs.next()) {
                        int price = rs.getInt("price");
                        totalPrice += price * quantity;
                    }
                    rs.close();
                    itemStmt.close();
                }
            }

            int finalTotal = totalPrice + deliveryCost;

            // Insert order details into database
            String sql = "INSERT INTO orders (full_name, customer_address, city, district, province, customer_contact, delivery_method, total) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, fullName);
            stmt.setString(2, address);
            stmt.setString(3, city);
            stmt.setString(4, district);
            stmt.setString(5, province);
            stmt.setString(6, phone);
            stmt.setString(7, deliveryMethod);
            stmt.setInt(8, finalTotal);

            int rowsInserted = stmt.executeUpdate();

            // Save address if requested
            if (saveAddress != null && saveAddress.equals("on") && addressName != null && !addressName.isEmpty()) {
                // Assuming you have a user ID in session (you'll need to implement user authentication)
                String userId = (String) session.getAttribute("user_id");
                if (userId != null) {
                    String saveAddressSql = "INSERT INTO saved_addresses (user_id, address_name, full_name, address, city, district, province, phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement saveAddressStmt = conn.prepareStatement(saveAddressSql);
                    saveAddressStmt.setString(1, userId);
                    saveAddressStmt.setString(2, addressName);
                    saveAddressStmt.setString(3, fullName);
                    saveAddressStmt.setString(4, address);
                    saveAddressStmt.setString(5, city);
                    saveAddressStmt.setString(6, district);
                    saveAddressStmt.setString(7, province);
                    saveAddressStmt.setString(8, phone);
                    saveAddressStmt.executeUpdate();
                    saveAddressStmt.close();
                }
            }

            if (rowsInserted > 0) {
                session.setAttribute("cart", null); // Clear the cart after successful order
                response.sendRedirect("Payment.jsp"); // Redirect to a success page
            } else {
                response.sendRedirect("placeoder.jsp"); // Redirect to an error page
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("placeoder.jsp"); // Redirect to an error page if an exception occurs
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Place Order</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            margin-top: 20px;
            display: flex;
            background: white;
            max-width: 1200px;
            width: 100%;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .left, .right {
            padding: 20px;
        }

        .left {
            width: 50%;
            border-right: 2px solid #ddd;
        }

        .right {
            width: 50%;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .cart-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        .cart-item img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
        }

        .cart-item-info {
            flex: 1;
            margin-left: 15px;
        }

        .cart-item-name {
            font-size: 18px;
            font-weight: bold;
        }

        .cart-item-price {
            color: #e44d26;
            font-size: 16px;
        }

        .cart-item-total {
            font-size: 16px;
            font-weight: bold;
            color: #28a745;
        }

        .remove-btn {
            background-color: #e44d26;
            color: white;
            border: none;
            padding: 8px 12px;
            cursor: pointer;
            border-radius: 5px;
        }

        .remove-btn:hover {
            background-color: #c0392b;
        }

        .form-group {
            margin-top: 15px;
        }

        label {
            font-size: 16px;
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        input, textarea, select {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .order-total {
            font-size: 20px;
            font-weight: bold;
            color: #28a745;
            margin-top: 20px;
            text-align: center;
        }

        .order-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .btn {
            padding: 12px 16px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-back {
            background-color: #6c757d;
            color: white;
        }

        .btn-place {
            background-color: #28a745;
            color: white;
        }

        .btn:hover {
            opacity: 0.8;
        }
        
        #district {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
            transition: border-color 0.3s ease;
        }

        #district:focus {
            border-color: #007BFF;
            outline: none;
        }

        #district option {
            padding: 10px;
        }

        #district:hover {
            cursor: pointer;
        }

        #district:invalid {
            border-color: #e74c3c;
        }

        #province {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
            transition: border-color 0.3s ease;
        }

        #province:focus {
            border-color: #007BFF;
            outline: none;
        }

        #province option {
            padding: 10px;
        }

        #province:hover {
            cursor: pointer;
        }

        #province:invalid {
            border-color: #e74c3c;
        }

        #costLabel {
            font-size: 18px;
            font-weight: bold;
            color: #007bff;
            margin-top: 10px;
        }
        
        #deleverymethod {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
            transition: border-color 0.3s ease;
        }

        #deleverymethod:focus {
            border-color: #007BFF;
            outline: none;
        }

        #deleverymethod option {
            padding: 10px;
        }

        #deleverymethod:hover {
            cursor: pointer;
        }

        #deleverymethod:invalid {
            border-color: #e74c3c;
        }
        
        .address-management {
            margin-top: 20px;
            border-top: 1px solid #ddd;
            padding-top: 15px;
        }
        
        .saved-addresses {
            margin-top: 15px;
        }
        
        .address-item {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .address-item:hover {
            background-color: #f0f0f0;
        }
        
        .address-name {
            font-weight: bold;
            color: #007bff;
        }
        
        .address-details {
            margin-top: 5px;
            font-size: 14px;
        }
        
        .save-address-section {
            margin-top: 15px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin-right: 10px;
        }
        
        .hidden {
            display: none;
        }
        
        .payment-options {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
        }
        
        .payment-options .btn {
            width: 48%;
        }
    </style>
</head>
<body>

<div class="container">
    <!-- Left Side: Cart Items -->
    <div class="left">
        <h2>Your Cart</h2>
        <div id="cart-items">
            <%
    // Reuse the database connection instead of opening a new one inside the loop
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

        if (cart != null && !cart.isEmpty()) {
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
%>
                    <div class="cart-item">
                        <img src="<%= imageUrl %>" alt="<%= itemName %>">
                        <div class="cart-item-info">
                            <div class="cart-item-name"><%= itemName %></div>
                            <div class="cart-item-price">Rs. <%= price %> x <%= quantity %></div>
                            <div class="cart-item-total">Total: Rs. <%= itemTotal %></div>
                        </div>
                    </div>
<%
                }
                rs.close();
                stmt.close();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) conn.close();
    }
%>
        </div>
        <h3 class="order-total" id="order-total">Subtotal: Rs. <%= totalPrice %></h3>
    </div>

    <!-- Right Side: Order Form -->
    <div class="right">
        <h2>Delivery Details</h2>
        <form id="order-form" action="placeorder.jsp" method="post">
            <!-- Saved Addresses Section -->
            <div class="address-management">
                <h3>Saved Addresses</h3>
                <div class="saved-addresses" id="saved-addresses">
                    <%
                        // Load saved addresses for the user
                        String userId = (String) session.getAttribute("user_id");
                        List<Map<String, String>> addresses = new ArrayList<>();
                        
                        if (userId != null) {
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                                
                                stmt = conn.prepareStatement("SELECT * FROM saved_addresses WHERE user_id = ?");
                                stmt.setString(1, userId);
                                rs = stmt.executeQuery();
                                
                                while (rs.next()) {
                                    Map<String, String> addressMap = new HashMap<>();
                                    addressMap.put("id", rs.getString("id"));
                                    addressMap.put("address_name", rs.getString("address_name"));
                                    addressMap.put("full_name", rs.getString("full_name"));
                                    addressMap.put("address", rs.getString("address"));
                                    addressMap.put("city", rs.getString("city"));
                                    addressMap.put("district", rs.getString("district"));
                                    addressMap.put("province", rs.getString("province"));
                                    addressMap.put("phone", rs.getString("phone"));
                                    addresses.add(addressMap);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            }
                        }
                        
                        if (addresses.isEmpty()) {
                    %>
                        <p>No saved addresses found. Add one below.</p>
                    <%
                        } else {
                            for (Map<String, String> addr : addresses) {
                    %>
                        <div class="address-item" onclick="fillAddressForm(
                            '<%= addr.get("full_name") %>',
                            '<%= addr.get("address") %>',
                            '<%= addr.get("city") %>',
                            '<%= addr.get("district") %>',
                            '<%= addr.get("province") %>',
                            '<%= addr.get("phone") %>'
                        )">
                            <div class="address-name"><%= addr.get("address_name") %></div>
                            <div class="address-details">
                                <%= addr.get("full_name") %>, <%= addr.get("address") %>, <%= addr.get("city") %><br>
                                <%= addr.get("district") %>, <%= addr.get("province") %><br>
                                Phone: <%= addr.get("phone") %>
                            </div>
                        </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <div class="form-group">
                <label for="full-name">Full Name:</label>
                <input type="text" id="full-name" name="full-name" required>
            </div>

            <div class="form-group">
                <label for="address">Delivery Address:</label>
                <textarea id="address" name="address" rows="3" required></textarea>
            </div>

            <div class="form-group">
                <label for="city">City:</label>
                <input type="text" id="city" name="city" required>
            </div>

            <div class="form-group">
                <label for="district">District:</label>
                <select id="district" name="district" onchange="calculateDeliveryCost()" required>
                    <option value="">Select a district</option>
                    <option value="Ampara">Ampara</option>
                    <option value="Anuradhapura">Anuradhapura</option>
                    <option value="Badulla">Badulla</option>
                    <option value="Batticaloa">Batticaloa</option>
                    <option value="Colombo">Colombo</option>
                    <option value="Galle">Galle</option>
                    <option value="Gampaha">Gampaha</option>
                    <option value="Hambantota">Hambantota</option>
                    <option value="Jaffna">Jaffna</option>
                    <option value="Kandy">Kandy</option>
                    <option value="Kegalle">Kegalle</option>
                    <option value="Kilinochchi">Kilinochchi</option>
                    <option value="Kurunegala">Kurunegala</option>
                    <option value="Mannar">Mannar</option>
                    <option value="Matale">Matale</option>
                    <option value="Matara">Matara</option>
                    <option value="Monaragala">Monaragala</option>
                    <option value="Mullaitivu">Mullaitivu</option>
                    <option value="Nuwara Eliya">Nuwara Eliya</option>
                    <option value="Polonnaruwa">Polonnaruwa</option>
                    <option value="Puttalam">Puttalam</option>
                    <option value="Ratnapura">Ratnapura</option>
                    <option value="Trincomalee">Trincomalee</option>
                    <option value="Vavuniya">Vavuniya</option>
                    <option value="Kalutara">Kalutara</option>
                </select>
            </div>

            <div class="form-group">
                <label for="province">Province:</label>
                <select id="province" name="province" required>
                    <option value="">Select a province</option>
                    <option value="Western">Western Province</option>
                    <option value="Central">Central Province</option>
                    <option value="Southern">Southern Province</option>
                    <option value="Uva">Uva Province</option>
                    <option value="Sabaragamuwa">Sabaragamuwa Province</option>
                    <option value="North Western">North Western Province</option>
                    <option value="North Central">North Central Province</option>
                    <option value="Northern">Northern Province</option>
                    <option value="Eastern">Eastern Province</option>
                </select>
            </div>

            <div class="form-group">
                <label for="deleverymethod">Delivery Method</label>
                <select id="deleverymethod" name="delevery" required>
                    <option value="normal">Normal</option>
                    <option value="oneday">One Day</option>
                    <option value="posting">Posting</option>
                </select>
            </div>

            <div class="form-group">
                <label for="phone">Phone Number:</label>
                <input type="text" id="phone" name="phone" required>
            </div>

            <!-- Save Address Section -->
            <div class="save-address-section">
                <div class="checkbox-group">
                    <input type="checkbox" id="save-address" name="save-address" onchange="toggleAddressNameField()">
                    <label for="save-address">Save this address for future use</label>
                </div>
                <div class="form-group hidden" id="address-name-group">
                    <label for="address-name">Address Name (e.g., Home, Office):</label>
                    <input type="text" id="address-name" name="address-name">
                </div>
            </div>

            <div id="costLabel">Delivery Cost: <span id="costValue">N/A</span></div>
            <h3 class="order-total">Subtotal: Rs. <%= totalPrice %></h3>
            <div id="totalLabel">Total Cost: <span id="totalCostValue">N/A</span></div>

            <div class="order-actions">
                <button type="button" class="btn btn-back" onclick="history.back()">Go Back</button>
                <button type="submit" class="btn btn-place">Place Order</button>
            </div>

            <div class="payment-options">
                <button type="button" class="btn btn-place" onclick="location.href='Payment.jsp'">Pay with Card</button>
                <button type="button" class="btn btn-place" onclick="cashondelivery()">Cash on Delivery</button>
            </div>
        </form>
    </div>
</div>

<script>
    function calculateDeliveryCost() {
        const deliveryCosts = {
            "Ampara": 700,
            "Anuradhapura": 550,
            "Badulla": 600,
            "Batticaloa": 750,
            "Colombo": 300,
            "Galle": 450,
            "Gampaha": 350,
            "Hambantota": 500,
            "Jaffna": 800,
            "Kandy": 400,
            "Kegalle": 420,
            "Kilinochchi": 850,
            "Kurunegala": 450,
            "Mannar": 750,
            "Matale": 430,
            "Matara": 500,
            "Monaragala": 600,
            "Mullaitivu": 820,
            "Nuwara Eliya": 480,
            "Polonnaruwa": 520,
            "Puttalam": 470,
            "Ratnapura": 490,
            "Trincomalee": 650,
            "Vavuniya": 780,
            "Kalutara": 360
        };

        let district = document.getElementById("district").value;
        let costValue = document.getElementById("costValue");
        let totalCostValue = document.getElementById("totalCostValue");

        let subtotal = <%= totalPrice %>;
        let deliveryCost = 0;
        let totalCost = subtotal;

        if (district && deliveryCosts[district] !== undefined) {
            deliveryCost = deliveryCosts[district];
            totalCost = subtotal + deliveryCost;

            costValue.innerHTML = `Rs. ${deliveryCost}`;
            totalCostValue.innerHTML = `Rs. ${totalCost}`;
        } else {
            costValue.innerHTML = "N/A";
            totalCostValue.innerHTML = `Rs. ${subtotal}`;
        }
    }

    function toggleAddressNameField() {
        const saveAddressCheckbox = document.getElementById("save-address");
        const addressNameGroup = document.getElementById("address-name-group");
        
        if (saveAddressCheckbox.checked) {
            addressNameGroup.classList.remove("hidden");
        } else {
            addressNameGroup.classList.add("hidden");
        }
    }

    function fillAddressForm(fullName, address, city, district, province, phone) {
        document.getElementById("full-name").value = fullName;
        document.getElementById("address").value = address;
        document.getElementById("city").value = city;
        document.getElementById("district").value = district;
        document.getElementById("province").value = province;
        document.getElementById("phone").value = phone;
        
        
        calculateDeliveryCost();
    }

    function cashondelivery() {
        // Submit the form with a hidden field indicating cash on delivery
        let form = document.getElementById("order-form");
        let input = document.createElement("input");
        input.type = "hidden";
        input.name = "payment_method";
        input.value = "cash";
        form.appendChild(input);
        form.submit();
    }

    // Calculate delivery cost on page load
    window.onload = function() {
        calculateDeliveryCost();
    };
</script>

</body>
</html>