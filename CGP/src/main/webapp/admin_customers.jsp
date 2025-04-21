<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - Customer Management</title>
    <style>
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

        .sidebar h2 {
            text-align: center;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            padding: 15px;
            text-align: center;
        }

        .sidebar ul li a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .sidebar ul li a:hover {
            background: #007bff;
            display: block;
            border-radius: 10px;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
            flex: 1;
            overflow-y: auto;
            width: 100%;
        }

        h2 {
            text-align: center;
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
            background-color: #007bff;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        button {
            background-color: red;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: darkred;
        }
    </style>
</head>
<body>

<%
    // Handle suspend request (before displaying users)
    String suspendUserId = request.getParameter("suspendId");
    if (suspendUserId != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
            stmt = conn.prepareStatement("UPDATE user_account SET status = 'Suspended' WHERE user_id = ?");
            stmt.setInt(1, Integer.parseInt(suspendUserId));
            stmt.executeUpdate();
        } catch (Exception e) {
            out.println("<script>alert('Error suspending user: " + e.getMessage() + "');</script>");
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
%>

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
    <h2>Customer Management</h2>
    <table>
        <tr>
            <th>Customer ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Address</th>
            <th>Phone Number</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM user_account");

                while (rs.next()) {
                    int id = rs.getInt("user_id");
                    String name = rs.getString("user_name");
                    String email = rs.getString("email");
                    String address = rs.getString("user_address");
                    String phone = rs.getString("user_phonenumber");
                    String status = rs.getString("status");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= email %></td>
            <td><%= address %></td>
            <td><%= phone %></td>
            <td><%= status %></td>
            <td>
                <% if (!"Suspended".equalsIgnoreCase(status)) { %>
                    <form method="post" style="margin: 0;">
                        <input type="hidden" name="suspendId" value="<%= id %>">
                        <button type="submit" onclick="return confirm('Suspend user <%= name %>?')">Suspend</button>
                    </form>
                <% } else { %>
                    Suspended
                <% } %>
            </td>
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

</body>
</html>
