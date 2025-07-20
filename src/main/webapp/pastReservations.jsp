<%@ page language="java" contentType="text/html; charset=US-ASCII" 
    pageEncoding="US-ASCII" 
    import="com.cs336.pkg.*,java.sql.*,javax.servlet.http.*,javax.servlet.*" 
    session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="US-ASCII">
  <title>Past Reservations</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px }
    table { border-collapse: collapse; width: 100% }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left }
    th { background: #f4f4f4 }
  </style>
</head>
<body>
<%
  String user = (String) session.getAttribute("username");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();

  String sql =
    "SELECT r.reservation_number, r.reservation_date, r.discount_code, r.total_fare,"
  + " ts.line_type, s1.station_name AS origin, s2.station_name AS destination,"
  + " r.transit_line_name AS line_name, r.departure_datetime, r.arrival_datetime"
  + " FROM Reservations r"
  + " JOIN Stations s1 ON r.origin_station_id = s1.id"
  + " JOIN Stations s2 ON r.destination_station_id = s2.id"
  + " JOIN TrainSchedules ts ON r.transit_line_name = ts.transit_line_name"
  + " WHERE r.customer_id = ? AND r.reservation_date < CURDATE()"
  + " ORDER BY r.reservation_date DESC";

  PreparedStatement ps = con.prepareStatement(sql);
  ps.setString(1, user);
  ResultSet rs = ps.executeQuery();
%>

<h1>Past Reservations</h1>
<table>
  <tr>
    <th>#</th><th>Travel Date</th><th>Discount</th><th>Fare</th>
    <th>Type</th><th>Origin</th><th>Dest</th><th>Line</th>
    <th>Departs</th><th>Arrives</th>
  </tr>
<%
  while (rs.next()) {
%>
  <tr>
    <td><%= rs.getInt("reservation_number") %></td>
    <td><%= rs.getDate("reservation_date") %></td>
    <td><%= rs.getString("discount_code") %></td>
    <td>$<%= String.format("%.2f", rs.getBigDecimal("total_fare")) %></td>
    <td><%= rs.getString("line_type") %></td>
    <td><%= rs.getString("origin") %></td>
    <td><%= rs.getString("destination") %></td>
    <td><%= rs.getString("line_name") %></td>
    <td><%= rs.getTimestamp("departure_datetime") %></td>
    <td><%= rs.getTimestamp("arrival_datetime") %></td>
  </tr>
<%
  }
  rs.close();
  ps.close();
  con.close();
%>
</table>

<form action="customerPortal.jsp" method="get">
  <input type="submit" value="Back to Portal">
</form>
</body>
</html>
