<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="US-ASCII">
    <title>Main Menu</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        h1 {
            margin-bottom: 30px;
        }
        form {
            margin: 10px;
        }
        button {
            padding: 10px 20px;
            font-size: 16px;
            width: 200px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Train Booking System</h1>
    <form action="login.jsp" method="get">
        <button type="submit">Customer Login</button>
    </form>
    <form action="employeeLogin.jsp" method="get">
        <button type="submit">Customer Rep Login</button>
    </form>
    <form action="adminLogin.jsp" method="get">
        <button type="submit">Admin Login</button>
    </form>
</body>
</html>
