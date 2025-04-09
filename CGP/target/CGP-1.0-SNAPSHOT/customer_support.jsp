<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPass = "3323";
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
    } catch (Exception e) {
        out.println("<script>alert('Database Connection Failed: " + e.getMessage() + "');</script>");
    }

    String feedback = request.getParameter("feedback");
    if (feedback != null && !feedback.trim().isEmpty() && feedback.length() <= 500) {
        try {
            String sql = "INSERT INTO customer_feedback (feedback) VALUES (?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, feedback);
            pstmt.executeUpdate();
            pstmt.close();
            response.sendRedirect("customer_support.jsp");
        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Support</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap');

        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f0f4f8, #d9e2ec);
            color: #1f2937;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            background: rgba(255, 255, 255, 0.85);
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }

        h2 {
            text-align: center;
            font-size: 32px;
            color: #111827;
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 20px;
            color: #2563eb;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .support-section, .feedback-section, .faq-section, .feedback-list {
            margin-bottom: 30px;
            background-color: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .support-section p {
            margin: 10px 0;
            font-size: 16px;
        }

        a {
            color: #2563eb;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        textarea {
            width: 100%;
            padding: 14px;
            border: 1px solid #ccc;
            border-radius: 10px;
            font-size: 16px;
            resize: vertical;
            margin-bottom: 15px;
        }

        .button {
            display: inline-block;
            padding: 12px 24px;
            background-color: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .button:hover {
            background-color: #1e40af;
        }

        .feedback-item {
            padding: 12px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .feedback-item:last-child {
            border-bottom: none;
        }

        .feedback-item strong {
            display: block;
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 5px;
        }

        .faq-item {
            cursor: pointer;
            font-weight: 600;
            padding: 10px;
            background: #f1f5f9;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: background 0.2s ease;
        }

        .faq-item:hover {
            background: #e2e8f0;
        }

        .faq-answer {
            display: none;
            padding: 10px 15px;
            background: #fff;
            border-left: 4px solid #2563eb;
            margin-top: 5px;
            color: #374151;
            border-radius: 0 0 8px 8px;
        }

        @media (max-width: 600px) {
            .container {
                margin: 20px;
                padding: 20px;
            }

            h2 {
                font-size: 26px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Customer Support</h2>

        <div class="support-section">
            <h3 class="section-title">Contact Us</h3>
            <p><strong>Live Chat:</strong> <a href="livechat.jsp">Start a chat</a></p>
            <p><strong>Email:</strong> <a href="snappydrop066@gmail.com">support@courierservice.com</a></p>
            <p><strong>Phone:</strong> <a href="tel:+12345678900">+1-234-567-8900</a></p>
        </div>

        <div class="feedback-section">
            <h3 class="section-title">Feedback & Problem Report</h3>
            <form method="POST">
                <textarea name="feedback" rows="4" maxlength="500" placeholder="Write your feedback or report an issue (Max 500 characters)..."></textarea>
                <button type="submit" class="button">Submit</button>
            </form>
        </div>

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
            const el = document.getElementById(id);
            el.style.display = el.style.display === "block" ? "none" : "block";
        }
    </script>
</body>
</html>