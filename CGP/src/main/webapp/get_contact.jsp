<%@ page import="java.sql.*" %>
<%
    String orderId = request.getParameter("order_id");
    String contact = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/cgp", "root", "3323"); 

        PreparedStatement ps = con.prepareStatement(
            "SELECT db.contact_number FROM order_delivery_boy odb JOIN delivery_boy db ON odb.id = db.id WHERE odb.order_id =?"
        );
        ps.setString(1, orderId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            contact = rs.getString("contact_number");
        }
        con.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delivery Contact</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .card {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 400px;
            width: 90%;
        }

        h2 {
            color: #343a40;
            margin-bottom: 20px;
        }

        p {
            font-size: 18px;
            color: #333;
        }

        .btn {
            display: inline-block;
            padding: 12px 25px;
            margin: 10px 5px 0 5px;
            font-size: 15px;
            border-radius: 6px;
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .contact {
            margin-top: 20px;
        }

        .no-contact {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>Delivery Contact Details</h2>
        <div class="contact">
            <%
                if (contact != null) {
            %>
                <p><strong>Contact Number:</strong> <%= contact %></p>
                <a class="btn" href="tel:<%= contact %>">? Call</a>
                <a class="btn" href="https://wa.me/<%= contact.replace("+", "") %>" target="_blank">? WhatsApp</a>
            <%
                } else {
            %>
                <p class="no-contact">No delivery boy found for Order ID: <%= orderId %></p>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>