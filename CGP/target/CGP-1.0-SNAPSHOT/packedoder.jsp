
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Packed Orders - Admin Panel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #74ebd5, #acb6e5);
            margin: 0;
            display: flex;
            height: 100vh;
        }

        .sidebar {
            width: 250px;
            background: #333;
            color: white;
            height: 100%;
            padding-top: 20px;
            position: fixed;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 20px;
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
            animation: fadeIn 0.8s ease forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        @keyframes fadeIn {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .container {
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:hover {
            background-color: #f2f2f2;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            background-color: #28a745;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s ease-in-out;
        }

        .btn:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        .btn:disabled {
            background-color: gray;
            cursor: default;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>Admin Panel</h2>
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
        <h2>Packed Orders</h2>
        <table>
            <tr>
                <th>Order ID</th>
                <th>Customer ID</th>
                <th>Total</th>
                <th>Contact</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM oders WHERE status = ?");
                    ps.setString(1, "Packed");
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                    int orderId = rs.getInt("oder_id");
                    int customerId = rs.getInt("customer_id");
                    int total = rs.getInt("total");
                    String contact = rs.getString("customer_contact");
                    String status = rs.getString("status");
                    

                    String subject = "Your Order #" + orderId + " is Now out for Delivery";
                    String message = "Dear customer, your order #"+ orderId+" has been packed and is now out for delivery!. It will be delivered within two working days from today. Thank you for choosing our service!.Have a great day!📦🚚✨";
                    
            %>
            <tr>
                <td><%= orderId %></td>
                <td><%= customerId %></td>
                <td><%= total %></td>
                <td><%= contact %></td>
                <td><%= status %></td>
                <td><button class="btn" onclick="updateAndSend(<%= orderId %>, '<%= subject.replace("'", "\\'") %>', '<%= message.replace("'", "\\'") %>')">ON Delivery</button></td>
            </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>
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
                alert("Order #" + orderId + " marked as On delevery and email sent.");
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
                alert("Order #" + orderId + " marked as On Delivery and email sent.");
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
                PreparedStatement pstmt = con.prepareStatement("UPDATE oders SET status = 'OnDelivery' WHERE oder_id = ?");
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
