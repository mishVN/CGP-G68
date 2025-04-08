<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginError = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM delivery_boy WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int deliveryId = rs.getInt("id");
                String deliveryName = rs.getString("name");

                // Insert into koged_delivery_boy
                PreparedStatement insertPs = conn.prepareStatement("REPLACE INTO loged_delevery_boy (id, name) VALUES (?, ?)");
                insertPs.setInt(1, deliveryId);
                insertPs.setString(2, deliveryName);
                insertPs.executeUpdate();
                insertPs.close();

                response.sendRedirect("deliveryboy_dashboard.jsp");
                return;
            } else {
                loginError = "Invalid email or password.";
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            loginError = "Database error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delivery Boy Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #89f7fe, #66a6ff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 90%;
            max-width: 400px;
            animation: fadeIn 0.6s ease-in-out;
        }
        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(-20px);}
            to {opacity: 1; transform: translateY(0);}
        }
        h2 {
            text-align: center;
            color: #4a4a4a;
        }
        .input-group {
            margin: 20px 0;
        }
        .input-group label {
            font-weight: 600;
            margin-bottom: 5px;
            display: block;
            color: #333;
        }
        .input-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #66a6ff;
            border-radius: 10px;
            font-size: 16px;
            outline: none;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #66a6ff;
            color: white;
            border: none;
            font-size: 18px;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn:hover {
            background-color: #4e91f2;
        }
        .error {
            color: red;
            text-align: center;
            font-size: 14px;
        }
        .account{
            text-decoration: none;
            color: #333;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Delivery Boy Login</h2>
    <form method="POST" onsubmit="return validateForm()">
        <div class="input-group">
            <label for="Email">E mail</label>
            <input type="email" id="email" name="email" placeholder="Enter email" required>
        </div>
        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" required>
        </div>
        <div class="input-group">
            <a href="deliveryboy_register.jsp" class="account"> I have an Account</a>
            </div>
        <button type="submit" class="btn">Login</button>
        <% if (!loginError.isEmpty()) { %>
            <div class="error"><%= loginError %></div>
        <% } %>
    </form>
</div>

<script>
    function validateForm() {
        const u = document.getElementById("email").value.trim();
        const p = document.getElementById("password").value.trim();
        if (!u || !p) {
            alert("All fields are required!");
            return false;
        }
        return true;
    }
</script>
</body>
</html>
