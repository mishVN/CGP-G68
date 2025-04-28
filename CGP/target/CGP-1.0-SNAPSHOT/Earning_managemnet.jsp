<%@ page import="java.sql.*, java.text.DecimalFormat" %>
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

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get logged-in delivery boy info
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
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Deliveries</title>
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
            max-width: 900px;
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

        .total-row {
            font-weight: bold;
            background: #e0f7ff;
        }
    </style>
</head>
<body>

<div class="dashboard-header">My Finished Deliveries</div>

<div class="container">
    <div class="welcome">
        Welcome, <strong><%= deliveryBoyName %></strong>! Here's your earnings:
    </div>

    <table>
        <thead>
            <tr>
                <th>Date</th>
                <th>Deliveries</th>
                <th>Base Amount (Rs.)</th>
                <th>Bonuses (Rs.)</th>
                <th>Deductions (Rs.)</th>
                <th>Total Earning (Rs.)</th>
            </tr>
        </thead>
        <tbody>
        <%
            DecimalFormat df = new DecimalFormat("#,##0.00");
            double grandTotal = 0;

            try {
                conn = DriverManager.getConnection(url, dbUser, dbPass);
                stmt = conn.prepareStatement(
                        "SELECT date, deliveries, amount, bonuses, deductions, total_earning " +
                        "FROM earnings WHERE courier_boy_id = ? ORDER BY date DESC"
                );
                stmt.setInt(1, deliveryBoyId);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    String date = rs.getString("date");
                    int deliveries = rs.getInt("deliveries");
                    double amount = rs.getDouble("amount");
                    double bonuses = rs.getDouble("bonuses");
                    double deductions = rs.getDouble("deductions");
                    double total = rs.getDouble("total_earning");

                    grandTotal += total;
        %>
            <tr>
                <td><%= date %></td>
                <td><%= deliveries %></td>
                <td>Rs. <%= df.format(amount) %></td>
                <td>Rs. <%= df.format(bonuses) %></td>
                <td>Rs. <%= df.format(deductions) %></td>
                <td>Rs. <%= df.format(total) %></td>
            </tr>
        <%
                }

                if (grandTotal == 0) {
        %>
            <tr>
                <td colspan="6">No finished deliveries yet.</td>
            </tr>
        <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
        <% if (grandTotal > 0) { %>
        <tfoot>
            <tr class="total-row">
                <td colspan="5">Grand Total</td>
                <td>Rs. <%= df.format(grandTotal) %></td>
            </tr>
        </tfoot>
        <% } %>
    </table>
</div>

</body>
</html>
