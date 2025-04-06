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
    List<Map<String, String>> orders = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get delivery boy ID and name from loged_delivery_boy
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

        // Fetch orders
        String sql = "SELECT * FROM order_delivery_boy WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, deliveryBoyId);
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> order = new HashMap<>();
            order.put("order_id", rs.getString("order_id"));
            order.put("customer_name", rs.getString("customer_name"));
            order.put("address", rs.getString("address"));
            order.put("status", rs.getString("status"));
            orders.add(order);
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delivery Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            color: #fff;
            margin: 0;
            padding: 0;
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
            padding: 30px;
            max-width: 1000px;
            margin: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 16px;
            text-align: center;
            border-bottom: 1px solid #ddd;
            color: #333;
        }

        th {
            background-color: #00c6ff;
            color: #fff;
            font-weight: 600;
        }

        tr:hover {
            background-color: #f1f9ff;
        }

        .welcome {
            font-size: 18px;
            margin-bottom: 20px;
        }

        .status {
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 12px;
            display: inline-block;
        }

        .status.pending {
            background-color: #ffcc00;
            color: #333;
        }

        .status.delivered {
            background-color: #4caf50;
            color: #fff;
        }

        .status.cancelled {
            background-color: #f44336;
            color: #fff;
        }
    </style>
</head>
<body>

    <div class="dashboard-header">Delivery Boy Tasks</div>

    <div class="container">
        <div class="welcome">Welcome, <strong><%= deliveryBoyName %></strong>!</div>

        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer Name</th>
                    <th>Address</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (orders.size() == 0) {
                %>
                    <tr>
                        <td colspan="4">No orders found.</td>
                    </tr>
                <%
                    } else {
                        for (Map<String, String> order : orders) {
                            String status = order.get("status").toLowerCase();
                            String statusClass = "";
                            if (status.equals("pending")) statusClass = "pending";
                            else if (status.equals("delivered")) statusClass = "delivered";
                            else if (status.equals("cancelled")) statusClass = "cancelled";
                %>
                    <tr>
                        <td><%= order.get("order_id") %></td>
                        <td><%= order.get("customer_name") %></td>
                        <td><%= order.get("address") %></td>
                        <td><span class="status <%= statusClass %>"><%= order.get("status") %></span></td>
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
