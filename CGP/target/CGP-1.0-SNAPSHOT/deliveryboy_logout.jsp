<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // DB connection info
    String url = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPass = "3323";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Delete all data from loged_delevery_boy
        String deleteQuery = "DELETE FROM loged_delevery_boy";
        stmt = conn.prepareStatement(deleteQuery);
        stmt.executeUpdate();

        // Optional: Invalidate session (if using sessions)
        session.invalidate();

        // Redirect to login page
        response.sendRedirect("deliveryboy_login.jsp");

    } catch (Exception e) {
        out.println("Error during logout: " + e.getMessage());
    } finally {
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
