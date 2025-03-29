<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Courier Service</title>
    <link rel="stylesheet" href="styles.css">
    <script defer src="script.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #74ebd5, #acb6e5);
            height: 100vh;
            display: flex;
        }
        
        .adminpanle{
            text-align: center;
        }
        
        .sidebar {
            width: 250px;
            background: #333;
            color: white;
            height: 100%;
            padding-top: 20px;
            position: fixed;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
            
        }
        .sidebar ul li {
            padding: 25px;
            text-align: center;
            
        }
        .sidebar ul li a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            display: block;
        }
        .sidebar ul li a:hover {
            background: #007bff;
            padding: 25px;
            border-radius: 10px;
        }
        .main-content {
            margin-left: 250px;
            flex: 1;
            padding: 20px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 1s ease-out forwards;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .dashboard {
            display: flex;
            flex-direction: row;
            
            justify-content: center;
            gap: 10px;
            width: 100%;
        }
        
        .stat-box {
            background: #007bff;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            width: 30%;
            min-width: 150px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease-in-out;
        }
        .stat-box:hover {
            transform: scale(1.05);
        }
        .stat-box h2 {
            margin: 0 0 10px;
        }
           
                form {
    background: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    max-width: 500px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding-left: 50px;
    padding-right: 50px;
}
form input, form select, form button {
    padding: 10px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

form button {
    background-color: #043659;
    color: white;
    border: none;
    cursor: pointer;
}

form button:hover {
    background-color: #0072ff;
}
h2, h3 {
    text-align: center;
    color: #333;
}
#searchInput {
    width: 50%;
    padding: 8px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 4px;
    text-align: center;
    align-content: center;
}
.delete-btn {
    background-color: #dc3545 !important;
}

.delete-btn:hover {
    background-color: #c82333 !important;
}

#itemTable {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background: white;
}

#itemTable th, #itemTable td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: center;
}

#itemTable th {
    background-color: #043659;
    color: white;
}

#itemTable tr:nth-child(even) {
    background-color: #f2f2f2;
}

#itemTable img {
    border-radius: 5px;
}

 
    </style>
</head>
<body>
    <div class="sidebar">
        <h2  class="adminpanle">Admin Panel</h2>
        <ul>
            <li><a href="admin_home.jsp">Dashboard</a></li>
            <li><a href="admin_oderdetails.jsp">Orders</a></li>
            <li><a href="packedoder.jsp">Packed Oder</a></li>
            <li><a href="ondelivery.jsp">On Delivery</a></li>
            <li><a href="finished_oder.jsp">Finished Orders</a></li>
            <li><a href="viewpayments.jsp">Payments</a></li>
            <li><a href="admin_customers.jsp">Customers</a></li>
            <li><a href="admin_shop.jsp">Sellers</a></li>
            <li><a href="admin_itemmanagement.jsp">Item Management</a></li>
        </ul>
    </div>
    <div class="main-content">
         <div class="container">
  <h2>Item Management</h2>

<!-- Handle Insert, Update, Delete Operations -->
<%
    Connection con = null;
    PreparedStatement pstmt = null;
    String message = "";

    // Get request parameters
    String action = request.getParameter("action");
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    String price = request.getParameter("price");
    String stock = request.getParameter("stock");
    String category = request.getParameter("category");
    String url = request.getParameter("url");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

        if ("add".equals(action) && name != null && description != null && price != null && stock != null && category != null && url != null) {
            // Insert Query
            String insertQuery = "INSERT INTO items (item_name, item_description, price, stock, category, img_url) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = con.prepareStatement(insertQuery);
            pstmt.setString(1, name);
            pstmt.setString(2, description);
            pstmt.setDouble(3, Double.parseDouble(price));
            pstmt.setInt(4, Integer.parseInt(stock));
            pstmt.setString(5, category);
            pstmt.setString(6, url);
            int rowsInserted = pstmt.executeUpdate();
            message = (rowsInserted > 0) ? "Item added successfully!" : "Failed to add item.";
        } else if ("update".equals(action) && id != null && name != null && description != null && price != null && stock != null && category != null && url != null) {
            // Update Query
            String updateQuery = "UPDATE items SET item_name=?, item_description=?, price=?, stock=?, category=?, img_url=? WHERE item_code=?";
            pstmt = con.prepareStatement(updateQuery);
            pstmt.setString(1, name);
            pstmt.setString(2, description);
            pstmt.setDouble(3, Double.parseDouble(price));
            pstmt.setInt(4, Integer.parseInt(stock));
            pstmt.setString(5, category);
            pstmt.setString(6, url);
            pstmt.setInt(7, Integer.parseInt(id));
            int rowsUpdated = pstmt.executeUpdate();
            message = (rowsUpdated > 0) ? "Item updated successfully!" : "Failed to update item.";
        } else if ("delete".equals(action) && id != null) {
            // Delete Query
            String deleteQuery = "DELETE FROM items WHERE item_code=?";
            pstmt = con.prepareStatement(deleteQuery);
            pstmt.setInt(1, Integer.parseInt(id));
            int rowsDeleted = pstmt.executeUpdate();
            message = (rowsDeleted > 0) ? "Item deleted successfully!" : "Failed to delete item.";
        }
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>

