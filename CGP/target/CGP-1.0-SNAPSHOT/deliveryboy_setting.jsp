<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String url = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPass = "3323";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    int deliveryBoyId = -1;
    String name = "", email = "", contact = "", password = "";
    String message = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get logged delivery boy
        stmt = conn.prepareStatement("SELECT * FROM loged_delevery_boy LIMIT 1");
        rs = stmt.executeQuery();
        if (rs.next()) {
            deliveryBoyId = rs.getInt("id");
        }
        rs.close();
        stmt.close();

        if (deliveryBoyId != -1) {
            // Fetch full info from main delivery_boy table
            stmt = conn.prepareStatement("SELECT * FROM delivery_boy WHERE id = ?");
            stmt.setInt(1, deliveryBoyId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
                email = rs.getString("email");
                contact = rs.getString("contact_number");
                password = rs.getString("password");
            }
            rs.close();
            stmt.close();
        }

        // Handle update form submission
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            name = request.getParameter("name");
            email = request.getParameter("email");
            contact = request.getParameter("contact");
            password = request.getParameter("password");

            stmt = conn.prepareStatement("UPDATE delivery_boy SET name=?, email=?, contact_number=?, password=? WHERE id=?");
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, contact);
            stmt.setString(4, password);
            stmt.setInt(5, deliveryBoyId);

            int updated = stmt.executeUpdate();
            if (updated > 0) {
                message = "Account updated successfully!";
            } else {
                message = "Failed to update account.";
            }
            stmt.close();
        }

    } catch (Exception e) {
        e.printStackTrace();
        message = "Error: " + e.getMessage();
    } finally {
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Account</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            margin: 0;
            padding: 0;
            color: #fff;
        }

        .container {
            max-width: 500px;
            margin: 60px auto;
            padding: 30px;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            color: #333;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #0072ff;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 8px;
        }

        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px 12px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .btn {
            background-color: #0072ff;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            font-weight: bold;
        }

        .btn:hover {
            background-color: #005ec2;
        }

        .message {
            text-align: center;
            margin-top: 15px;
            font-weight: bold;
            color: green;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Manage Your Account</h2>
    <form method="post">
        <label>Name:</label>
        <input type="text" name="name" value="<%= name %>" required>

        <label>Email:</label>
        <input type="email" name="email" value="<%= email %>" required>

        <label>Contact Number:</label>
        <input type="text" name="contact" value="<%= contact %>" required>

        <label>Password:</label>
        <input type="password" name="password" value="<%= password %>" required>

        <button type="submit" class="btn">Update Info</button>
    </form>

    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>
</div>

</body>
</html>
