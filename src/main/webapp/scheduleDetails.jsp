<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.*,java.sql.*,java.text.SimpleDateFormat,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="US-ASCII">
  <title>Schedule Details</title>
</head>
<body>
<%
  String line = request.getParameter("line");
  if (line == null) {
    response.sendRedirect("customerPortal.jsp");
    return;
  }

  ApplicationDB db = new ApplicationDB();
  Connection con = db.getConnection();

  PreparedStatement ps = con.prepareStatement(
    "SELECT fixed_fare, num_stops, s1.station_name AS origin, departure_datetime, " +
    "s2.station_name AS dest, arrival_datetime FROM TrainSchedules ts " +
    "JOIN Stations s1 ON ts.origin_station_id = s1.id " +
    "JOIN Stations s2 ON ts.destination_station_id = s2.id " +
    "WHERE ts.transit_line_name = ?"
  );
  ps.setString(1, line);
  ResultSet rs = ps.executeQuery();
  rs.next();
  float fixedFare = rs.getFloat("fixed_fare");
  int numStops = rs.getInt("num_stops");
  float farePerStop = fixedFare / (numStops == 0 ? 1 : numStops);
  String origin = rs.getString("origin");
  String dest = rs.getString("dest");
  java.sql.Timestamp dep = rs.getTimestamp("departure_datetime");
  java.sql.Timestamp arr = rs.getTimestamp("arrival_datetime");
  rs.close();
  ps.close();

  PreparedStatement ps2 = con.prepareStatement(
    "SELECT sa.id, st.station_name, sa.departure_datetime, sa.arrival_datetime " +
    "FROM Stops_At sa JOIN Stations st ON sa.id = st.id " +
    "WHERE sa.transit_line_name = ? ORDER BY sa.arrival_datetime"
  );
  ps2.setString(1, line);
  rs = ps2.executeQuery();
  SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<h1>Schedule: <%= line %></h1>
<p>Fare: $<%= String.format("%.2f", fixedFare) %> total or $<%= String.format("%.2f", farePerStop) %>/stop</p>

<form action="createReservation.jsp" method="post" onsubmit="return validateForm()">
  <table border="1">
    <tr><th>Select</th><th>Station</th><th>Departure</th><th>Arrival</th></tr>
    <% while (rs.next()) { 
         String id = rs.getString("id");
         String name = rs.getString("station_name");
         String dTime = fmt.format(rs.getTimestamp("departure_datetime"));
         String aTime = fmt.format(rs.getTimestamp("arrival_datetime"));
    %>
      <tr>
        <td><input type="checkbox" name="stops" value="<%= id %>" onclick="limitCheckboxes(this)"></td>
        <td><%= name %></td>
        <td><%= dTime %></td>
        <td><%= aTime %></td>
      </tr>
    <% } %>
  </table>

  <p>Select Discount:</p>
  <select name="discountCode">
    <option value="NONE">None</option>
    <option value="CHILD">Child (25%)</option>
    <option value="SENIOR">Senior (35%)</option>
    <option value="DISABLED">Disabled (50%)</option>
  </select>

  <input type="hidden" name="transitLineName" value="<%= line %>">
  <input type="hidden" name="fixedFare" value="<%= fixedFare %>">
  <input type="hidden" name="farePerStop" value="<%= farePerStop %>">
  <input type="hidden" name="numStops" value="<%= numStops %>">
  <input type="hidden" id="topStopId" name="topStopId">
  <input type="hidden" id="topDepartureTime" name="topDepartureTime">
  <input type="hidden" id="bottomStopId" name="bottomStopId">
  <input type="hidden" id="bottomArrivalTime" name="bottomArrivalTime">
  <br><br>
  <input type="checkbox" name="roundTrip"> Round Trip<br><br>
  <input type="submit" value="Calculate & Reserve">
</form>
<%
  con.close();
%>
<script>
function limitCheckboxes(box) {
  const boxes = document.querySelectorAll('input[name="stops"]');
  const selected = Array.from(boxes).filter(cb => cb.checked);
  if (selected.length > 2) box.checked = false;
  if (selected.length === 2) {
    document.getElementById("topStopId").value = selected[0].value;
    document.getElementById("bottomStopId").value = selected[1].value;
    // hardcoded departure/arrival times for demonstration; use data attributes in real version
    document.getElementById("topDepartureTime").value = "2025-07-20 08:00:00";
    document.getElementById("bottomArrivalTime").value = "2025-07-20 09:30:00";
  }
}
function validateForm() {
  const stops = document.querySelectorAll('input[name="stops"]:checked');
  if (stops.length !== 2) {
    alert("Please select exactly two stops.");
    return false;
  }
  return true;
}
</script>
</body>
</html>
