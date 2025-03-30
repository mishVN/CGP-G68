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
                    background-color: #005f92;
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
                    background: #005f92;
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



                .mySlides {display: none;}

                 .container {
                    width: 80%;
                    margin: 80px auto;
                }

                /* Category buttons */
                .category-buttons {
                    margin-bottom: 20px;
                }

                .category-btn {
                    background-color: #043659;
                    color: white;
                    padding: 10px 20px;
                    margin: 5px;
                    border: none;
                    cursor: pointer;
                    border-radius: 5px;
                    font-size: 16px;
                    transition: all 0.3s ease-in-out;
                }

                .category-btn:hover {
                    background-color: #005f92;
                    transform: scale(1.1);
                }

                /* Item cards */
                .items-container {
                    display: flex;
                    flex-wrap: wrap;
                    justify-content: center;
                    gap: 15px;
                }
                .mySlides{
                    height: 300px;
                    width: 100%;
                    max-width: 100%;
                }

                .item-card {
                    background: white;
                    padding: 15px;
                    border-radius: 10px;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                    width: 250px;
                    text-align: center;
                    transition: transform 0.3s;
                }

                .item-card:hover {
                    transform: scale(1.05);
                }

                .item-card img {
                    width: 100%;
                    height: 150px;
                    object-fit: cover;
                    border-radius: 10px;
                }

                .item-card h3 {
                    margin: 10px 0;
                }

                .item-card p {
                    font-size: 14px;
                    color: #555;
                }

                @keyframes fadeIn {
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
                 .top-items-container {
                text-align: center;
                margin: 50px auto;
                width: 80%;
            }

            .top-items-grid {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 15px;
            }

            .top-item-card {
                width: 200px;
                background: white;
                padding: 15px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                text-align: center;
                opacity: 0;
                transform: scale(0.8);
                animation: fadeInScale 0.5s ease-in forwards;
            }

            .top-item-card img {
                width: 100%;
                height: 120px;
                object-fit: cover;
                border-radius: 10px;
            }

            .top-item-card h3 {
                margin: 10px 0 5px;
            }

            .top-item-card button {
                margin-top: 10px;
                padding: 8px 12px;
                background-color: #043659;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .top-item-card button:hover {
                background-color: #005f92;
            }


            .top-item-card p {
                color: #4CAF50;
                font-weight: bold;
            }
            .item-card button{
                 margin-top: 10px;
                padding: 8px 12px;
                background-color: #043659;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s;

            }
            .item-card button:hover{
                background-color: #005f92;
            }

            @keyframes fadeInScale {
                0% {
                    opacity: 0;
                    transform: scale(0.8);
                }
                100% {
                    opacity: 1;
                    transform: scale(1);
                }
            }
            /* Search Bar Container */
    .search-container {
        display: flex;
        align-items: center;
        margin-left: 20px; /* Adds spacing to separate it from the logo */
    }

    /* Input field */
    .search-container input {
        padding: 8px;
        font-size: 16px;
        border: 1px solid #ccc;
        border-radius: 5px;
        width: 200px;
        transition: width 0.3s ease-in-out;
    }

    /* Search button */
    .search-button {
        padding: 8px 12px;
        background-color: #043659;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s;
        margin-left: 5px;
    }

    .search-button:hover {
        background-color: #005f92;
    }

    /* Expanding search input on focus */
    .search-container input:focus {
        width: 300px;
        outline: none;
        border-color: #75ff7b;
    }


    /* Profile Settings Popup */
    .profile-popup {
        display: none; /* Initially hidden */
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }

    .popup-content {
        background: white;
        padding: 20px;
        border-radius: 8px;
        width: 300px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
    }

    .popup-content h2 {
        margin-bottom: 20px;
    }

    .popup-content ul {
        list-style: none;
        padding: 0;
    }

    .popup-content ul li {
        margin: 10px 0;
    }

    .popup-content ul li a {
        color: #4CAF50;
        text-decoration: none;
    }

    .popup-content ul li a:hover {
        text-decoration: underline;
    }

    .close-btn {
        font-size: 30px;
        color: #555;
        cursor: pointer;
        position: absolute;
        top: 10px;
        right: 10px;
    }
    .w3-button w3-black w3-display-left{
        color: white;
        background-color: #45a049;
        padding: 10px;
        border-radius: 10px;
    }
    .w3-button w3-black w3-display-left:hover{
        color:#ccc ;
        background-color: #d6e93a    }
            
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
            <a href="setting_seller.jsp">Settings</a>
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
                
                <a href="cart.jsp">View Cart</a>
                <a href="seller_item.jsp">Items management</a>
                <a href="game2.jsp">Game</a>
                <a href="setting_seller.jsp">Setting</a>
                <a href="login.jsp">Login</a>
                <a href="logout_user.jsp">Logout</a>
                

            </div>

    
            <br>
            <div class="itemscontent"><br><hr>

                <div class="w3-content w3-display-container">
            <%
                // Database connection details
                String DB_URL = "jdbc:mysql://localhost:3306/cgp";
                String DB_USER = "root"; // Change as per your DB
                String DB_PASS = "3323"; // Change if password is set

                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                    stmt = conn.createStatement();
                    String sql = "SELECT img_url FROM adds";
                    rs = stmt.executeQuery(sql);

                    while (rs.next()) {
                        String imgUrl = rs.getString("img_url");
            %>
                        <img class="mySlides" src="<%= imgUrl %>" >
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            %>

                <button class="w3-button w3-black w3-display-left" onclick="plusDivs(-1)">&#10094;</button>
                <button class="w3-button w3-black w3-display-left" onclick="plusDivs(1)">&#10095;</button>

               <hr> 

                <div class="top-items-container">
            <h2>Top  Items</h2>
            <div class="top-items-grid">
                <% 
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT * FROM top_items ORDER BY quantity DESC LIMIT 10");
                        int delay = 0;
                        while (rs.next()) {
                            int itemcode = rs.getInt("item_code");
                            String itemName = rs.getString("item_name");
                            String itemImage = rs.getString("img_url");

                %>
                            <div class="top-item-card" style="animation-delay: <%= delay %>ms;">
                                <img src="<%= itemImage %>" alt="<%= itemName %>">
                                <h3><%= itemName %></h3>
                                <button onclick="location.href='description_page.jsp?item=<%= itemcode %>'">Buy</button>
                            </div>
                <% 
                            delay += 200; // Stagger animation delay
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </div>


               <hr> 
                <div class="container">
            <h2>Select a Category</h2>

            <!-- Category Buttons -->
            <div class="category-buttons">
                <button class="category-btn" onclick="filterItems('all')">All</button>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT DISTINCT category FROM category");

                        while (rs.next()) {
                            String category = rs.getString("category");
                %>
                            <button class="category-btn" onclick="filterItems('<%= category %>')"><%= category %></button>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div><hr>

            <!-- Items Container -->
            <div class="items-container" id="itemsContainer">
                <%
                    conn = null;
                    stmt = null;
                    rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cgp", "root", "3323");
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT * FROM items");

                        while (rs.next()) {
                            int itemcode = rs.getInt("item_code");
                            String itemCategory = rs.getString("category");
                            String itemName = rs.getString("item_name");
                            String itemDescription = rs.getString("item_description");
                            String itemImage = rs.getString("img_url");
                %>
                            <div class="item-card" data-category="<%= itemCategory %>">
                                <img src="<%= itemImage %>" alt="<%= itemName %>">
                                <h3><%= itemName %></h3>
                                <p><%= itemDescription %></p>
                                 <button onclick="location.href='description_page.jsp?item=<%= itemcode %>'">Buy</button>
                            </div>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </div>

        <script>
            function filterItems(category) {
                let items = document.querySelectorAll('.item-card');

                items.forEach(item => {
                    if (category === 'all' || item.getAttribute('data-category') === category) {
                        item.style.display = "block";
                    } else {
                        item.style.display = "none";
                    }
                });
            }
        </script>



             </div>

            <script>
            var slideIndex = 1;
           showDivs(slideIndex);

            function plusDivs(n) {
            showDivs(slideIndex += n);
            }

        function showDivs(n) {
          var i;
          var x = document.getElementsByClassName("mySlides");
          if (n > x.length) {slideIndex = 1}
          if (n < 1) {slideIndex = x.length}
          for (i = 0; i < x.length; i++) {
            x[i].style.display = "none";  
          }
          x[slideIndex-1].style.display = "block";  
        }

        // Auto-slide every 3 seconds
        setInterval(function() { plusDivs(1); }, 3000);
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