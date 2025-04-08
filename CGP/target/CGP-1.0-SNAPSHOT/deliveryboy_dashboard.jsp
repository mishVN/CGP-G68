<%@ page import="java.sql.*, javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // DB connection settings
    String dbURL = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPass = "3323";

    // Declare required variables
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    int deliveryBoyId = 0;
    String deliveryBoyName = "";

    int allDeliveriesCount = 0;
    int acceptedDeliveriesCount = 0;
    int completedDeliveriesCount = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Fetch delivery boy info (for example from a logged-in table)
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

        // Count all deliveries
        stmt = conn.prepareStatement("SELECT COUNT(*) FROM order_delivery_boy WHERE id = ?");
        stmt.setInt(1, deliveryBoyId);
        rs = stmt.executeQuery();
        if (rs.next()) allDeliveriesCount = rs.getInt(1);
        rs.close();
        stmt.close();

        // Count accepted deliveries
        stmt = conn.prepareStatement("SELECT COUNT(*) FROM order_delivery_boy WHERE id = ? AND status = 'Accept'");
        stmt.setInt(1, deliveryBoyId);
        rs = stmt.executeQuery();
        if (rs.next()) acceptedDeliveriesCount = rs.getInt(1);
        rs.close();
        stmt.close();

        // Count completed deliveries
        stmt = conn.prepareStatement("SELECT COUNT(*) FROM order_delivery_boy WHERE id = ? AND status = 'Finished'");
        stmt.setInt(1, deliveryBoyId);
        rs = stmt.executeQuery();
        if (rs.next()) completedDeliveriesCount = rs.getInt(1);
        rs.close();
        stmt.close();

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
    <title>Delivery Boy Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #fbc2eb, #a6c1ee);
            min-height: 100vh;
            padding: 20px;
        }
        .header {
            text-align: center;
            color: #fff;
            margin-bottom: 30px;
        }
        .header h1 { font-size: 36px; margin: 10px 0; }
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .card {
            background-color: #ffffffcc;
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            transition: transform 0.2s ease;
        }
        .card:hover { transform: translateY(-5px); }
        .card h2 { color: #4e54c8; margin-bottom: 10px; }
        .card p { font-size: 18px; color: #333; }
        .nav-btn {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background: #4e54c8;
            color: white;
            border: none;
            border-radius: 10px;
            text-decoration: none;
            transition: background 0.3s ease;
        }
        .nav-btn:hover { background: #5661d1; }
        .logout {
            text-align: center;
            margin-top: 40px;
        }
        .logout a {
            color: #ff4b5c;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome, Snappy Drop!</h1>
        <h3>Delivery Boy Dashboard</h3>
        <p>Your dashboard is ready</p>
    </div>

    <div class="dashboard">
        <div class="card">
            <h2>All Deliveries</h2>
            <p><%= allDeliveriesCount %> Packages</p>
            <a href="deliveryboy_task.jsp" class="nav-btn">View Orders</a>
        </div>
        <div class="card">
            <h2>Accepted Deliveries</h2>
            <p><%= acceptedDeliveriesCount %> Orders</p>
            <a href="deliveryboy_accept.jsp" class="nav-btn">View Accept Orders</a>
        </div>
        <div class="card">
            <h2>Finished Orders</h2>
            <p><%= completedDeliveriesCount %> Completed</p>
            <a href="deliveryboy_finishedorders.jsp" class="nav-btn">View Finished Orders</a>
        </div>
        <div class="card">
            <h2>Setting</h2>
            <p>Manage Account?</p>
            <a href="deliveryboy_setting.jsp" class="nav-btn">Go to Setting</a>
        </div>
    </div>

    <div class="logout">
        <a href="deliveryboy_logout.jsp">← Logout</a>
    </div>
</body>
</html>