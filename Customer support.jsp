<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // Database connection details
    String dbURL = "jdbc:mysql://localhost:3306/courier_service";
    String dbUser = "root"; // Change if needed
    String dbPass = ""; // Change if needed
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
    } catch (Exception e) {
        out.println("<script>alert('Database Connection Failed: " + e.getMessage() + "');</script>");
    }

    // Handle feedback submission
    String feedback = request.getParameter("feedback");
    if (feedback != null && !feedback.trim().isEmpty() && feedback.length() <= 500) {
        try {
            String sql = "INSERT INTO customer_feedback (feedback) VALUES (?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, feedback);
            pstmt.executeUpdate();
            pstmt.close();
            response.sendRedirect("customer_support.jsp"); // Refresh page after submission
        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Support</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f7f7;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 70%;
            margin: 50px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            font-size: 28px;
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 22px;
            color: #0056b3;
            margin-bottom: 10px;
        }

        .support-section, .faq-section, .feedback-section {
            background-color: #f9f9f9;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .support-section p, .faq-item {
            font-size: 16px;
            line-height: 1.6;
        }

        .faq-item {
            cursor: pointer;
            padding: 5px;
            margin-top: 10px;
            font-weight: bold;
            color: #007bff;
        }

        .faq-item:hover {
            text-decoration: underline;
        }

        .faq-answer {
            display: none;
            padding: 10px;
            background: #ffffff;
            border-left: 4px solid #007bff;
            margin-top: 5px;
            font-size: 16px;
            color: #555;
        }

        .button {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        .button:hover {
            background-color: #0056b3;
        }

        .feedback-list {
            background-color: #ffffff;
            padding: 20px;
            margin-top: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .feedback-item {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        .feedback-item:last-child {
            border-bottom: none;
        }

        .feedback-item strong {
            display: block;
            color: #333;
            font-size: 14px;
            margin-bottom: 8px;
        }

        textarea {
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 16px;
            margin-bottom: 15px;
            box-sizing: border-box;
        }

        textarea:focus {
            outline: none;
            border-color: #007bff;
        }

        @media (max-width: 768px) {
            .container {
                width: 90%;
                padding: 20px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Customer Support</h2>

        <!-- Contact Support Section -->
        <div class="support-section">
            <h3 class="section-title">Contact Us</h3>
            <p><strong>Live Chat:</strong> <a href="#">Start a chat</a></p>
            <p><strong>Email:</strong> <a href="mailto:support@courierservice.com">support@courierservice.com</a></p>
            <p><strong>Phone:</strong> <a href="tel:+12345678900">+1-234-567-8900</a></p>
        </div>

        <!-- Feedback & Problem Report Section -->
        <div class="feedback-section">
            <h3 class="section-title">Feedback & Problem Report</h3>
            <form method="POST">
                <textarea name="feedback" rows="4" maxlength="500" placeholder="Write your feedback or report an issue (Max 500 characters)..."></textarea>
                <button type="submit" class="button">Submit</button>
            </form>
        </div>

        <!-- Display Customer Feedback -->
        <div class="feedback-list">
            <h3 class="section-title">Customer Feedback</h3>
            <%
                try {
                    String query = "SELECT feedback, submitted_at FROM customer_feedback ORDER BY submitted_at DESC";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    while (rs.next()) {
                        out.println("<div class='feedback-item'><strong>" + rs.getString("submitted_at") + ":</strong> " + rs.getString("feedback") + "</div>");
                    }
                    rs.close();
                    stmt.close();
                } catch (Exception e) {
                    out.println("<p>Error loading feedback.</p>");
                }
            %>
        </div>

        <!-- FAQ Section -->
        <div class="faq-section">
            <h3 class="section-title">Frequently Asked Questions</h3>
            <div class="faq-item" onclick="toggleFaq('faq1')">How do I track my package?</div>
            <div id="faq1" class="faq-answer">You can track your package using the tracking number on our website.</div>

            <div class="faq-item" onclick="toggleFaq('faq2')">What should I do if my package is delayed?</div>
            <div id="faq2" class="faq-answer">If your package is delayed, please contact our support team.</div>

            <div class="faq-item" onclick="toggleFaq('faq3')">How do I request a refund?</div>
            <div id="faq3" class="faq-answer">You can request a refund through your account settings or by contacting our support team.</div>
        </div>
    </div>

    <script>
        function toggleFaq(id) {
            var answer = document.getElementById(id);
            answer.style.display = answer.style.display === "block" ? "none" : "block";
        }
    </script>
</body>
</html>
