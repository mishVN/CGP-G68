<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.IOException"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout Form</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            text-align: center;
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
            background: #d9534f;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
        }
        button:hover {
            background: #c9302c;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Logout</h2>
    <form id="logoutForm" method="post">
        <input type="email" name="email" id="email" placeholder="Enter Email" required>
        <input type="hidden" name="action" value="logout">
        <button type="submit">Logout</button>
    </form>
    <p id="message">
        <% 
            String message = (String) request.getAttribute("message");
            if (message != null) {
                out.print(message);
            }
        %>
    </p>
</div>

<%
    if ("logout".equals(request.getParameter("action"))) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String email = request.getParameter("email");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            // Deleting the user from the temp_login_user table
            String deleteQuery = "DELETE FROM temp_login_shop WHERE username=?";
            pstmt = con.prepareStatement(deleteQuery);
            pstmt.setString(1, email);

            int rowsDeleted = pstmt.executeUpdate();
            request.setAttribute("message", (rowsDeleted > 0) ? "Logout Successful!" : "Failed to Logout.");

        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }

        // Forward request back to JSP page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
%>

</body>
</html>
