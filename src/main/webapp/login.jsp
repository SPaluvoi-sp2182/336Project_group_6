<%@ page language="java"
    contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="com.cs336.pkg.ApplicationDB,java.sql.*,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login: Customers</title>
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
        "SELECT COUNT(*) FROM Customers "
      + "WHERE username=? AND customer_password=?"
      );
      ps.setString(1, u);
      ps.setString(2, p);
      ResultSet rs = ps.executeQuery();

      if (rs.next() && rs.getInt(1) == 1) {
        session.setAttribute("username", u);
        response.sendRedirect("welcome.jsp");
        return;
      }
      msg = "Invalid credentials";

      rs.close(); 
      ps.close(); 
      db.closeConnection(con);
    } catch (Exception ex) {
      out.print(ex);
      msg = "Login failed";
    }
  }
%>

<h2>Login: Customers</h2>
<form action="login.jsp" method="post">
  <label>Username:</label><br>
  <input type="text" name="username" required><br>
  <label>Password:</label><br>
  <input type="password" name="password" required><br>
  <input type="submit" value="Login">
  <input type="button" value="Register"
         onclick="window.location.href='registerCustomer.jsp';">
</form>
<p style="color:red;"><%= msg %></p>
</body>
</html>
