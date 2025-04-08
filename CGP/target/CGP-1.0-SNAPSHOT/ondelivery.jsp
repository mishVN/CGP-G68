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
        
        .adminpanle{
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
            padding: 25px;
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
            padding: 25px;
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
        
        .dashboard {
            display: flex;
            flex-direction: row;
            
            justify-content: center;
            gap: 10px;
            width: 100%;
        }
        
        .stat-box {
            background: #007bff;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            width: 30%;
            min-width: 150px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease-in-out;
        }
        .stat-box:hover {
            transform: scale(1.05);
        }
        .stat-box h2 {
            margin: 0 0 10px;
        }
        
        .container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .headertitle{
           color: #333; 
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
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
            padding: 8px 16px;
            border: none;
            background: #28a745;
            color: #fff;
            cursor: pointer;
            border-radius: 5px;
            transition: transform 0.2s;
        }
        .btn:hover {
            background: #218838;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2  class="adminpanle">Admin Panel</h2>
        <ul>
            <li><a href="admin_home.jsp">Dashboard</a></li>
            <li><a href="admin_oderdetails.jsp">Orders</a></li>
            <li><a href="packedoder.jsp">Packed Oder</a></li>
            <li><a href="ondelivery.jsp">On Delivery</a></li>
            <li><a href="finished_oder.jsp">Finished Orders</a></li>
            <li><a href="viewpayments.jsp">Payments</a></li>
            <li><a href="admin_customers.jsp">Customers</a></li>
            <li><a href="admin_shop.jsp">Sellers</a></li>
            <li><a href="admin_itemmanagement.jsp">Item Management</a></li>
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
            %>
            <tr>
                <td><%= rs.getInt("oder_id") %></td>
                <td><%= rs.getString("customer_id") %></td>
                <td><%= rs.getDouble("total") %></td>
                <td><%= rs.getString("customer_contact") %></td>
                <td><%= rs.getString("status") %></td>
                <td><a href="map.jsp">MAP</a></td>
                <td><button class="btn" onclick="tableupdate(this, <%= rs.getInt("oder_id") %>)">Finished</button></td>
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
        function tableupdate(button, orderId) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "", true); // Send request to the same page
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    button.closest("tr").cells[5].innerText = "Finished"; // Update status
                    button.disabled = true; // Disable button
                    button.innerText = "Updated";
                    button.style.background = "gray";
                    location.reload();
                }
            };

            xhr.send("update_order=" + orderId);
        }
        
    </script>
    
    <%
        if (request.getMethod().equals("POST")) {
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