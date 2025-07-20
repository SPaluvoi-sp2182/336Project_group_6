<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII" %>
<%@ page import="com.cs336.pkg.ApplicationDB,java.sql.*,javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Schedules Through Station</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h2   { margin-top: 20px; }
    </style>
</head>
<body>
<%
    // auth check
    String username = (String) session.getAttribute("username");
    String role     = (String) session.getAttribute("role");
    if (username == null || !"employee".equals(role)) {
        response.sendRedirect("employeeLogin.jsp");
        return;
    }

    String stationIdStr = request.getParameter("stationId");
    if (stationIdStr != null && !stationIdStr.trim().isEmpty()) {
        try {
            int stationId = Integer.parseInt(stationIdStr);

            ApplicationDB db   = new ApplicationDB();
            Connection  conn   = db.getConnection();
            String sql =
              "SELECT DISTINCT ts.transit_line_name, ts.train_id,"
            + " orig.station_name AS origin, dest.station_name AS destination,"
            + " ts.departure_datetime, ts.arrival_datetime, ts.fixed_fare"
            + " FROM TrainSchedules ts"
            + " JOIN Stops_At sa ON ts.transit_line_name = sa.transit_line_name"
            + " JOIN Stations st ON sa.id = st.id"
            + " JOIN Stations orig ON ts.origin_station_id = orig.id"
            + " JOIN Stations dest ON ts.destination_station_id = dest.id"
            + " WHERE st.id = ?"
            + " ORDER BY ts.transit_line_name";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, stationId);
            ResultSet rs = pstmt.executeQuery();

            boolean found = false;
            while (rs.next()) {
                found = true;
%>
    <h2><%= rs.getString("transit_line_name") %></h2>
    <p>Train ID: <%= rs.getInt("train_id") %></p>
    <p>Origin: <%= rs.getString("origin") %></p>
    <p>Departure: <%= rs.getTimestamp("departure_datetime") %></p>
    <p>Destination: <%= rs.getString("destination") %></p>
    <p>Arrival: <%= rs.getTimestamp("arrival_datetime") %></p>
    <p>Fixed Fare: <%= rs.getBigDecimal("fixed_fare") %></p>
<%
            }
            if (!found) {
%>
    <p>No schedules found for station ID <b><%= stationId %></b>.</p>
<%
            }
            rs.close();
            pstmt.close();
            conn.close();
        }
        catch (NumberFormatException nfe) {
            out.println("<p>Invalid station ID format.</p>");
        }
        catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
    else {
%>
    <p>No station specified.</p>
<%
    }
%>

<form action="servicerepPortal.jsp" method="get">
    <input type="submit" value="Back to Portal">
</form>
</body>
</html>
