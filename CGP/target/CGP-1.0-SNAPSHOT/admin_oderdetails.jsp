<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Courier Service</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #74ebd5, #acb6e5);
            height: 100vh;
            display: flex;
            margin: 0;
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
            padding: 25px;
            text-align: center;
        }

        .sidebar ul li a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .sidebar ul li a:hover {
            background: #007bff;
            padding: 25px;
            border-radius: 10px;
        }

        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 20px;
        }

        .buttontableupdate {
            padding: 10px;
            margin: 5px;
            border-radius: 5px;
            background: green;
            color: white;
            border: none;
            cursor: pointer;
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            overflow: hidden;
        }

        .orders-table th, .orders-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .orders-table th {
            background: #007bff;
            color: white;
        }

        .orders-table tr:hover {
            background: #f1f1f1;
        }
    </style>
</head>
<body>
<div class="sidebar">
    <h2 style="text-align:center;">Admin Panel</h2>
    <ul>
        <li><a href="admin_home.jsp">Dashboard</a></li>
        <li><a href="admin_oderdetails.jsp">Orders</a></li>
        <li><a href="packedoder.jsp">Packed Order</a></li>
        <li><a href="ondelivery.jsp">On Delivery</a></li>
        <li><a href="finished_oder.jsp">Finished Orders</a></li>
        <li><a href="viewpayments.jsp">Payments</a></li>
        <li><a href="admin_livechat.jsp">Live Chat</a></li>
        <li><a href="delevery_boys.jsp">Delivery Boys</a></li>
        <li><a href="admin_customers.jsp">Customers</a></li>
        <li><a href="admin_shop.jsp">Sellers</a></li>
        <li><a href="admin_itemmanagement.jsp">Item Management</a></li>
        <li><a href="admin_report.jsp">Reports</a></li>
    </ul>
</div>

<div class="main-content">
    <h1>Courier Service Admin</h1>
    <h2>Orders</h2>
    <table class="orders-table">
        <tr>
            <th>Order ID</th>
            <th>Total</th>
            <th>Customer ID</th>
            <th>Contact</th>
            <th>Address</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>

        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                Statement stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM oders WHERE status = 'pending'");

                while (rs.next()) {
                    int orderId = rs.getInt("oder_id");
                    int customerId = rs.getInt("customer_id");
                    String contact = rs.getString("customer_contact");
                    String address = rs.getString("customer_address");
                    String status = rs.getString("status");
                    int total = rs.getInt("total");

                    String subject = "Your Order #" + orderId + " is Now Packed";
                    String message = "Dear customer, your order #"+ orderId+"has been packed and is ready for delivery!.Thank you for choosing us.Your package will be with you soon!🛍📦🚀";
        %>
        <tr>
            <td><%= orderId %></td>
            <td><%= total %></td>
            <td><%= customerId %></td>
            <td><%= contact %></td>
            <td><%= address %></td>
            <td><%= status %></td>
            <td>
                <button class="buttontableupdate" onclick="updateAndSend(<%= orderId %>, '<%= subject.replace("'", "\\'") %>', '<%= message.replace("'", "\\'") %>')">Packed</button>
            </td>
        </tr>
        <%  }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</div>

<script>
    function updateAndSend(orderId, subject, message) {
        // First update the order status
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                sendEmail(orderId, subject, message);
                alert("Order #" + orderId + " marked as Packed and email sent.");
                location.reload();
            }
        };

        xhr.send("update_order=" + orderId);
    }

    function sendEmail(orderId, subject, message) {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "mail.jsp", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            if (xhr.status === 200 && xhr.responseText.trim() === "success") {
                alert("Order #" + orderId + " marked as Packed and email sent.");
                location.reload();
            } else {
                alert("Failed to send email for Order #" + orderId + ".");
            }
        }
    };

    var data = "order_id=" + encodeURIComponent(orderId) +
               "&subject=" + encodeURIComponent(subject) +
               "&message=" + encodeURIComponent(message);
    xhr.send(data);
}

</script>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String orderId = request.getParameter("update_order");
        if (orderId != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                PreparedStatement pstmt = con.prepareStatement("UPDATE oders SET status = 'Packed' WHERE oder_id = ?");
                pstmt.setInt(1, Integer.parseInt(orderId));
                pstmt.executeUpdate();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>
