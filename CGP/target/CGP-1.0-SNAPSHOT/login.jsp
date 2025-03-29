<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courier Service - Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url('3.jpg') no-repeat center center/cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 20px;
        }
        .main-container {
            display: flex;
            padding: 40px;
            width: 80%;
            max-width: 1200px;
            backdrop-filter: blur(10px);
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
        }
        .description {
            width: 40%;
            text-align: left;
            padding: 20px;
            color: white;
            margin-right: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(10px);
        }
        .form-container {
            width: 60%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .buttons input[type="radio"] {
            display: none;
        }
        .buttons label {
            padding: 12px 24px;
            border-radius: 30px;
            border: 2px solid #043659;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
            font-weight: bold;
            backdrop-filter: blur(10px);
        }
        .buttons input[type="radio"]:checked + label {
            background-color: #011023;
            color: white;
        }
        .container {
            padding: 30px;
            border-radius: 8px;
            width: 100%;
            max-width: 500px;
            display: none;
        }
        .container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: white;
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #011520;
            border-radius: 5px;
            font-size: 14px;
            background-color: rgba(0, 0, 0, 0.4);
            color: white;
        }
        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background: #0a4064;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
            transition: 0.3s;
        }
        button[type="submit"]:hover {
            background: #005f92;
        }
        .no-account {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
            color: #333;
        }
        .no-account a {
            color: #007BFF;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }
        .no-account a:hover {
            text-decoration: underline;
        }
        .error {
            color: red;
            text-align: center;
            font-size: 14px;
        }
    </style>
    <script>
        function showForm(userType) {
            document.getElementById("customerForm").style.display = userType === "customer" ? "block" : "none";
            document.getElementById("courierForm").style.display = userType === "courier" ? "block" : "none";
        }
    </script>
</head>
<body>
    <div class="main-container">
        <div class="description">
            <h2>About Courier Service</h2>
            <p>Our courier service provides fast, reliable, and efficient delivery solutions. We ensure your packages are safely transported to their destinations on time.</p>
        </div>
        <div class="form-container">
            <div class="buttons">
                <input type="radio" id="customer" name="userType" value="customer" onclick="showForm('customer')">
                <label for="customer">Customer</label>
                <input type="radio" id="courier" name="userType" value="courier" onclick="showForm('courier')">
                <label for="courier">Seller</label>
            </div>
            <div id="customerForm" class="container">
                <h2>Customer Login</h2>
                <form method="post">
                    <input type="hidden" name="userType" value="customer">
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <p class="no-account">I have not an account? <a href="registor.jsp">Sign up</a></p>
                    <button type="submit">Login</button>
                </form>
            </div>
            <div id="courierForm" class="container">
                <h2>Seller Login</h2>
                <form method="post">
                    <input type="hidden" name="userType" value="courier">
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <p class="no-account">I have not an account? <a href="registor.jsp">Sign up</a></p>
                    <button type="submit">Login</button>
                </form>
            </div>
        </div>
    </div>

 <%@ page import="java.sql.*" %>
<%
String email = request.getParameter("email");
String password = request.getParameter("password");
String userType = request.getParameter("userType");

if (email != null && password != null && userType != null) {
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

        String sql = "";
        if ("customer".equals(userType)) {
            sql = "SELECT * FROM user_account WHERE email = ? AND password = ?";
        } else if ("courier".equals(userType)) {
            sql = "SELECT * FROM shop_accounts WHERE email = ? AND password = ?";
        }

        stmt = conn.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, password);
        rs = stmt.executeQuery();
if ("customer".equals(userType)) {
    if (rs.next()) {  // Check if user exists in user_accounts table
        session.setAttribute("user", email);
        
        Connection tempConn = null;
        PreparedStatement tempStmt = null;
    
        try {
            String tempInsertQuery = "INSERT INTO temp_login_user (username, password) VALUES (?, ?)";
            tempConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
            tempStmt = tempConn.prepareStatement(tempInsertQuery);
            tempStmt.setString(1, email);
            tempStmt.setString(2, password);
            tempStmt.executeUpdate();
            
            
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (tempStmt != null) try { tempStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (tempConn != null) try { tempConn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        
            response.sendRedirect("home.jsp");
    } else {
        out.println("<p class='error'>Invalid email or password!</p>");
    }

    }
    
    
    
    
    
    else if("courier".equals(userType)){
    if (rs.next()) {
            session.setAttribute("user", email);
            Connection tempConn = null;
        PreparedStatement tempStmt = null;
    
        try {
            String tempInsertQuery = "INSERT INTO temp_login_shop (username, password) VALUES (?, ?)";
            tempConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
            tempStmt = tempConn.prepareStatement(tempInsertQuery);
            tempStmt.setString(1, email);
            tempStmt.setString(2, password);
            tempStmt.executeUpdate();
            
            
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (tempStmt != null) try { tempStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (tempConn != null) try { tempConn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
            
            
            
            
            response.sendRedirect("homesaller.jsp");
        } else {
            out.println("<p class='error'>Invalid email or password!</p>");
        }
    }
    } catch (Exception e) {
        out.println("<p class='error'>" + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
}
%>

</body>
</html>
