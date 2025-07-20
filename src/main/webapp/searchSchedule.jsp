<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.*,java.sql.*,java.text.SimpleDateFormat,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Search Schedules</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px }
        table { border-collapse: collapse; width: 100% }
        th, td { border: 1px solid #555; padding: 8px }
    </style>
</head>
<body>
<%
    String origin       = request.getParameter("origin");
    String destination  = request.getParameter("destination");
    String dateOfTravel = request.getParameter("dateOfTravel");
    if (dateOfTravel != null) {
        session.setAttribute("dateOfTravel", dateOfTravel);
    }
    String sortCriteria = request.getParameter("sortCriteria");
    String orderBy = "ts.departure_datetime";
    if ("ArrivalTime".equals(sortCriteria)) {
        orderBy = "ts.arrival_datetime";
    } else if ("Fare".equals(sortCriteria)) {
        orderBy = "ts.fixed_fare";
    }
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String sql =
            "SELECT ts.train_id, " +
            "       s1.station_name AS Origin, " +
            "       ts.departure_datetime, " +
            "       s2.station_name AS Destination, " +
            "       ts.arrival_datetime, " +
            "       ts.num_stops AS Stops, " +
            "       ts.travel_time AS TravelTime, " +
            "       ts.fixed_fare AS Fare, " +
            "       ts.transit_line_name AS line " +
            "FROM TrainSchedules ts " +
            " JOIN Stations s1 ON ts.origin_station_id = s1.id " +
            " JOIN Stations s2 ON ts.destination_station_id = s2.id " +
            "WHERE s1.station_name LIKE ? " +
            "  AND s2.station_name LIKE ? " +
            "  AND DATE(ts.departure_datetime) = ? " +
            "ORDER BY " + orderBy;
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, "%" + origin + "%");
        ps.setString(2, "%" + destination + "%");
        ps.setString(3, dateOfTravel);
        ResultSet rs = ps.executeQuery();
%>
<h1>Available Trains</h1>
<table>
  <tr>
    <th>Train ID</th><th>Origin</th><th>Depart</th>
    <th>Destination</th><th>Arrive</th><th>Stops</th>
    <th>Travel Time</th><th>Fare</th><th>Details</th>
  </tr>
<%
    SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    while (rs.next()) {
%>
  <tr>
    <td><%= rs.getInt("train_id") %></td>
    <td><%= rs.getString("Origin") %></td>
    <td><%= fmt.format(rs.getTimestamp("departure_datetime")) %></td>
    <td><%= rs.getString("Destination") %></td>
    <td><%= fmt.format(rs.getTimestamp("arrival_datetime")) %></td>
    <td><%= rs.getInt("Stops") %></td>
    <td><%= rs.getInt("TravelTime") %> min</td>
    <td>$<%= rs.getFloat("Fare") %></td>
    <td>
      <a href="scheduleDetails.jsp?line=<%= rs.getString("line") %>">
        View
      </a>
    </td>
  </tr>
<%
    }
    rs.close();
    ps.close();
    con.close();
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
</table>
</body>
</html>
