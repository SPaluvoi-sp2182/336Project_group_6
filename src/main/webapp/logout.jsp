<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Logout</title>
    <meta charset="US-ASCII">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
    </style>
</head>
<body>
<%
    // invalidate any existing session
    session.invalidate();
    // send user back to the main menu
    response.sendRedirect("mainMenu.jsp");
%>
</body>
</html>
