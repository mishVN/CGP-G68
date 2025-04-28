<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Location Map</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            margin: 0;
            padding: 0;
            color: #fff;
            
        }

        .dashboard-header {
            background: #fff;
            color: #333;
            padding: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border-bottom: 4px solid #00c6ff;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            padding: 30px;
        }
        
        h1 {
            color: #333;
            font-size: 2rem;
            text-align: center;
            margin-top: 20px;
        }

        #map {
            height: 600px;
            width: 100%;
            border-radius: 12px; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

       
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 1.1rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        
        .popup-content {
            font-size: 1.2rem;
            color: #333;
            font-weight: 500;
        }

       
        .message-container {
            width: 90%;
            max-width: 800px;
            margin: 20px auto;
            padding: 15px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        
        @media (max-width: 768px) {
            #map {
                height: 400px;
                width: 100%;
            }
        }
        
        
.leaflet-popup-content a {
    color: #0072ff; 
    font-size: 16px; 
    font-weight: bold;
    text-decoration: none; 
    display: inline-block;
    padding: 5px 10px;
    border-radius: 5px;
    background-color: #f1f9ff; 
    transition: background-color 0.3s ease; 
}


.leaflet-popup-content a:hover {
    background-color: #00c6ff; 
    color: white; 
    text-decoration: none;
}


        
    </style>
</head>
<body>

    <div class="dashboard-header">Navigation Map</div>
    <div class="container">
        <%
    String latStr = request.getParameter("lat");
    String lonStr = request.getParameter("lon");
    String contact = request.getParameter("contact");
    String error = request.getParameter("error");

    if (error != null) {
%>
    <p style="color:red;"><%= error %></p>
<%
    } else if (latStr != null && lonStr != null) {
        double latitude = Double.parseDouble(latStr);
        double longitude = Double.parseDouble(lonStr);
%>

<div id="map"></div>

<script>
    var map = L.map('map').setView([<%= latitude %>, <%= longitude %>], 15);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    var homeIcon = L.icon({
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/25/25694.png',
        iconSize: [40, 40],
        iconAnchor: [20, 40],
        popupAnchor: [0, -40]
    });

    L.marker([<%= latitude %>, <%= longitude %>], {icon: homeIcon})
    .addTo(map)
    .bindPopup("<b>Customer Contact:</b><br><a href='tel:<%= contact %>'><%= contact %></a>")
    .openPopup();

</script>

<%
    } else {
%>
    <p style="color:red;">Error: Invalid coordinates provided!</p>
<%
    }
%>
        
    </div>
</body>
</html>
