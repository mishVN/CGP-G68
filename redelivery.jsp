<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Return or Redelivery Request</title></head>
<body>
    <h2>Request Return or Redelivery</h2>
    <form action="ReturnRedeliveryServlet" method="post">
        Order ID: <input type="text" name="orderId" required /><br/>
        Name: <input type="text" name="customerName" required /><br/>
        Action:
        <select name="actionType">
            <option value="return">Return</option>
            <option value="redelivery">Redelivery</option>
        </select><br/>
        Preferred Date: <input type="date" name="preferredDate" /><br/>
        Reason:<br/>
        <textarea name="reason" rows="4" cols="40"></textarea><br/>
        <input type="submit" value="Submit Request"/>
    </form>
</body>
</html>