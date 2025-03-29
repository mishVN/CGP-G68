<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaflet Map with Postal Code Search</title>
    
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />

    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        #map { 
            height: 500px; 
            width: 100%; 
            margin-top: 10px;
        }
        #search-container {
            margin: 10px;
        }
        input, button {
            padding: 8px;
            font-size: 16px;
        }
    </style>
</head>
<body>

    <h2>Search Location by Postal Code</h2>

    <!-- Search Box -->
    <div id="search-container">
        <input type="text" id="postalCode" placeholder="Enter Postal Code">
        <button onclick="searchLocation()">Search</button>
    </div>

    <div id="map"></div>

    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

    <script>
        // Initialize the map
        var map = L.map('map').setView([51.505, -0.09], 13);

        // Load OpenStreetMap tiles
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);

        // Default marker
        var marker = L.marker([51.5, -0.09]).addTo(map)
            .bindPopup('A pretty CSS popup.<br> Easily customizable.')
            .openPopup();

        // Function to search for location based on Postal Code
        function searchLocation() {
            var postalCode = document.getElementById("postalCode").value.trim();
            
            if (postalCode === "") {
                alert("Please enter a postal code!");
                return;
            }

            // Use OpenStreetMap Nominatim API to get location from Postal Code
            var url = `https://nominatim.openstreetmap.org/search?format=json&q=${postalCode}`;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.length > 0) {
                        var lat = parseFloat(data[0].lat);
                        var lon = parseFloat(data[0].lon);

                        // Update map view
                        map.setView([lat, lon], 13);

                        // Update marker position
                        marker.setLatLng([lat, lon])
                            .bindPopup(`Location for Postal Code: ${postalCode}`)
                            .openPopup();
                    } else {
                        alert("Location not found! Please try a valid postal code.");
                    }
                })
                .catch(error => {
                    console.error("Error fetching data:", error);
                    alert("An error occurred while fetching location data.");
                });
        }
    </script>

</body>
</html>
