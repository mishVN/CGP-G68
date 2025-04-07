<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courier Service Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
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
<div class="container">
    <h2>Courier Service Report</h2>

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
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_database", "username", "password");
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