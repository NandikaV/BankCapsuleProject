<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bank Analyst</title>
    <link rel="stylesheet" href="styling.css">
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Bank Analyst</h1>
        <img src="banklogo.png" alt="Bank Logo">
    </div>
    <div class="form-container">
        <h2>Register</h2>
        <form method="POST" action="registration.jsp">
            <div class = "form-box">
            <label for="fullName">Full Name</label>
            <input type="text" name="fullName" id="fullName" placeholder="Enter your full name" required>

            <label for="email">Email</label>
            <input type="email" name="email" id="email" placeholder="Enter your email address" required>

            <label for="phone">Phone Number</label>
            <input type="tel" name="phone" id="phone" placeholder="Enter your phone number" required>

            <label for="dob">Date of Birth</label>
            <input type="date" name="dob" id="dob" required>

            <label for="idNo">ID Number</label>
            <input type="number" name="idNo" id="idNo" required>

            <label for="accountType">Account Type</label>
            <select name="accountType" id="accountType" required>
                <option value="savings">Savings</option>
                <option value="current">Current</option>
                <option value="fixed">Fixed Deposit</option>
            </select>

            <label for="Account_No">Account Number</label>
            <input type="number" name="Account_No" id="Account_No" required>

            <label for="username">User Name</label>
            <input type="text" name="username" id="username" placeholder="Create a username" required>

            <label for="password">Password</label>
            <input type="password" name="password" id="password" placeholder="Create a password" required>

            <label for="confirmPassword">Confirm Password</label>
            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm your password" required>

            <button type="submit">Register</button>
        </div>
        </form>

        <div class="register">
            <p>Already have an account? <a href="login.jsp">Login</a></p>
        </div>
    </div>
</div>

<%
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String dob = request.getParameter("dob");
    String accountNo = request.getParameter("Account_No");
    String accountType = request.getParameter("accountType");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String idNo = request.getParameter("idNo");

    boolean condition = true;
    String error = "";

    if (fullName != null && email != null && phone != null && dob != null && accountType != null && password != null && username != null && accountNo != null) {

        if (phone != null && phone.length() != 10) {
            condition = false;
            error = "Phone number must contain exactly 10 digits.";
        }

        if (condition && !password.matches("^(?=.*[a-zA-Z])(?=.*\\d).{8,}$")) {
            condition = false;
            error= "Password must contain at least one alphabet and one number, and the minimum length must be 8 characters.";
        }

        if (condition && !password.equals(confirmPassword)) {
            condition = false;
            error = "Passwords do not match.";
        }

        if (condition) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null; 

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BankAnalyst", "root", "Anita123@");
                String existingEmail = "SELECT * FROM Users WHERE Email=?";
                stmt = conn.prepareStatement(existingEmail);
                stmt.setString(1, email);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    condition = false;
                    error = "An account with this email ID already exists.";
                }

                if (condition) {
                    String sql = "INSERT INTO Users (UserID, Name, Email, MobileNo, DOB, accountType, IDNo, Password, AccountNumber) VALUES (?,?, ?, ?, ?, ?, ?, ?, ?)";
                    
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, username);
                    stmt.setString(2, fullName);
                    stmt.setString(3, email);
                    stmt.setString(4, phone);
                    stmt.setString(5, dob);
                    stmt.setString(6, accountType);
                    stmt.setString(7, idNo);
                    stmt.setString(8, password);
                    stmt.setInt(9, Integer.parseInt(accountNo));

                    int rowsInserted = stmt.executeUpdate();
                    if (rowsInserted > 0) {
                        out.println("<script>alert('Registration successful!'); window.location='login.jsp';</script>");
                    } else {
                        out.println("<script>alert('Registration failed! Please try again later.'); window.location='registration.jsp';</script>");
                    }
                } else {
                    out.println("<script>alert('" + error + "'); window.location='registration.jsp';</script>");
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            out.println("<script>alert('" + error + "'); window.location='registration.jsp';</script>");
        }
    }
%>

</body>
</html>
