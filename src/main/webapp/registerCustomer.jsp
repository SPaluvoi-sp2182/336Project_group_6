<%@ page language="java" contentType="text/html;charset=ISO-8859-1"
         pageEncoding="ISO-8859-1"
         import="com.cs336.pkg.ApplicationDB,java.sql.*"
         session="true" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Register</title></head>
<body>
<%
  String msg = "";
  if("POST".equalsIgnoreCase(request.getMethod())) {
    String fn = request.getParameter("first_name"),
           ln = request.getParameter("last_name"),
           em = request.getParameter("email"),
           un = request.getParameter("username"),
           pw = request.getParameter("password");
    try {
      ApplicationDB db = new ApplicationDB();
      Connection con = db.getConnection();
      PreparedStatement ps = con.prepareStatement(
        "INSERT INTO Customers"
      + "(first_name,last_name,email,username,customer_password)"
      + " VALUES(?,?,?,?,?)"
      );
      ps.setString(1, fn);
      ps.setString(2, ln);
      ps.setString(3, em);
      ps.setString(4, un);
      ps.setString(5, pw);
      ps.executeUpdate();
      ps.close(); db.closeConnection(con);
      response.sendRedirect("login.jsp");
      return;
    } catch(Exception e) {
      msg = "Error or username taken";
    }
  }
%>
<h2>Register Customer</h2>
<form action="registerCustomer.jsp" method="post">
  <label>First Name</label><br>
  <input type="text" name="first_name" required><br>
  <label>Last Name</label><br>
  <input type="text" name="last_name" required><br>
  <label>Email</label><br>
  <input type="email" name="email" required><br>
  <label>Username</label><br>
  <input type="text" name="username" required><br>
  <label>Password</label><br>
  <input type="password" name="password" required><br>
  <input type="submit" value="Register">
</form>
<p style="color:red"><%= msg %></p>
</body>
</html>
