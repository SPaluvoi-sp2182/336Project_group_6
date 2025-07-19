<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<%
    String user = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");  // "admin", "employee" or null (customer)
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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Welcome</title>
</head>
<body>
    <p>Welcome <b><%= user %></b> (<%= role == null ? "customer" : role %>)</p>
    <a href="logout.jsp">Logout</a>
</body>
</html>
