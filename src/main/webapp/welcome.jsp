<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<%
    String user = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");  // "admin", "employee", or null (customer)
    if (user == null) {
        String loginPage = "login.jsp";
        if ("admin".equals(role)) {
            loginPage = "adminLogin.jsp";
        } else if ("employee".equals(role)) {
            loginPage = "employeeLogin.jsp";
        }
        response.sendRedirect(loginPage);
        return;
    }

    String portal = "customerPortal.jsp";
    if ("admin".equals(role)) {
        portal = "adminPortal.jsp";
    } else if ("employee".equals(role)) {
        portal = "servicerepPortal.jsp";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Welcome</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        form {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <p>Welcome <b><%= user %></b> (<%= role == null ? "customer" : role %>)</p>

    <form action="<%= portal %>" method="get">
        <input type="submit" value="Continue to Portal">
    </form>

    <form action="logout.jsp" method="post">
        <input type="submit" value="Logout">
    </form>
</body>
</html>
