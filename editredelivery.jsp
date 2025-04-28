<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 20px;
            background: #f0f8ff;
        }
        h2 {
            text-align: center;
            color: #0d6efd;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
        }
        th, td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #0d6efd;
            color: white;
            font-weight: 600;
            font-size: 16px;
        }
        tr:hover {
            background-color: #e6f0ff;
        }
        td {
            font-size: 15px;
        }
        button {
            padding: 8px 16px;
            background: #0d6efd;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 14px;
        }
        button:hover {
            background-color: #084298;
        }
        form {
            margin: 0;
        }
    </style>
</head>
<body>

<%
    // Database connection details
    String dbUrl = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPass = "3323";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        stmt = conn.createStatement();

        // Step 1: Fetch username from temp_login
        String username = "";
        rs = stmt.executeQuery("SELECT username FROM temp_login_shop LIMIT 1");
        if (rs.next()) {
            username = rs.getString("username");
        }
        rs.close();

        // Step 2: Get user_id from user_account where email = username
        int userId = -1;
        PreparedStatement userStmt = conn.prepareStatement("SELECT shop_id FROM shop_accounts WHERE email = ?");
        userStmt.setString(1, username);
        rs = userStmt.executeQuery();
        if (rs.next()) {
            userId = rs.getInt("shop_id");
        }
        rs.close();
        userStmt.close();

        if (userId != -1) {
            // Step 3: Handle return action (if form is submitted)
            String action = request.getParameter("action");
            String orderId = request.getParameter("orderId");
            
            if ("returnOrder".equals(action) && orderId != null) {
                PreparedStatement updateStmt = conn.prepareStatement("UPDATE oders SET status='pending' WHERE oder_id=?");
                updateStmt.setString(1, orderId);
                updateStmt.executeUpdate();
                updateStmt.close();
            }

            // Step 4: Fetch orders
            PreparedStatement ordersStmt = conn.prepareStatement(
                "SELECT * FROM oders WHERE customer_id = ? AND status='return'"
            );
            ordersStmt.setInt(1, userId);
            rs = ordersStmt.executeQuery();
%>

<h2>My Returned Orders</h2>

<table>
    <tr>
        <th>Order ID</th>
        <th>Total</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
    <% 
        while (rs.next()) { 
    %>
    <tr>
        <td><%= rs.getInt("oder_id") %></td>
        <td><%= rs.getInt("total") %></td>
        <td><%= rs.getString("status") %></td>
        <td>
            <form method="post" style="margin:0;">
                <input type="hidden" name="action" value="returnOrder">
                <input type="hidden" name="orderId" value="<%= rs.getInt("oder_id") %>">
                <button type="submit">Return</button>
            </form>
        </td>
    </tr>
    <% 
        } 
        rs.close();
        ordersStmt.close();
    %>
</table>

<%
        } else {
%>
    <p>No user found.</p>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
%>
    <p style="color:red;">Error occurred: <%= e.getMessage() %></p>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

</body>
</html>