<!-- Display Message -->
<% if (!message.isEmpty()) { %>
    <p style="color:<%= message.startsWith("Error") ? "red" : "green" %>;"><%= message %></p>
<% } %>

<!-- Unified Form for Add, Update, Delete -->
<form method="post">
    <input type="hidden" name="action" value="add">
    <input type="number" name="id" placeholder="Item ID (Only for Update/Delete)">
    <input type="text" name="name" placeholder="Item Name" required>
    <input type="text" name="description" placeholder="Description" required>
    <input type="number" name="price" placeholder="Price" required step="0.01">
    <input type="number" name="stock" placeholder="Stock Quantity" required>
    <select name="category" required>
        <option value="">Select Category</option>
        <%
            Connection catCon = null;
            PreparedStatement catPstmt = null;
            ResultSet catRs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                catCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                String catQuery = "SELECT category FROM category";
                catPstmt = catCon.prepareStatement(catQuery);
                catRs = catPstmt.executeQuery();
                while (catRs.next()) {
        %>
        <option value="<%= catRs.getString("category") %>"><%= catRs.getString("category") %></option>
        <%
                }
            } catch (Exception e) {
                out.println("<option>Error loading categories</option>");
            } finally {
                if (catRs != null) try { catRs.close(); } catch (Exception e) {}
                if (catPstmt != null) try { catPstmt.close(); } catch (Exception e) {}
                if (catCon != null) try { catCon.close(); } catch (Exception e) {}
            }
        %>
    </select>
    <input type="text" name="url" placeholder="Image Link" required>
    <button type="submit" name="action" value="add">Add Item</button>
    <button type="submit" name="action" value="update">Update Item</button>
    <button type="submit" name="action" value="delete" class="delete-btn">Delete Item</button>
</form>
    
    <h2>Add Category</h2>

<!-- Handle Form Submission -->
<%
   
    // Get user input
    String categoryName = request.getParameter("category");

    if (categoryName != null && !categoryName.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            // Insert Query
            String insertQuery = "INSERT INTO category (category) VALUES (?)";
            pstmt = con.prepareStatement(insertQuery);
            pstmt.setString(1, categoryName);

            int rowsInserted = pstmt.executeUpdate();
            message = (rowsInserted > 0) ? "Category added successfully!" : "Failed to add category.";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
    }
%>

<!-- Display Message -->
<% if (!message.isEmpty()) { %>
    <p style="color:<%= message.startsWith("Error") ? "red" : "green" %>;"><%= message %></p>
<% } %>

<!-- Category Form -->
<form method="post">
    <input type="text" name="category" placeholder="Enter Category Name" required>
    <button type="submit">Add Category</button>
</form>

<h3>All Items</h3>
<table id="itemTable">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Description</th>
        <th>Price</th>
        <th>Stock</th>
        <th>Category</th>
        <th>Image</th>
        <th>Action</th>
    </tr>
    <%
        Connection fetchCon = null;
        PreparedStatement fetchPstmt = null;
        ResultSet fetchRs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            fetchCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");

            // Fetch Items
            String selectQuery = "SELECT * FROM items";
            fetchPstmt = fetchCon.prepareStatement(selectQuery);
            fetchRs = fetchPstmt.executeQuery();

            while (fetchRs.next()) {
    %>
    <tr>
        <td><%= fetchRs.getInt("item_code") %></td>
        <td><%= fetchRs.getString("item_name") %></td>
        <td><%= fetchRs.getString("item_description") %></td>
        <td>$<%= fetchRs.getDouble("price") %></td>
        <td><%= fetchRs.getInt("stock") %></td>
        <td><%= fetchRs.getString("category") %></td>
        <td><img src="<%= fetchRs.getString("img_url") %>" width="50"></td>
        <td>
            <form method="post" style="display:inline;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= fetchRs.getInt("item_code") %>">
                <button type="submit" class="delete-btn">Delete</button>
            </form>
        </td>
    </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='8' style='color:red;text-align:center;'>Error: " + e.getMessage() + "</td></tr>");
        } finally {
            if (fetchRs != null) try { fetchRs.close(); } catch (Exception e) {}
            if (fetchPstmt != null) try { fetchPstmt.close(); } catch (Exception e) {}
            if (fetchCon != null) try { fetchCon.close(); } catch (Exception e) {}
        }
    %>
</table>

<script>
    function searchItems() {
        let input = document.getElementById("searchInput").value.toLowerCase();
        let rows = document.querySelectorAll("#itemTable tr:not(:first-child)");

        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            row.style.display = text.includes(input) ? "" : "none";
        });
    }
</script>

            </div>

    </div>
</body>
</html>