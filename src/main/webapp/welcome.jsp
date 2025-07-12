<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="javax.servlet.http.*,javax.servlet.*" session="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
</head>
<body>
<%
    String user = (String) session.getAttribute("username");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<p>You have logged in as <b><%= user %></b></p>
<a href="logout.jsp">Logout</a>
</body>
</html>
