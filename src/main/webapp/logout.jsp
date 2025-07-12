<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="javax.servlet.http.*,javax.servlet.*" session="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
</head>
<body>
<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>
</body>
</html>
