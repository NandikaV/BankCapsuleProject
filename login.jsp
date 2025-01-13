<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Analyst Portal</title>
    <link rel="stylesheet" href="styling.css">
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Bank Analyst</h1>
        <img src="banklogo.png" alt="Bank Logo">
    </div>
    <div class="form-container">
        <h2>Login</h2>
        <form id ="loginForm" method="POST" action="login.jsp">
            <div class = "form-box">
            <label for="username">Username</label>
            <input type="text" name="username" id="username" placeholder="Enter your username" required>

            <label for="password">Password</label>
            <input type="password" name="password" id="password" placeholder="Enter your password" required>

            <button type="submit">Login</button>
        </div>
        </form>

        <div class="register">
            <p>New here? <a href="registration.jsp">Register</a></p>
        </div>
    </div>
</div>

<%
    // Processing login form data and database authentication
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BankAnalyst", "root","Anita123@");
            String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            rs = stmt.executeQuery();
            if (rs.next()) {
                // If user is found, redirect to dashboard or another page
                response.sendRedirect("dashboard.jsp");
            } else {
                out.println("<script>alert('Invalid credentials!');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<script src="script.js"></script>
</body>
</html>
