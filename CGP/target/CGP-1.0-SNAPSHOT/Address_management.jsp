<%@page import="java.sql.*"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String dbUrl = "jdbc:mysql://localhost:3306/cgp";
    String dbUser = "root";
    String dbPass = "3323";

    String orderIdStr = request.getParameter("orderId");

    double latitude = 0.0;
    double longitude = 0.0;
    boolean locationFound = false;
    String customerContact = "";

    if (orderIdStr != null && !orderIdStr.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            String sql = "SELECT postal_code, customer_contact FROM oders WHERE oder_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(orderIdStr));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String postalCode = rs.getString("postal_code");
                customerContact = rs.getString("customer_contact");

                String apiUrl = "https://nominatim.openstreetmap.org/search?postalcode=" + postalCode + "&format=json&country=Sri+Lanka";
                URL url = new URL(apiUrl);
                HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();
                httpConn.setRequestMethod("GET");
                httpConn.setRequestProperty("User-Agent", "Mozilla/5.0");

                if (httpConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    BufferedReader in = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
                    StringBuilder apiResponse = new StringBuilder();
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        apiResponse.append(inputLine);
                    }
                    in.close();

                    JSONArray jsonArray = new JSONArray(apiResponse.toString());

                    if (jsonArray.length() > 0) {
                        JSONObject location = jsonArray.getJSONObject(0);
                        latitude = location.getDouble("lat");
                        longitude = location.getDouble("lon");
                        locationFound = true;
                    }
                }
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }

    // Send Data to map.jsp using redirect
    if (locationFound) {
        response.sendRedirect("map.jsp?lat=" + latitude + "&lon=" + longitude + "&contact=" + customerContact);
    } else {
        response.sendRedirect("map.jsp?error=Location not found for Order ID: " + orderIdStr);
    }
%>
