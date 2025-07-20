<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.*,java.sql.*,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="US-ASCII">
  <title>Select Trip Date</title>
  <style> body { font-family: Arial, sans-serif; margin: 20px } </style>
</head>
<body>
<%
  String username = (String) session.getAttribute("username");
  if (username == null) {
    response.sendRedirect("login.jsp"); return;
  }
%>
<h1>Make a Reservation</h1>
<form action="scheduleDetails.jsp" method="get">
  <label for="dateOfTravel">Select Travel Date:</label>
  <input type="date" id="dateOfTravel" name="dateOfTravel" required><br><br>

  <label for="line">Select Transit Line:</label>
  <select id="line" name="line" required>
  <%
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT DISTINCT transit_line_name FROM TrainSchedules ORDER BY transit_line_name");
    while(rs.next()) {
      String line = rs.getString("transit_line_name");
  %>
      <option value="<%= line %>"><%= line %></option>
  <%
    }
    rs.close(); stmt.close(); con.close();
  %>
  </select><br><br>

  <input type="submit" value="View Schedule">
</form>
</body>
</html>
