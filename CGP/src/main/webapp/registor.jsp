<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html> 
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courier Service - Register</title>
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
        input, select {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #011520;
            border-radius: 5px;
            font-size: 14px;
            background-color: rgba(0, 0, 0, 0.4);
            -webkit-backdrop-filter: blur(5px);
            backdrop-filter: blur(5px);
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
            align-items: center;
        }
        button[type="submit"]:hover {
            background: #005f92;
        }
        .terms {
            font-size: 14px;
            text-align: center;
            margin-top: 10px;
        }
        .error {
            color: red;
            text-align: center;
            font-size: 14px;
        }
        #message {
            text-align: center;
            color: green;
            font-size: 16px;
            display: none;
        }
        .no-account {
    text-align: center;
    margin-top: 15px;
    font-size: 14px;
    color: white;
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

    </style>
    <script>
        function showForm(userType) {
    document.getElementById("customerForm").style.display = userType === "customer" ? "block" : "none";
    document.getElementById("courierForm").style.display = userType === "courier" ? "block" : "none";
}

// Show customer form by default on page load
document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("customerForm").style.display = "block";
    document.getElementById("customer").checked = true;
});
    </script>
</head>
<body>
    <div class="main-container">
        <div class="description">
            <h2>About Courier Service</h2>
            <p>
                Our courier service provides fast, reliable, and efficient delivery solutions. We ensure- your packages are safely transported to their destinations on time.
            </p>
        </div>
        <div class="form-container">
            <div class="buttons">
                <input type="radio" id="customer" name="userType" value="customer" onclick="showForm('customer')">
                <label for="customer">Customer</label>
                <input type="radio" id="courier" name="userType" value="courier" onclick="showForm('courier')">
                <label for="courier">Seller</label>
            </div>
            <div id="customerForm" class="container">
                <h2>Customer Registration</h2>
                <form  method="post" onsubmit="return validateForm(this);">
                    <input type="hidden" name="userType" value="customer">
                    <input type="text" name="fullname" placeholder="Full Name" required>
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="text" name="address" placeholder="Address" required>
                    <input type="tel" name="phone" placeholder="Phone Number" required>
                    <input type="password" name="password" placeholder="Password" required>
                    <input type="password" name="confirm_password" placeholder="Confirm Password" required>
                      <p class="no-account">I have an account? <a href="login.jsp">Sign IN</a></p>
                    <button type="submit">Register</button>
                </form>
            </div>
            <div id="courierForm" class="container">
                <h2>Seller Registration</h2>
                <form  method="post" onsubmit="return validateForm(this);">
                    <input type="hidden" name="userType" value="courier">
                    <input type="text" id="ownername" name="fullname" placeholder="Owner Name" required>
                    <input type="text" id="shopname" name="shopname" placeholder="Shop Name" required>
                    <input type="email" id="email" name="email" placeholder="Email" required>
                    <input type="tel" id="phone" name="phone" placeholder="Phone Number" required>
                    <input type="text" id="address" name="address" placeholder="Address" required>
                    <input type="password" id="password" name="password" placeholder="Password" required>
                    <input type="password" id="confirm_password" name="confirm_password" placeholder="Confirm Password" required>
                    <p class="no-account">I have an account? <a href="login.jsp">Sign IN</a></p>
                    <button type="submit">Register</button>
                </form>
            </div>
        </div>
    </div>
    <script>
function validateForm(form) {
    let inputs = form.querySelectorAll("input[required]");
    for (let input of inputs) {
        if (input.value.trim() === "") {
            alert("All fields are required!");
            return false;
        }
    }

    let pass = form.querySelector("input[name='password']").value;
    let confirmPass = form.querySelector("input[name='confirm_password']").value;

    if (pass !== confirmPass) {
        alert("Passwords do not match!");
        return false;
    }

    return true;
}
</script>
<form onsubmit="return validateForm();">
    
    <%
    // Database connection settings
    String dbURL = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPassword = "3323";
    
    if (request.getMethod().equalsIgnoreCase("post")) {
        String userType = request.getParameter("userType");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "Passwords do not match!");
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String checkQuery = "SELECT email FROM " + (userType.equals("customer") ? "user_account" : "shop_accounts") + " WHERE email=?";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                   response.sendRedirect("registor.jsp?error=Email already registered!");

                } else {
                    String insertQuery;
                    PreparedStatement pstmt;
                    
                    if (userType.equals("customer")) {
                        insertQuery = "INSERT INTO user_account (user_name, email, user_address, user_phonenumber, password,status) VALUES (?, ?, ?, ?, ?, 'allow')";
                        pstmt = conn.prepareStatement(insertQuery);
                        pstmt.setString(1, request.getParameter("fullname"));
                        pstmt.setString(2, email);
                        pstmt.setString(3, request.getParameter("address"));
                        pstmt.setString(4, request.getParameter("phone"));
                        pstmt.setString(5, password);
                        
                        
                    } else {
                        insertQuery = "INSERT INTO shop_accounts (shop_ownername, shop_name, email, shop_phonenumber, shop_address, password) VALUES (?, ?, ?, ?, ?, ?)";
                        pstmt = conn.prepareStatement(insertQuery);
                        pstmt.setString(1, request.getParameter("fullname"));
                        pstmt.setString(2, request.getParameter("shopname"));
                        pstmt.setString(3, email);
                        pstmt.setString(4, request.getParameter("phone"));
                        pstmt.setString(5, request.getParameter("address"));
                        pstmt.setString(6, password);
                    }

                    int rows = pstmt.executeUpdate();
                if (userType.equals("customer")) {    
                    if (rows > 0) {
                        response.sendRedirect("home.jsp?success=Registration successful!");
                    } else {
                        response.sendRedirect("registor.jsp?error=Registration failed!");
                    }
                 }
                 
                 else{
                  if (rows > 0) {
                        response.sendRedirect("homesaller.jsp?success=Registration successful!");
                    } else {
                        response.sendRedirect("registor.jsp?error=Registration failed!");
                    }
        
        }

                    pstmt.close();
                }

                rs.close();
                checkStmt.close();
                conn.close();
            } catch (ClassNotFoundException | SQLException e) {
                 e.printStackTrace();
            response.sendRedirect("registor.jsp?error=Database error: " + e.getMessage());

            }
        }
        
       


    }
%>
    
</body>
</html>