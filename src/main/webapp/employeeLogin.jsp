<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="com.cs336.pkg.*,java.sql.*,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login: Service Rep</title>
</head>
<body>
<%
  String msg = "";
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String u = request.getParameter("username"),
           p = request.getParameter("password");
    try {
      ApplicationDB db = new ApplicationDB();
      Connection con = db.getConnection();

      PreparedStatement ps = con.prepareStatement(
        "SELECT ssn FROM Employees WHERE username=? AND employee_password=?"
      );
      ps.setString(1, u);
      ps.setString(2, p);
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
        session.setAttribute("username", u);
        session.setAttribute("ssn", rs.getString("ssn"));
        session.setAttribute("role", "employee");
        response.sendRedirect("serviceRepView.jsp");
        return;
      }
      msg = "Invalid credentials";

      rs.close();
      ps.close();
      db.closeConnection(con);
    } catch (Exception ex) {
      out.print(ex);
      msg = "login failed";
    }
  }
%>

<h2>Login: Service Rep</h2>
<form action="serviceRepLogin.jsp" method="post">
  <label>Username:</label><br>
  <input type="text" name="username"><br>
  <label>Password:</label><br>
  <input type="password" name="password"><br>
  <input type="submit" value="Login">
</form>
<p style="color:red"><%= msg %></p>
</body>
</html>
