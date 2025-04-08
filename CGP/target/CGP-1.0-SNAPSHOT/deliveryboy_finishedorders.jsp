<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String url = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPass = "3323";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    int deliveryBoyId = -1;
    String deliveryBoyName = "";
    List<Map<String, String>> finishedOrders = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get delivery boy info
        stmt = conn.prepareStatement("SELECT id, name FROM loged_delevery_boy LIMIT 1");
        rs = stmt.executeQuery();
        if (rs.next()) {
            deliveryBoyId = rs.getInt("id");
            deliveryBoyName = rs.getString("name");
        } else {
            response.sendRedirect("deliveryboy_login.jsp");
            return;
        }
        rs.close();
        stmt.close();

        // Fetch finished orders
        stmt = conn.prepareStatement("SELECT * FROM order_delivery_boy WHERE id = ? AND status = 'Finished' ORDER BY order_id DESC");
        stmt.setInt(1, deliveryBoyId);
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> order = new HashMap<>();
            order.put("order_id", rs.getString("order_id"));
            order.put("customer_id", rs.getString("customer_ID"));
            order.put("address", rs.getString("address"));
            order.put("status", rs.getString("status"));
            finishedOrders.add(order);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Finished Deliveries</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            margin: 0;
            padding: 0;
            color: #fff;
        }

        .dashboard-header {
            background: #fff;
            color: #333;
            padding: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border-bottom: 4px solid #00c6ff;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            padding: 30px;
        }

        .welcome {
            font-size: 18px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            color: #333;
        }

        th, td {
            padding: 14px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        th {
            background-color: #00c6ff;
            color: #fff;
        }

        tr:hover {
            background-color: #f1f9ff;
        }

        .status {
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 12px;
            display: inline-block;
        }

        .finished {
            background-color: #4caf50;
            color: white;
        }

    </style>
</head>
<body>

    <div class="dashboard-header">Finished Deliveries</div>

    <div class="container">
        <div class="welcome">Welcome, <strong><%= deliveryBoyName %></strong>! These are your completed deliveries:</div>

        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer ID</th>
                    <th>Address</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (finishedOrders.size() == 0) {
                %>
                    <tr>
                        <td colspan="4">No finished deliveries found.</td>
                    </tr>
                <%
                    } else {
                        for (Map<String, String> order : finishedOrders) {
                %>
                    <tr>
                        <td><%= order.get("order_id") %></td>
                        <td><%= order.get("customer_id") %></td>
                        <td><%= order.get("address") %></td>
                        <td><span class="status finished"><%= order.get("status") %></span></td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>
