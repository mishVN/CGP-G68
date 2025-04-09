<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String card_owner = request.getParameter("holder-name");
        String card_number = request.getParameter("card-number");
        int total =0;

        try {
           total = Integer.parseInt(request.getParameter("total"));

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO payment (amount, card_number, card_owner, payment_method) VALUES (?, ?, ?, 'card')"
            );
            ps.setInt(1, total);
            ps.setString(2, card_number);
            ps.setString(3, card_owner);
            ps.executeUpdate();
            ps.close();
            conn.close();

            out.println("<script>alert('Payment saved successfully!');</script>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error saving payment!');</script>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Simple Payment Form</title>
    <style>
        body {
            background-color: white;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        #payment-form {
            background: #f9f9f9;
            padding: 25px;
            border-radius: 10px;
            width: 300px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            color: green;
        }

        .input-container {
            margin-bottom: 15px;
        }

        .input-container label {
            font-size: 14px;
            display: block;
            margin-bottom: 5px;
        }

        .input-container input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: green;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: darkgreen;
        }
    </style>
</head>
<body>

    <form id="payment-form" method="post">
        <h2>Payment Form</h2>

        <div class="input-container">
            <label for="holder-name">Card Holder's Name</label>
            <input type="text" id="holder-name" name="holder-name" placeholder="Owner name"  required>
        </div>
        
        <div class="input-container">
            <label for="card-number">CVC</label>
            <input type="text" id="cvc" name="cvc" placeholder="*" required>
        </div>
        
        <div class="input-container">
            <label for="card-number">EXP Date</label>
            <input type="text" id="expdate" name="expdate" placeholder="dd/mm" required>
        </div>

        <div class="input-container">
            <label for="card-number">Card Number</label>
            <input type="text" id="card-number" name="card-number" placeholder="Card Number" required>
        </div>


        <button type="submit">Pay Now</button>
    </form>

</body>
</html>