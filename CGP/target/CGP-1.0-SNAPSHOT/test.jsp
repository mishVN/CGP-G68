<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courier Service Search</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
            text-align: center;
        }
        .search-container {
            position: relative;
            max-width: 400px;
            margin: 20px auto;
        }
        input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 2px solid #007bff;
            border-radius: 5px;
            outline: none;
        }
        .search-results {
            max-width: 400px;
            margin: auto;
            text-align: left;
            background: white;
            border-radius: 5px;
            box-shadow: 0px 2px 5px rgba(0,0,0,0.2);
            display: none;
            position: absolute;
            width: 100%;
        }
        .search-results div {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            cursor: pointer;
        }
        .search-results div:hover {
            background: #007bff;
            color: white;
        }
    </style>
</head>
<body>

    <h2>Courier Service - Search Orders</h2>
    
    <div class="search-container">
        <input type="text" id="search" placeholder="Search orders, tracking numbers..." onkeyup="filterResults()">
        <div class="search-results" id="results"></div>
    </div>

    <script>
        const orders = [
            "Order #123456 - Delivered",
            "Order #789012 - In Transit",
            "Tracking #456XYZ - Pending",
            "Order #111222 - Out for Delivery",
            "Tracking #999ZZZ - Delivered"
        ];

        function filterResults() {
            let input = document.getElementById("search").value.toLowerCase();
            let resultBox = document.getElementById("results");
            resultBox.innerHTML = "";
            
            if (input.trim() === "") {
                resultBox.style.display = "none";
                return;
            }

            let filteredOrders = orders.filter(order => order.toLowerCase().includes(input));

            if (filteredOrders.length === 0) {
                resultBox.innerHTML = "<div>No results found</div>";
            } else {
                filteredOrders.forEach(order => {
                    let div = document.createElement("div");
                    div.innerHTML = order;
                    div.onclick = () => alert("Selected: " + order);
                    resultBox.appendChild(div);
                });
            }

            resultBox.style.display = "block";
        }
    </script>

</body>
</html>