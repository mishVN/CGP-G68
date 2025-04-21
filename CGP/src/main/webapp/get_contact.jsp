<%@ page import="java.sql.*" %>
<%
    String orderId = request.getParameter("order_id");
    String contact = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/cgp", "root", "3323");

        PreparedStatement ps = con.prepareStatement(
            "SELECT db.contact_number FROM order_delivery_boy odb JOIN delivery_boy db ON odb.id = db.id WHERE odb.order_id = ?"
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delivery Contact</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        header {
            background-color: #043659;
            color: #ffffff;
            padding: 25px 20px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        header h1 {
            margin: 0;
            font-size: 2rem;
            letter-spacing: 0.5px;
        }

        .card {
            background-color: #fff;
            margin: auto;
            margin-top: 50px;
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
            text-align: center;
            max-width: 450px;
            width: 90%;
            animation: fadeIn 0.4s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            color: #043659;
            font-size: 22px;
            margin-bottom: 25px;
        }

        p {
            font-size: 17px;
            color: #333;
            margin-bottom: 20px;
        }

        .btn {
            display: inline-block;
            padding: 12px 25px;
            margin: 8px 6px;
            font-size: 15px;
            border-radius: 8px;
            text-decoration: none;
            color: #fff;
            font-weight: 500;
            background: linear-gradient(135deg, #0072ff, #00c6ff);
            transition: all 0.3s ease;
        }

        .btn:hover {
            background: linear-gradient(135deg, #005ecb, #009dcc);
            transform: scale(1.05);
        }

        .no-contact {
            color: #dc3545;
            font-weight: bold;
        }

        .back-btn {
            margin-top: 30px;
            font-size: 14px;
            text-decoration: none;
            color: #0072ff;
            transition: 0.3s;
            display: inline-block;
        }

        .back-btn:hover {
            color: #0056b3;
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .card {
                padding: 30px 20px;
            }

            h2 {
                font-size: 20px;
            }

            .btn {
                padding: 10px 20px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

    <header>
        <h1>Customer Support</h1>
    </header>

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
                <p class="no-contact">No delivery person found for Order ID: <%= orderId %></p>
            <%
                }
            %>
        </div>
        <a class="back-btn" href="setting_seller.jsp">? Back to Search</a>
    </div>

</body>
</html>
