<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.*,java.sql.*,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="US-ASCII">
  <title>Delete Reservation</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px }
  </style>
</head>
<body>
<%
  String user = (String) session.getAttribute("username");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  int reservationNumber = Integer.parseInt(request.getParameter("reservationNumber"));

  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();

  PreparedStatement ps = con.prepareStatement(
    "DELETE FROM Reservations WHERE reservation_number = ?"
  );
  ps.setInt(1, reservationNumber);
  int result = ps.executeUpdate();
  ps.close();
  con.close();
%>

<h2>
  <%= (result > 0)
        ? "Reservation #" + reservationNumber + " deleted successfully"
        : "Failed to delete reservation #" + reservationNumber %>
</h2>

<form action="customerPortal.jsp" method="get">
  <input type="submit" value="Back to Portal">
</form>
</body>
</html>
