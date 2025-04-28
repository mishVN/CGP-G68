<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Courier Service</title>
    <link rel="stylesheet" href="styles.css">
    <script defer src="script.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #74ebd5, #acb6e5);
            height: 100vh;
            display: flex;
        }
        .adminpanle {
            text-align: center;
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
            padding: 20px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 1s ease-out forwards;
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
        .container {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            text-align: center;
        }
        .headertitle {
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #007bff;
            color: #fff;
        }
        tr:hover {
            background: #f1f1f1;
            transition: background 0.3s ease-in-out;
        }
        .btn {
            padding: 10px 18px;
            border: none;
            background: #28a745;
            color: #fff;
            cursor: pointer;
            border-radius: 6px;
            transition: all 0.3s ease-in-out;
        }
        .btn:hover {
            background: #218838;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2 class="adminpanle">Admin Panel</h2>
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
        <div class="container">
            <h2 class="headertitle">On Delivery Orders</h2>
            <table>
                <tr>
                    <th>Order ID</th>
                    <th>Customer NIC</th>
                    <th>Amount</th>
                    <th>Contact</th>
                    <th>Status</th>
                    <th>Location</th>
                    <th>Action</th>
                </tr>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                        PreparedStatement ps = con.prepareStatement("SELECT * FROM oders WHERE status = ?");
                        ps.setString(1, "ondelivery");
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                        
                    int orderId = rs.getInt("oder_id");
                    int customerId = rs.getInt("customer_id");
                    double total = rs.getDouble("total");
                    String contact = rs.getString("customer_contact");
                    String status = rs.getString("status");

                    String subject = "Your Order #" + orderId + " Delivered";
                    String message = "Dear customer, your order #"+ orderId+" has been successfully delivered!. we truly appreciate your trust. We hope to serve you again soon! .Thank you for using our courier service . ✅📬";
                %>
                <tr>
    <td><%= orderId %></td>
    <td><%= customerId %></td>
    <td><%= total %></td>
    <td><%= contact %></td>
    <td><%= status %></td>
    <td>
        <button class="btn" onclick="redirectToMap(<%= orderId %>)">MAP</button>
    </td>
    <td>
        <button class="btn" onclick="updateAndSend(<%= orderId %>, '<%= subject.replace("'", "\\'") %>', '<%= message.replace("'", "\\'") %>')">Finished</button>
    </td>
</tr>

                <%
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </table>
        </div>
    </div>

    <script>
        
        function redirectToMap(orderId) {
    window.location.href = "Address_management.jsp?orderId=" + orderId;
}
        
        function updateAndSend(orderId, subject, message) {
        // First update the order status
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                sendEmail(orderId, subject, message);
                alert("Order #" + orderId + " marked as Finished and email sent.");
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
                alert("Order #" + orderId + " marked as Finished and email sent.");
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
                    PreparedStatement pstmt = con.prepareStatement("UPDATE oders SET status = 'Finished' WHERE oder_id = ?");
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
