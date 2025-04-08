<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String msg = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String contact = request.getParameter("contact");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            // Check if email already exists
            PreparedStatement check = conn.prepareStatement("SELECT id FROM delivery_boy WHERE email = ?");
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                msg = "Email already exists. Please use another.";
            } else {
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO delivery_boy (name, email, password, contact_number) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, contact);
                ps.executeUpdate();
                ps.close();
                msg = "Registration successful!";
            }

            rs.close();
            check.close();
            conn.close();
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
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
        .form-box {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 400px;
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
        .msg {
            text-align: center;
            margin-top: 15px;
            color: red;
        }
        .msg.success {
            color: green;
        }
        .account{
            text-decoration: none;
            color: #333;
        }
    </style>
</head>
<body>
 <div class="form-box">
        <h2>Register Delivery Boy</h2>
        <form method="POST" onsubmit="return validateForm()">
            <div class="input-group">
                <label for="name">Full Name</label>
                <input type="text" name="name" id="name" required />
            </div>
            <div class="input-group">
                <label for="email">Email Address</label>
                <input type="email" name="email" id="email" required />
            </div>
            <div class="input-group">
                <label for="contact">Contact Number</label>
                <input type="text" name="contact" id="contact" required />
            </div>
            <div class="input-group">
                <label for="password">Create Password</label>
                <input type="password" name="password" id="password" required />
            </div>
            <div class="input-group">
                    <a href="deliveryboy_login.jsp" class="account"> I have an Account</a>
            </div>
            <button type="submit" class="btn">Register</button>
            <% if (!msg.isEmpty()) { %>
                <div class="msg <%= msg.contains("successful") ? "success" : "" %>"><%= msg %></div>
            <% } %>
        </form>
    </div>

    <script>
        function validateForm() {
            const name = document.getElementById("name").value.trim();
            const email = document.getElementById("email").value.trim();
            const contact = document.getElementById("contact").value.trim();
            const password = document.getElementById("password").value.trim();

            if (name.length < 3 || password.length < 5 || contact.length < 10) {
                alert("Please enter valid details.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
