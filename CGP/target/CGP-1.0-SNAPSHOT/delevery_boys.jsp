<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
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
        table {
            border-collapse: collapse;
            width: 100%;
            background: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ccc;
            text-align: left;
        }
        th {
            background: #007BFF;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
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
            <li><a href="delevery_boys.jsp">Delivery Boy List</a></li>
            <li><a href="admin_itemmanagement.jsp">Item Management</a></li>
        </ul>
    </div>
    <div class="main-content">
        <header>
            <h1>Delevery Boy List</h1>
        </header>
        <section class="dashboard">
           <table id="deliveryBoyTable">
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Contact Number</th>
        </tr>
    </thead>
    <tbody>
    <%
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 8 driver
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
            stmt = conn.createStatement();
            String sql = "SELECT * FROM delivery_boy";
            rs = stmt.executeQuery(sql);

            while(rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String contact = rs.getString("contact_number");
    %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= contact %></td>
        </tr>
    <%
            }
        } catch(Exception e) {
            out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception ignored) {}
            if(stmt != null) try { stmt.close(); } catch(Exception ignored) {}
            if(conn != null) try { conn.close(); } catch(Exception ignored) {}
        }
    %>
    </tbody>
</table>
        </section>
    </div>
</body>
</html>