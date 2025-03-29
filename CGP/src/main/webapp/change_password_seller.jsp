<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            text-align: center;
            padding: 50px;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px 0px #aaa;
            width: 300px;
            margin: auto;
        }
        input {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #043659;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #218838;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Change Password</h2>
        <form id="changePasswordForm" method="post">
            <input type="email" id="username" name="username" placeholder="Enter UserEmail" required>
            <input type="password" id="oldPassword" name="oldPassword" placeholder="Enter Old Password" required>
            <input type="password" id="newPassword" name="newPassword" placeholder="Enter New Password" required>
            <button type="submit">Change Password</button>
        </form>
        <p id="message" class="error"></p>
    </div>

    <script>
        document.getElementById("changePasswordForm").onsubmit = function(event) {
            let newPassword = document.getElementById("newPassword").value;
            if (newPassword.length < 6) {
                document.getElementById("message").innerText = "New password must be at least 6 characters long.";
                event.preventDefault();
            }
        };
    </script>

    <%
        if (request.getMethod().equalsIgnoreCase("post")) {
            String username = request.getParameter("username");
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            String url = "jdbc:mysql://localhost:3306/cgp";
            String dbUser = "root";
            String dbPassword = "3323";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUser, dbPassword);

                // Check if username and old password match
                String checkQuery = "SELECT * FROM shop_accounts WHERE email=? AND password=?";
                stmt = conn.prepareStatement(checkQuery);
                stmt.setString(1, username);
                stmt.setString(2, oldPassword);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    // Update new password
                    String updateQuery = "UPDATE shop_accounts SET password=? WHERE email=?";
                    stmt = conn.prepareStatement(updateQuery);
                    stmt.setString(1, newPassword);
                    stmt.setString(2, username);
                    int updated = stmt.executeUpdate();

                    if (updated > 0) {
                        out.println("<script>alert('Password changed successfully!'); window.location='change_password_seller.jsp';</script>");
                    } else {
                        out.println("<script>document.getElementById('message').innerText = 'Password update failed!';</script>");
                    }
                } else {
                    out.println("<script>document.getElementById('message').innerText = 'Invalid email or password!';</script>");
                }
            } catch (Exception e) {
                out.println("<script>document.getElementById('message').innerText = 'Database error!';</script>");
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        }
    %>
</body>
</html>