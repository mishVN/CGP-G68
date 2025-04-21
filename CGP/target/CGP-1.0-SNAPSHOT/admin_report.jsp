<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
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
    .filter, .report-options {
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }
        input, select, button {
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        .summary {
            margin-top: 10px;
            font-weight: bold;
            color: #555;
        }
        .export-buttons {
            margin-top: 10px;
        }
        .export-buttons button {
            background-color: #28a745;
            color: white;
            border: none;
            margin-right: 10px;
            cursor: pointer;
        }
        .export-buttons button:hover {
            background-color: #218838;
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
            <h1>Courier Service Report</h1>
        </header>
        <div class="filter">
        <label>From: <input type="date" id="fromDate"></label>
        <label>To: <input type="date" id="toDate"></label>
        <label>Status: 
            <select id="status">
                <option value="">All</option>
                <option value="Delivered">Delivered</option>
                <option value="Pending">Pending</option>
                <option value="Returned">Returned</option>
            </select>
        </label>
        <button onclick="filterReport()">Filter</button>
    </div>

    <div class="report-options">
        <div class="export-buttons">
            <button onclick="exportToPDF()">Export to PDF</button>
            <button onclick="exportToExcel()">Export to Excel</button>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Tracking Number</th> <!-- New column -->
                <th>Customer Name</th>
                <th>Courier Type</th>
                <th>Date</th>
                <th>Status</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                    String sql = "SELECT tracking_number, customer_name, courier_type, date, status, amount FROM courier_report";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("tracking_number") %></td>
                <td><%= rs.getString("customer_name") %></td>
                <td><%= rs.getString("courier_type") %></td>
                <td><%= rs.getDate("date") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getDouble("amount") %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </tbody>
    </table>
  </div>
</body>
</html>