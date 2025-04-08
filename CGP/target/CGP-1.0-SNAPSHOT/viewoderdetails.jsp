<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String orderIdParam = request.getParameter("order_id");
    String customerIdParam = request.getParameter("customer_id");
    String customerAddress = request.getParameter("customer_address");

    int orderId = 0;
    int customerId = 0;

    try {
        if (orderIdParam != null) orderId = Integer.parseInt(orderIdParam);
        if (customerIdParam != null) customerId = Integer.parseInt(customerIdParam);
    } catch (NumberFormatException e) {
        orderId = 0;
        customerId = 0;
    }

    String deliveryBoyIdParam = request.getParameter("delivery_boy_id");
    if (deliveryBoyIdParam != null && orderId > 0 && customerAddress != null) {
        try {
            int deliveryBoyId = Integer.parseInt(deliveryBoyIdParam);

            try (
                Connection connAssign = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                PreparedStatement stmtAssign = connAssign.prepareStatement(
                    "INSERT INTO order_delivery_boy (order_id, id, customer_ID, address, status) VALUES (?, ?, ?, ?, 'Pending')"
                )
            ) {
                Class.forName("com.mysql.cj.jdbc.Driver");

                stmtAssign.setInt(1, orderId);
                stmtAssign.setInt(2, deliveryBoyId);
                stmtAssign.setInt(3, customerId);
                stmtAssign.setString(4, customerAddress);

                int rowsInserted = stmtAssign.executeUpdate();
                if (rowsInserted > 0) {
%>
<script>
    alert("Delivery Boy assigned successfully!");
    window.location.href = "viewoderdetails.jsp?order_id=<%= orderId %>&customer_id=<%= customerId %>&customer_address=<%= URLEncoder.encode(customerAddress, "UTF-8") %>";
</script>
<%
                } else {
                    out.println("<p style='color:red;'>Assignment failed.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
            }
        } catch (NumberFormatException e) {
            out.println("<p style='color:red;'>Invalid Delivery Boy ID format.</p>");
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Details - Admin Panel</title>
    <style>
        /* Your existing styles remain the same */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #74ebd5, #acb6e5);
            height: 100vh;
            display: flex;
        }
        .sidebar {
            width: 250px;
            background: #333;
            color: white;
            height: 100%;
            padding-top: 20px;
            position: fixed;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
        }
        .sidebar ul li {
            padding: 20px;
            text-align: center;
        }
        .sidebar ul li a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            display: block;
        }
        .sidebar ul li a:hover {
            background: #007bff;
            padding: 20px;
            border-radius: 10px;
        }
        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 30px;
            animation: fadeIn 1s ease-out forwards;
        }
        form {
    background: #fff;
    padding: 25px 30px;
    border-radius: 12px;
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
    max-width: 500px;
    margin: 0 auto 30px;
    display: flex;
    flex-direction: column;
    gap: 15px;
}

form label {
    font-size: 16px;
    color: #333;
    font-weight: bold;
}

form input[type="text"] {
    padding: 12px 15px;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 14px;
    transition: border 0.3s ease;
}

form input[type="text"]:focus {
    border-color: #007bff;
    outline: none;
}

form button {
    padding: 12px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

form button:hover {
    background-color: #0056b3;
}

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
<div class="sidebar">
    <h2 style="text-align:center;">Admin Panel</h2>
    <ul>
        <li><a href="admin_home.jsp">Dashboard</a></li>
        <li><a href="admin_oderdetails.jsp">Orders</a></li>
        <li><a href="packedoder.jsp">Packed Orders</a></li>
        <li><a href="ondelivery.jsp">On Delivery</a></li>
        <li><a href="finished_oder.jsp">Finished Orders</a></li>
        <li><a href="viewpayments.jsp">Payments</a></li>
        <li><a href="admin_customers.jsp">Customers</a></li>
        <li><a href="admin_shop.jsp">Sellers</a></li>
        <li><a href="admin_itemmanagement.jsp">Item Management</a></li>
    </ul>
</div>

<div class="main-content">
    <h1>Order Details</h1>

    <form action="viewoderdetails.jsp" method="post" style="margin-top: 30px;">
        <input type="hidden" name="order_id" value="<%= orderId %>">
        <input type="hidden" name="customer_id" value="<%= customerId %>">
        <input type="hidden" name="customer_address" value="<%= customerAddress %>">

        <label for="delivery_boy_id">Assign Delivery Boy ID:</label>
        <input type="text" name="delivery_boy_id" required>
        <button type="submit">Assign</button>
    </form>

    <table>
        <thead>
        <tr>
            <th>Order ID</th>
            <th>Item Code</th>
            <th>Quantity</th>
            <th>Price</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

                String query = "SELECT oder_id, item_code, quantity, price FROM oder_items WHERE oder_id = ?";
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, orderId);

                rs = stmt.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("oder_id") %></td>
            <td><%= rs.getString("item_code") %></td>
            <td><%= rs.getString("quantity") %></td>
            <td><%= rs.getString("price") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally { 
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
