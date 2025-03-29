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
        
        h2 { 
           color: #333; 
           text-align: center;
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
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
            border-color: #fff;
        }
        td{
            background-color: #f1f1f1;
        }
        th {
            background: #007bff;
            color: #fff;
        }
        tr:hover {
            background: #f1f1f1;
            transition: background 0.3s ease-in-out;
        }
        .main{
            margin: 10px;
            padding: 20px;
            background-color: #f1f1f1;
            border-radius: 10px;
            
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
        <div class="main">
        <h2>Seller Management</h2>

    <h2>Seller List</h2>
    <table>
        <tr>
            <th>Seller ID</th>
            <th>Shop Name</th>
            <th>Owner Name</th>
            <th>E Mail</th>
            <th>Contact Number</th>
            <th>Address</th>
            
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM shop_accounts");
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("shop_id") %></td>
            <td><%= rs.getString("shop_ownername") %></td>
            <td><%= rs.getString("shop_name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("shop_phonenumber") %></td>
            <td><%= rs.getString("shop_address") %></td>
            
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
        
    </div>
    </div>
</body>
</html>