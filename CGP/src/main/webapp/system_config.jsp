<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url = "jdbc:mysql://localhost:3306/cgp";
    String user = "root";
    String password = "3323";
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url, user, password);

    // Handle updates
    if (request.getParameter("update_district") != null) {
        String district = request.getParameter("district");
        String fee = request.getParameter("fee");
        PreparedStatement ps = con.prepareStatement("UPDATE delivery_fee SET delivery_fee=? WHERE district=?");
        ps.setBigDecimal(1, new java.math.BigDecimal(fee));
        ps.setString(2, district);
        ps.executeUpdate();
    }

    if (request.getParameter("update_method") != null) {
        String method = request.getParameter("method");
        String fee = request.getParameter("method_fee");
        PreparedStatement ps = con.prepareStatement("UPDATE delivery_method SET delivery_fee=? WHERE delivery_method=?");
        ps.setBigDecimal(1, new java.math.BigDecimal(fee));
        ps.setString(2, method);
        ps.executeUpdate();
    }

    // Fetch results using scrollable result sets (not mandatory here anymore but safe)
    Statement st1 = con.createStatement();
    ResultSet rsDistricts = st1.executeQuery("SELECT * FROM delivery_fee");

    Statement st2 = con.createStatement();
    ResultSet rsMethods = st2.executeQuery("SELECT * FROM delivery_method");
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
     input[type="text"], input[type="number"] { width: 100px; padding: 5px; }
        input[type="submit"] { padding: 5px 15px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
       
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
        <header>
            <h1>Courier Service Admin</h1>
        </header>
        
        
<h2>Delivery Fee by District</h2>
<table>
    <tr>
        <th>District</th>
        <th>Delivery Fee</th>
        <th>Action</th>
    </tr>
    <%
        while (rsDistricts.next()) {
    %>
    <form method="post">
        <tr>
            <td><%= rsDistricts.getString("district") %></td>
            <td>
                <input type="number" step="0.01" name="fee" value="<%= rsDistricts.getString("delivery_fee") %>" />
                <input type="hidden" name="district" value="<%= rsDistricts.getString("district") %>" />
            </td>
            <td><input type="submit" name="update_district" value="Update" /></td>
        </tr>
    </form>
    <%
        }
    %>
</table>

<h2>Delivery Methods</h2>
<table>
    <tr>
        <th>Delivery Method</th>
        <th>Delivery Fee</th>
        <th>Action</th>
    </tr>
    <%
        while (rsMethods.next()) {
    %>
    <form method="post">
        <tr>
            <td><%= rsMethods.getString("delivery_method") %></td>
            <td>
                <input type="number" step="0.01" name="method_fee" value="<%= rsMethods.getString("delivery_fee") %>" />
                <input type="hidden" name="method" value="<%= rsMethods.getString("delivery_method") %>" />
            </td>
            <td><input type="submit" name="update_method" value="Update" /></td>
        </tr>
    </form>
    <%
        }

        con.close();
    %>
</table>

        
    </div>
</body>
</html>