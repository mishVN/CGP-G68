<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delivery Boy Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #fbc2eb, #a6c1ee);
            min-height: 100vh;
            padding: 20px;
        }
        .header {
            text-align: center;
            color: #fff;
            margin-bottom: 30px;
        }
        .header h1 {
            font-size: 36px;
            margin: 10px 0;
        }
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .card {
            background-color: #ffffffcc;
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            transition: transform 0.2s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card h2 {
            color: #4e54c8;
            margin-bottom: 10px;
        }
        .card p {
            font-size: 18px;
            color: #333;
        }
        .nav-btn {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background: #4e54c8;
            color: white;
            border: none;
            border-radius: 10px;
            text-decoration: none;
            transition: background 0.3s ease;
        }
        .nav-btn:hover {
            background: #5661d1;
        }
        .logout {
            text-align: center;
            margin-top: 40px;
        }
        .logout a {
            color: #ff4b5c;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome, Snappy Drop!</h1>
        <h3>Delivery Boy Dashboard</h3>
        <p>Your dashboard is ready</p>
    </div>

    <div class="dashboard">
        <div class="card">
            <h2>Today's Deliveries</h2>
            <p>12 Packages</p>
            <a href="deliveryboy_task.jsp" class="nav-btn">View Orders</a>
        </div>
        <div class="card">
            <h2>Total Delivered</h2>
            <p>340 Orders</p>
            <a href="history.jsp" class="nav-btn">Delivery History</a>
        </div>
        <div class="card">
            <h2>Your Profile</h2>
            <p>Update Info</p>
            <a href="profile.jsp" class="nav-btn">View Profile</a>
        </div>
        <div class="card">
            <h2>Support</h2>
            <p>Need Help?</p>
            <a href="support.jsp" class="nav-btn">Contact Support</a>
        </div>
    </div>

    <div class="logout">
        <a href="login.jsp">← Logout</a>
    </div>
</body>
</html>
