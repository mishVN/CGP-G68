<%@page import="java.util.stream.Collectors"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }

    int subtotal = 0;

    Map<String, Integer> deliveryCosts = new HashMap<>();

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

        // 🛠️ Load delivery costs dynamically from database
        stmt = conn.prepareStatement("SELECT district, delivery_fee FROM delivery_fee");
        rs = stmt.executeQuery();
        while (rs.next()) {
            deliveryCosts.put(rs.getString("district"), rs.getInt("delivery_fee"));
        }
        rs.close();
        stmt.close();

        if (!cart.isEmpty()) {
            String placeholders = cart.keySet().stream().map(id -> "?").collect(Collectors.joining(","));
            stmt = conn.prepareStatement("SELECT id, price FROM products WHERE id IN (" + placeholders + ")");
            int index = 1;
            for (Integer id : cart.keySet()) {
                stmt.setInt(index++, id);
            }
            rs = stmt.executeQuery();

            Map<Integer, Integer> prices = new HashMap<>();
            while (rs.next()) {
                prices.put(rs.getInt("id"), rs.getInt("price"));
            }
            rs.close();
            stmt.close();

            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int productId = entry.getKey();
                int quantity = entry.getValue();
                Integer price = prices.get(productId);
                if (price != null) {
                    subtotal += price * quantity;
                }
            }
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String fullName = request.getParameter("full-name");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String postalcode = request.getParameter("postal-code");
            String district = request.getParameter("district");
            String province = request.getParameter("province");
            String deliveryMethod = request.getParameter("delevery");
            String phone = request.getParameter("phone");
            String paymentMethod = request.getParameter("paymentMethod");

            int deliveryCost = deliveryCosts.getOrDefault(district, 0);
            int total = subtotal + deliveryCost;

            stmt = conn.prepareStatement("INSERT INTO oders (full_name, customer_address, city, district, province, customer_contact, delivery_method, total, postal_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, fullName);
            stmt.setString(2, address);
            stmt.setString(3, city);
            stmt.setString(4, district);
            stmt.setString(5, province);
            stmt.setString(6, phone);
            stmt.setString(7, deliveryMethod);
            stmt.setInt(8, total);
            stmt.setString(9, postalcode);

            int inserted = stmt.executeUpdate();

            int orderId = 0;
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
            rs.close();
            stmt.close();

            if (inserted > 0 && "cashondelivery".equals(paymentMethod)) {
                stmt = conn.prepareStatement("INSERT INTO payment (total, payment_method) VALUES (?, 'cashondelivery')");
                stmt.setInt(1, total);
                stmt.executeUpdate();
                stmt.close();

                session.setAttribute("cart", null);
                response.sendRedirect("placeoder.jsp");
                return;
            } else if (inserted > 0) {
                session.setAttribute("cart", null);
                response.sendRedirect("placeoder.jsp");
                return;
            } else {
                out.println("<script>alert('Failed to place order.');</script>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error processing order: " + e.getMessage() + "');</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>


<!DOCTYPE html>
<html>
<head>
    <title>Place Order</title>
    <style>
      
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 20px;
    background-color: #f2f2f2;
}

h2 {
    margin-bottom: 20px;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}


.main-content {
    display: flex;
    gap: 30px;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
}


.container {
    background: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.left, .right {
    flex: 1;
    min-width: 400px;
}


.cart-item {
    display: flex;
    align-items: center;
    gap: 15px;
    border-bottom: 1px solid #ddd;
    padding: 10px 0;
}

.cart-item img {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 8px;
    border: 1px solid #ccc;
}

.cart-item-info {
    flex: 1;
}

.cart-item-name {
    font-weight: bold;
    font-size: 16px;
    margin-bottom: 5px;
}

.cart-item-price,
.cart-item-total {
    font-size: 14px;
    color: #555;
}


.form-group {
    margin-bottom: 15px;
}

input,
select,
textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 14px;
}


.btn {
    padding: 10px 20px;
    background: green;
    color: #fff;
    border: none;
    border-radius: 5px;
    font-size: 15px;
    cursor: pointer;
}

.btn:hover {
    background: darkgreen;
}


.summary {
    margin-top: 15px;
    font-weight: bold;
    font-size: 16px;
}


@media (max-width: 900px) {
    .main-content {
        flex-direction: column;
    }

    .left, .right {
        min-width: 100%;
    }
}

    </style>
    <script>
    const deliveryPrices = <%= new org.json.JSONObject(deliveryCosts).toString() %>;

    function updateDeliveryCost() {
        const district = document.getElementById('district').value;
        const deliveryCost = deliveryPrices[district] || 0;

        const subtotalText = document.querySelector(".summary").innerText;
        const subtotalMatch = subtotalText.match(/\d+/g);
        const subtotal = subtotalMatch ? parseInt(subtotalMatch[0]) : 0;

        const total = subtotal + deliveryCost;

        document.getElementById("delivery-cost").innerText = "Rs. " + deliveryCost;
        document.getElementById("total-cost").innerText = "Rs. " + total;
    }
</script>

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
                    subtotal += price * quantity;
%>
                    <div class="cart-item">
                        <img src="<%= imageUrl %>" alt="<%= itemName %>">
                        <div class="cart-item-info">
                            <div class="cart-item-name"><%= itemName %></div>
                            <div class="cart-item-price">Rs. <%= price %> x <%= quantity %></div>
                            <div class="cart-item-total">Total: Rs. <%= subtotal %></div>
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
    </div>
        

<div class="container">
    <h2>Delivery Details</h2>
    <form method="post">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="full-name" required>
        </div>

        <div class="form-group">
            <label>Address</label>
            <textarea name="address" rows="2" required></textarea>
        </div>
        
        <div class="form-group">
            <label>Postal Code</label>
            <input type="text" name="postal-code" required>
        </div>

        <div class="form-group">
            <label>City</label>
            <input type="text" name="city" required>
        </div>

        <div class="form-group">
            <label>District</label>
            <select name="district" id="district" onchange="updateDeliveryCost()" required>
                <option value="">Select District</option>
                <% for (String d : deliveryCosts.keySet()) { %>
                    <option value="<%= d %>"><%= d %></option>
                <% } %>
            </select>
        </div>

        <div class="form-group">
            <label>Province</label>
            <select name="province" required>
                <option value="">Select Province</option>
                <option value="Western">Western</option>
                <option value="Central">Central</option>
                <option value="Southern">Southern</option>
                <option value="Uva">Uva</option>
                <option value="Sabaragamuwa">Sabaragamuwa</option>
                <option value="North Western">North Western</option>
                <option value="North Central">North Central</option>
                <option value="Northern">Northern</option>
                <option value="Eastern">Eastern</option>
            </select>
        </div>

        <div class="form-group">
            <label>Delivery Method</label>
            <select name="delevery" required>
                <option value="normal">Normal</option>
                <option value="oneday">One Day</option>
                <option value="posting">Posting</option>
            </select>
        </div>

        <div class="form-group">
            <label>Phone</label>
            <input type="text" name="phone" required>
        </div>

        <div class="summary">Subtotal: Rs. <%= subtotal %></div>
        <div class="summary">Delivery Cost: <span id="delivery-cost">Rs. 0</span></div>
        <div class="summary">Total Cost: <span id="total-cost">Rs. <%= subtotal %></span></div>

        <br>
        <button type="submit" class="btn">Place Order</button>
    </form>
        <div class="order-actions">
    <button type="button" class="btn btn-place" onclick="location.href='Payment.jsp?total=<%= subtotal %>'">Pay Card</button>
    <button type="submit" name="paymentMethod" value="cashondelivery" class="btn btn-cash">Cash On Delivery</button>

</div>

        
</div>
</body>
</html>