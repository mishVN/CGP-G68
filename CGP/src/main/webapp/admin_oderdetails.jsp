<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
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
        .buttontableupdate{
            padding: 10px;
            margin: 5px;
            border-radius: 5px;
            background: green;
            color: white;
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
        <h2 class="adminpanle" >Admin Panel</h2>
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
        <header>
            <h1>Courier Service Admin</h1>
        </header>
        <section>
            <h2>Orders</h2>
            <table class="orders-table">
                <tr>
                    <th>Order ID</th>
                    <th>Total</th>
                    <th>Customer ID</th>
                    <th>Contact</th>
                    <th>Address</th>
                    <th>Status</th>
                    <th>View Oder</th>
                    <th>Update</th>
                </tr>
                <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM oders where status ='pending'  ");
                        while(rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("oder_id") %></td>
                    <td><%= rs.getInt("total") %></td>
                    <td><%= rs.getInt("customer_id") %></td>
                    <td><%= rs.getString("customer_contact") %></td>
                    <td><%= rs.getString("customer_address") %></td>
                    <td><%= rs.getString("status") %></td>
                    <td>
                       <%
    int orderId = rs.getInt("oder_id");
    int customerId = rs.getInt("customer_id");
    String customerAddress = rs.getString("customer_address");
%>
<button class="buttontableupdate"
        onclick="location.href='viewoderdetails.jsp?order_id=<%= orderId %>&customer_id=<%= customerId %>&customer_address=<%= java.net.URLEncoder.encode(customerAddress, "UTF-8") %>'">
    View
</button>

                    </td>
                    <td><button class="buttontableupdate" onclick="tableupdate(this, <%= rs.getInt("oder_id") %>)">Packed</button></td>
                </tr>
                <% 
                        }
                        con.close();
                    } catch(Exception e) {
                        e.printStackTrace();
                    }
                %>
            </table>
        </section>
    </div>
            
       <script>
         function tableupdate(button, orderId) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "", true); // Send request to the same page
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    button.closest("tr").cells[5].innerText = "Packed"; // Update status
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