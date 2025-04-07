<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Details - Admin Panel</title>
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

        .status {
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 12px;
            color: white;
        }

        .pending { background-color: #ffc107; }
        .delivered { background-color: #28a745; }
        .cancelled { background-color: #dc3545; }

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
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Sender</th>
                    <th>Receiver</th>
                    <th>Package Type</th>
                    <th>Order Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database_name", "your_username", "your_password");
                        stmt = conn.createStatement();
                        String query = "SELECT order_id, sender_name, receiver_name, package_type, order_date, status FROM orders";
                        rs = stmt.executeQuery(query);

                        while (rs.next()) {
                            String orderId = rs.getString("order_id");
                            String sender = rs.getString("sender_name");
                            String receiver = rs.getString("receiver_name");
                            String packageType = rs.getString("package_type");
                            String orderDate = rs.getString("order_date");
                            String status = rs.getString("status");

                            String statusClass = "";
                            if ("Pending".equalsIgnoreCase(status)) {
                                statusClass = "pending";
                            } else if ("Delivered".equalsIgnoreCase(status)) {
                                statusClass = "delivered";
                            } else if ("Cancelled".equalsIgnoreCase(status)) {
                                statusClass = "cancelled";
                            }
                %>
                <tr>
                    <td><%= orderId %></td>
                    <td><%= sender %></td>
                    <td><%= receiver %></td>
                    <td><%= packageType %></td>
                    <td><%= orderDate %></td>
                    <td><span class="status <%= statusClass %>"><%= status %></span></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' style='color:red; text-align:center;'>Error: " + e.getMessage() + "</td></tr>");
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