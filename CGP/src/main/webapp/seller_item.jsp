        <%@page import="java.sql.DriverManager"%>
        <%@page import="java.sql.ResultSet"%>
        <%@page import="java.sql.Statement"%>
        <%@page import="java.sql.Connection"%>
        <%@page import="java.sql.*"%>
        <%@ page contentType="text/html; charset=UTF-8" language="java" %>

        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Home</title>
            <style>
                /* Reset default margins and paddings */
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f4f4f4;
                }

                /* Navigation bar styles */
                .navbar {
                    background-color: #043659;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    position: fixed;
                    top: 0;
                    width: 100%;
                    z-index: 1000;
                    padding: 10px 20px;
                }

                /* Navigation links container */
                .nav-links {
                    display: flex;
                    justify-content: center;
                    flex-grow: 1;
                }

                .nav-links a {
                    color: white;
                    text-decoration: none;
                    padding: 14px 30px;
                    font-size: 18px;
                    transition: 0.3s;
                    
                }

                .nav-links a:hover {
                    background-color: #0072ff;
                    border-radius: 15px;
                }

                /* Sidebar Popup */
                .sidebar {
                    width: 200px;
                    height: 100vh;
                    background: #043659;
                    padding: 20px;
                    padding-top: 60px;
                    position: fixed;
                    left: -220px;
                    top: 0;
                    transition: 0.3s;
                    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.3);
                }

                .sidebar.show {
                    
                    left: 0;
                    
                }

                .sidebar a {
                    display: block;
                    text-decoration: none;
                    color: white;
                    background: #0072ff;
                    padding: 15px;
                    margin: 10px 0;
                    text-align: center;
                    border-radius: 5px;
                    font-size: 18px;
                    margin-top: 20px;
                }

                .sidebar a:hover {
                    background: #043659;
                }

                
                /* Image Button */
                .image-button {
                    background: none;
                    border: none;
                    padding: 0;
                    cursor: pointer;
                }

                .image-button img {
                    width: 40px;
                    height: auto;
                    border-radius: 10px;
                    transition: transform 0.2s ease-in-out;
                }

                .image-button img:hover {
                    transform: scale(1.1);
                }


                .itemscontent {
                width: 80%;
                margin: 80px auto 20px auto; /* Centers content and adds space below navbar */
                text-align: center;
                }

                /* Logo Button */
                .logo-button {
                    background: none;
                    border: none;
                    cursor: pointer;
                    transition: transform 0.3s ease-in-out;
                }

                .logo-button img {
                    width: 60px;
                    height: 40px;
                    border-radius: 30px;
                    object-fit: cover;
                    transition: all 0.3s ease-in-out;
                }

                .logo-button:hover img {
                    border-radius: 50px; /* Makes it oval on hover */
                    transform: scale(1.1);
                }

                /* Footer */
                .footer {

                    width: 100%;
                    background-color: #043659;
                    color: white;
                    text-align: center;
                    padding: 10px 0;
                    font-size: 14px;
                }

                .footer a {
                    color: white;
                    text-decoration: none;
                }

                .footer a:hover {
                    text-decoration: underline;
                }



                 .container {
                    width: 80%;
                    margin: 80px auto;
                    padding: 10px;
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

            <!-- Navigation Bar -->
            <div class="navbar">
        <!-- Sidebar Toggle Button -->
        <button class="image-button" onclick="toggleSidebar()">
            <img src="2.png" alt="Click Me">
        </button>

        <!-- Navigation Links (Centered) -->
        <div class="nav-links">
            <a href="homesaller.jsp">Home</a>
            <a href="seller_item.jsp">Items management</a>
            <a href="our_services.jsp">Services</a>
            <a href="login.jsp">Login</a>
        </div>

        <!-- Search Bar -->
        <div class="search-container">
            <input type="text" id="searchInput" placeholder="Search...">
            <button class="search-button" onclick="performSearch()"></button>
        </div>
       
    </div>


            <!-- Sidebar Popup -->
            <div class="sidebar" id="sidebar">
                
                <a href="our_services.jsp">Services</a>
                <a href="seller_item.jsp">Items management</a>
                <a href="game2.jsp">Game</a>
                <a href="login.jsp">Login</a>
                <a href="login.jsp">Logout</a>
                <a href="cart.jsp">View Cart</a>
                

            </div>

    
            <br>
            
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


            <!-- Footer -->
            <div class="footer">
                <p>Courier Service Name</p>
                <p>23/A, Jaya Mawatha, Rathnapura</p>
                <p><a href="mailto:curierservice@gmail.com">curierservice@gmail.com</a></p>
                <p><a href="tel:0761214345">0761214345</a></p>
            </div>

  

            <script>
                function toggleSidebar() {
                    var sidebar = document.getElementById("sidebar");
                    sidebar.classList.toggle("show");
                }

                // Close sidebar when clicking outside
                document.addEventListener("click", function(event) {
                    var sidebar = document.getElementById("sidebar");
                    var button = document.querySelector(".image-button");

                    if (!sidebar.contains(event.target) && !button.contains(event.target) && sidebar.classList.contains("show")) {
                        sidebar.classList.remove("show");
                    }
                });

            </script>
            
        </body>
        </html>