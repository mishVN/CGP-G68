<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
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
        .container {
         width: 80%;
         margin: 20px auto;
         background: #fff;
         padding: 20px;
         border-radius: 8px;
         box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
         text-align: center;
        }
        
        
        table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

table, th, td {
    border: 1px solid #ddd;
}

th, td {
    padding: 10px;
    text-align: center;
}

th {
    background-color: #007bff;
    color: white;
}

tr:nth-child(even) {
    background-color: #f2f2f2;
}

tr:hover {
    background-color: #ddd;
}




h2, h3 {
    text-align: center;
    color: #333;
}

form {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
}

input {
    padding: 10px;
    width: 200px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

button {
    padding: 10px 15px;
    background-color: #28a745;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background-color: #218838;
}
</style>
</head>
<body>
    <div class="sidebar">
        <h2  class="adminpanle">Admin Panel</h2>
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
        
       
    <div class="container">
        <h2>Payment Details</h2>
        <form method="post">
            <label for="nic">Enter Customer NIC:</label>
            <input type="text" name="nic" id="nic" required>
            <button type="submit">Search</button>
        </form>
        
        <hr>
        
        <h3>All Payments</h3>
        <table>
            <tr>
                <th>Payment ID</th>
                <th>Customer NIC</th>
                <th>Amount</th>
                <th>Payment Method</th>
                <th>Date</th>
            </tr>
            <%
    String nic = request.getParameter("nic"); // Get NIC from request

    if (nic == null || nic.trim().isEmpty()) {
        out.println("<tr><td colspan='5'>Enter Valied Customer NIC!</td></tr>");
    } else {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Load MySQL driver (optional for Java 8+)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            // Use PreparedStatement to prevent SQL injection
            String query = "SELECT * FROM Payment WHERE customer_nic = ?";
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, nic);

            // Execute query
            rs = pstmt.executeQuery();

            // Process results
            while (rs.next()) {
%>
            <tr>
                <td><%= rs.getInt("payment_id") %></td>
                <td><%= rs.getString("customer_nic") %></td>
                <td><%= rs.getDouble("amount") %></td>
                <td><%= rs.getString("payment_method") %></td>
                <td><%= rs.getDate("payment_date") %></td>
            </tr>
<%
            }

        } catch (Exception e) {
            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            // Close resources properly
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
    }
%>

        </table>
    </div>
      <div class="container">
        <h2>Payment Records</h2>
        <table>
            <tr>
                <th>Payment ID</th>
                <th>Customer NIC</th>
                <th>Amount</th>
                <th>Payment Method</th>
                <th>Date</th>
            </tr>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM payment");

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("payment_id") %></td>
                <td><%= rs.getString("customer_nic") %></td>
                <td><%= rs.getDouble("amount") %></td>
                <td><%= rs.getString("payment_method") %></td>
                <td><%= rs.getDate("payment_date") %></td>
            </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </div>   
    </div>
</body>
</html>