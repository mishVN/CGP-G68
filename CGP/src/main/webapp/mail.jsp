<%@ page import="java.util.Properties" %>
<%@ page import="jakarta.mail.*" %>
<%@ page import="jakarta.mail.internet.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Email Sender</title>
</head>
<body>

    <h2>Send an Email</h2>

    <form method="post">
        <label>Recipient Email:</label>
        <input type="email" name="email" required> <br><br>

        <label>Subject:</label>
        <input type="text" name="subject" required> <br><br>

        <label>Message:</label>
        <textarea name="message" rows="4" required></textarea> <br><br>

        <button type="submit" name="sendEmail">Send</button>
    </form>

<%
    if (request.getMethod().equalsIgnoreCase("post") && request.getParameter("sendEmail") != null) {
        String toEmail = request.getParameter("email");
        String subject = request.getParameter("subject");
        String messageText = request.getParameter("message");

        final String senderEmail = "snappydrop066@gmail.com"; // Replace with your email
        final String senderPassword = "_Snappydrop@68"; // Use Google App Password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // ✅ Renamed "session" to "mailSession"
        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(senderEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);
            msg.setText(messageText);

            Transport.send(msg);
%>
            <p style="color: green;">Email Sent Successfully to <%= toEmail %>!</p>
<%
        } catch (MessagingException e) {
%>
            <p style="color: red;">Error Sending Email: <%= e.getMessage() %></p>
<%
        }
    }
%>

</body>
</html>
