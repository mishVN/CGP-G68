<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
// Database connection and message handling - SAME AS ORIGINAL
if("POST".equalsIgnoreCase(request.getMethod())) {
    String messageType = "customer"; // Fixed for customer page
    String username = "User";  
    String message = request.getParameter("message");
    
    if(message != null && !message.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
            
            String tableName = "customer_chat";
            String sql = "INSERT INTO "+tableName+" (username, message) VALUES (?, ?)";
            
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, message);
            pstmt.executeUpdate();
            
            // Prevent form resubmission
            response.sendRedirect("customer_chat.jsp");
            return;
            
        } catch(Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Chat</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; padding: 0; }
        .chat-container { max-width: 800px; margin: 20px auto; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 20px; }
        .chat-header { text-align: center; margin-bottom: 20px; }
        .chat-header h1 { color: #007bff; margin: 0; }
        .chat-messages { height: 400px; overflow-y: auto; border: 1px solid #ddd; border-radius: 5px; padding: 10px; margin-bottom: 15px; }
        .message-form input[type="text"] { width: calc(100% - 90px); padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        .message-form button { width: 80px; padding: 10px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .message { margin-bottom: 10px; padding: 8px 12px; background: #f1f1f1; border-radius: 4px; }
        .message .user { font-weight: bold; color: #333; }
    </style>
    <script>
        function refreshPage() {
            location.reload();
        }
        // Auto-refresh every 5 seconds
        setInterval(refreshPage, 5000);
    </script>
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">
            <h1>Customer Support Chat</h1>
            <p>We're here to help you!</p>
        </div>
        
        <div class="chat-messages">
            <% 
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                 Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT username, message FROM customer_chat ORDER BY timestamp DESC LIMIT 20")) {
                
                while(rs.next()) { %>
                    <div class="message">
                        <span class="user"><%= rs.getString("username") %>:</span>
                        <span class="text"><%= rs.getString("message") %></span>
                    </div>
            <% }
            } catch(Exception e) { %>
                <div class="message">Error loading messages: <%= e.getMessage() %></div>
            <% } %>
        </div>
        
        <form class="message-form" method="POST">
            <input type="text" name="message" placeholder="Type your message here..." required>
            <button type="submit">Send</button>
        </form>
    </div>
</body>
</html>