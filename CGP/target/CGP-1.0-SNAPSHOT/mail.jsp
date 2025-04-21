<%@ page import="java.sql.*, java.util.Properties, jakarta.mail.*, jakarta.mail.internet.*, java.io.*" %>
<%@ page contentType="text/plain;charset=UTF-8" %>

<%
    String orderId = request.getParameter("order_id");
    String subject = request.getParameter("subject");
    String messageText = request.getParameter("message");

    String result = "fail";

    if (orderId != null && subject != null && messageText != null) {
        String recipientEmail = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            PreparedStatement pstmt = con.prepareStatement(
                "SELECT ua.email FROM oders o JOIN user_account ua ON o.customer_id = ua.user_id WHERE o.oder_id = ?"
            );
            pstmt.setInt(1, Integer.parseInt(orderId));
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                recipientEmail = rs.getString("email");
            }

            rs.close();
            pstmt.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (recipientEmail != null) {
            final String senderEmail = "snappydrop066@gmail.com";
            final String senderPassword = "izcpdgmahqnzjsvr";

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            try {
                Message msg = new MimeMessage(mailSession);
                msg.setFrom(new InternetAddress(senderEmail, "SnappyDrop Admin"));
                msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
                msg.setSubject(subject);
                msg.setContent("<p>" + messageText + "</p>", "text/html; charset=UTF-8");

                Transport.send(msg);
                result = "success";
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    out.print(result);
%>
