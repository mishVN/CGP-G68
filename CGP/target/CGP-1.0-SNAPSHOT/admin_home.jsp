<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>
<%
    // DB connection variables
    String dbURL = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPass = "3323";

    Connection conn = null;
    int totalOrders = 0;
    int deliveredOrders = 0;
    int pendingOrders = 0;
    ResultSet finishedRs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Count Total Orders
        String totalQuery = "SELECT COUNT(*) FROM oders"; 
        PreparedStatement totalStmt = conn.prepareStatement(totalQuery);
        ResultSet totalRs = totalStmt.executeQuery();
        if (totalRs.next()) {
            totalOrders = totalRs.getInt(1);
        }
        totalRs.close();
        totalStmt.close();

        // Count Delivered Orders
        String deliveredQuery = "SELECT COUNT(*) FROM oders WHERE status='finished'";
        PreparedStatement deliveredStmt = conn.prepareStatement(deliveredQuery);
        ResultSet deliveredRs = deliveredStmt.executeQuery();
        if (deliveredRs.next()) {
            deliveredOrders = deliveredRs.getInt(1);
        }
        deliveredRs.close();
        deliveredStmt.close();

        // Count Pending Orders
        String pendingQuery = "SELECT COUNT(*) FROM oders WHERE status='pending'";
        PreparedStatement pendingStmt = conn.prepareStatement(pendingQuery);
        ResultSet pendingRs = pendingStmt.executeQuery();
        if (pendingRs.next()) {
            pendingOrders = pendingRs.getInt(1);
        }
        pendingRs.close();
        pendingStmt.close();

        // Fetch Last 20 Finished Orders
        String finishedQuery = "SELECT oder_id, full_name, total, delivery_method FROM oders WHERE status='finished' ORDER BY oder_id DESC LIMIT 20";
        PreparedStatement finishedStmt = conn.prepareStatement(finishedQuery);
        finishedRs = finishedStmt.executeQuery(); // Keep it open for later use in HTML

    } catch (Exception e) {
        e.printStackTrace();
    }
%>



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
    }

    .main-content {
        margin-left: 255px; /* Slightly increased from 250px to add some space */
        flex: 1;
        padding: 10px; /* Add padding for more space if needed */
        opacity: 0;
        transform: translateY(20px);
        animation: fadeIn 1s ease-out forwards;
        margin: 20px;
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
        left: 0;
        top: 0;
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
    /* Table Styling */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }
    th, td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    th {
        background: #007bff;
        color: white;
    }
    tr:hover {
        background: #f5f5f5;
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
            <li><a href="admin_customers.jsp">Customers</a></li>
            <li><a href="admin_shop.jsp">Sellers</a></li>
            <li><a href="admin_itemmanagement.jsp">Item Management</a></li>
        </ul>
    </div>
    <div class="main-content">
        <header>
            <h1>Courier Service Admin</h1>
        </header>
        <section class="dashboard">
            <div class="stat-box">
                <h2>Total Orders</h2>
                <p id="totalOrders"><%= totalOrders %></p>
            </div>
            <div class="stat-box">
                <h2>Delivered</h2>
                <p id="deliveredOrders"><%= deliveredOrders %></p>
            </div>
            <div class="stat-box">
                <h2>Pending</h2>
                <p id="pendingOrders"><%= pendingOrders %></p>
            </div>
        </section>

        <!-- Display Last 20 Finished Orders -->
        <h2>Last 20 Finished Orders</h2>
        <table>
            <tr>
                <th>Order ID</th>
                <th>Customer Name</th>
                <th>Total</th>
                <th>Delivery Method</th>
            </tr>
            <%
                while (finishedRs.next()) {
            %>
                <tr>
                    <td><%= finishedRs.getInt("oder_id") %></td>
                    <td><%= finishedRs.getString("full_name") %></td>
                    <td><%= finishedRs.getString("total") %></td>
                    <td><%= finishedRs.getString("delivery_method") %></td>
                </tr>
            <%
                }
            %>
        </table>
    </div>
</body>
</html>