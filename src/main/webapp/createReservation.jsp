<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.*,java.sql.*,javax.servlet.http.*,javax.servlet.*,java.util.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="US-ASCII">
  <title>Create Reservation</title>
  <style> body { font-family: Arial, sans-serif; margin: 20px } </style>
</head>
<body>
<%
  String username = (String) session.getAttribute("username");
  if (username == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  String line        = request.getParameter("transitLineName");
  float fixedFare    = Float.parseFloat(request.getParameter("fixedFare"));
  float perStop      = Float.parseFloat(request.getParameter("farePerStop"));
  String[] stops     = request.getParameterValues("stops");
  boolean roundTrip  = request.getParameter("roundTrip") != null;
  String discount    = request.getParameter("discountCode");

  // Determine discount multiplier
  float discountRate = 0f;
  if ("CHILD".equals(discount))    discountRate = 0.25f;
  else if ("SENIOR".equals(discount)) discountRate = 0.35f;
  else if ("DISABLED".equals(discount)) discountRate = 0.50f;

  int stopsBetween = (stops.length > 1)
    ? Math.abs(Integer.parseInt(stops[1]) - Integer.parseInt(stops[0]))
    : 0;
  float totalFare = perStop * stopsBetween;
  if (roundTrip) totalFare *= 2;
  totalFare *= (1.0f - discountRate);

  // Fetch reservation data
  String topId   = request.getParameter("topStopId");
  String botId   = request.getParameter("bottomStopId");
  String topDep  = request.getParameter("topDepartureTime");
  String botArr  = request.getParameter("bottomArrivalTime");
  String tripDate= (String) session.getAttribute("dateOfTravel");
  java.sql.Date madeDate = new java.sql.Date(new java.util.Date().getTime());

  // Insert reservation
  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();

  PreparedStatement rn = con.prepareStatement(
    "SELECT COALESCE(MAX(reservation_number),0)+1 AS nxt FROM Reservations"
  );
  ResultSet rs = rn.executeQuery(); 
  rs.next();
  int resNum = rs.getInt("nxt");
  rs.close(); 
  rn.close();

  PreparedStatement ps = con.prepareStatement(
    "INSERT INTO Reservations ("
  + "reservation_number,customer_id,origin_station_id,destination_station_id,"
  + "transit_line_name,departure_datetime,arrival_datetime,reservation_date,"
  + "discount_code,total_fare"
  + ") VALUES (?,?,?,?,?,?,?,?,?,?)"
  );
  ps.setInt   (1, resNum);
  ps.setString(2, username);
  ps.setInt   (3, Integer.parseInt(topId));
  ps.setInt   (4, Integer.parseInt(botId));
  ps.setString(5, line);
  ps.setString(6, topDep);
  ps.setString(7, botArr);
  ps.setDate  (8, java.sql.Date.valueOf(tripDate));
  ps.setString(9, discount);
  ps.setBigDecimal(10, new java.math.BigDecimal(String.format("%.2f", totalFare)));

  int cnt = ps.executeUpdate();
  ps.close();
  con.close();
%>

<% if (cnt > 0) { %>
  <h2>Reservation Created!</h2>
  <p>Reservation Number: <b><%= resNum %></b></p>
  <p>Total Fare: $<%= String.format("%.2f", totalFare) %></p>
<% } else { %>
  <h2>Failed to create reservation.</h2>
<% } %>

<form action="customerPortal.jsp" method="get">
  <input type="submit" value="Back to Portal">
</form>
</body>
</html>
