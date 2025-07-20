<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.ApplicationDB, java.sql.*, javax.servlet.http.*, javax.servlet.*"
    session="true" %>
<%
    String username = (String)session.getAttribute("username");
    String role = (String)session.getAttribute("role");
    if (username == null || !"employee".equals(role)) {
        response.sendRedirect("employeeLogin.jsp");
        return;
    }

    String lineName = request.getParameter("transitLineName");
    String action = request.getParameter("action");
    String msg = "";

    String trainId = "";
    String originId = "";
    String destId = "";
    String numStops = "";
    String depDT = "";
    String arrDT = "";
    String travelTime = "";
    String fixedFare = "";
    String farePerStop = "";
    String lineType = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        trainId = request.getParameter("trainId");
        originId = request.getParameter("originStationId");
        destId = request.getParameter("destinationStationId");
        numStops = request.getParameter("numStops");
        depDT = request.getParameter("departureDatetime");
        arrDT = request.getParameter("arrivalDatetime");
        travelTime = request.getParameter("travelTime");
        fixedFare = request.getParameter("fixedFare");
        farePerStop = request.getParameter("farePerStop");
        lineType = request.getParameter("lineType");

        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            if ("delete".equals(action)) {
                PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM TrainSchedules WHERE transit_line_name=?"
                );
                ps.setString(1, lineName);
                int result = ps.executeUpdate();
                msg = result > 0 ? "Deleted successfully" : "Delete failed";
                ps.close();
            } else {
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE TrainSchedules SET train_id=?, origin_station_id=?, destination_station_id=?, " +
                    "num_stops=?, departure_datetime=?, arrival_datetime=?, travel_time=?, " +
                    "fixed_fare=?, fare_per_stop=?, line_type=? WHERE transit_line_name=?"
                );
                ps.setInt(1, Integer.parseInt(trainId));
                ps.setInt(2, Integer.parseInt(originId));
                ps.setInt(3, Integer.parseInt(destId));
                ps.setInt(4, Integer.parseInt(numStops));
                ps.setTimestamp(5, Timestamp.valueOf(depDT));
                ps.setTimestamp(6, Timestamp.valueOf(arrDT));
                ps.setInt(7, Integer.parseInt(travelTime));
                ps.setFloat(8, Float.parseFloat(fixedFare));
                ps.setFloat(9, Float.parseFloat(farePerStop));
                ps.setString(10, lineType);
                ps.setString(11, lineName);
                int result = ps.executeUpdate();
                msg = result > 0 ? "Updated successfully" : "Update failed";
                ps.close();
            }
            con.close();
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
        }
    } else {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM TrainSchedules WHERE transit_line_name=?"
            );
            ps.setString(1, lineName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                trainId = String.valueOf(rs.getInt("train_id"));
                originId = String.valueOf(rs.getInt("origin_station_id"));
                destId = String.valueOf(rs.getInt("destination_station_id"));
                numStops = String.valueOf(rs.getInt("num_stops"));
                depDT = rs.getTimestamp("departure_datetime").toString();
                arrDT = rs.getTimestamp("arrival_datetime").toString();
                travelTime = String.valueOf(rs.getInt("travel_time"));
                fixedFare = String.valueOf(rs.getFloat("fixed_fare"));
                farePerStop = String.valueOf(rs.getFloat("fare_per_stop"));
                lineType = rs.getString("line_type");
            } else {
                msg = "No schedule found";
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Manage Train Schedule</title>
</head>
<body>
    <h2>Manage Schedule: <%= lineName %></h2>
    <% if (!msg.isEmpty()) { %>
        <p style="color:red;"><%= msg %></p>
    <% } %>
    <form action="manageTrains.jsp" method="post">
        <input type="hidden" name="transitLineName" value="<%= lineName %>"><br>
        Train ID:<br>
        <input type="text" name="trainId" value="<%= trainId %>" required><br>
        Origin Station ID:<br>
        <input type="text" name="originStationId" value="<%= originId %>" required><br>
        Destination Station ID:<br>
        <input type="text" name="destinationStationId" value="<%= destId %>" required><br>
        Number of Stops:<br>
        <input type="text" name="numStops" value="<%= numStops %>" required><br>
        Departure (YYYY-MM-DD HH:MM:SS):<br>
        <input type="text" name="departureDatetime" value="<%= depDT %>" required><br>
        Arrival (YYYY-MM-DD HH:MM:SS):<br>
        <input type="text" name="arrivalDatetime" value="<%= arrDT %>" required><br>
        Travel Time (min):<br>
        <input type="text" name="travelTime" value="<%= travelTime %>" required><br>
        Fixed Fare:<br>
        <input type="text" name="fixedFare" value="<%= fixedFare %>" required><br>
        Fare per Stop:<br>
        <input type="text" name="farePerStop" value="<%= farePerStop %>" required><br>
        Line Type:<br>
        <select name="lineType" required>
            <option value="ONE_WAY" <%= "ONE_WAY".equals(lineType) ? "selected" : "" %>>ONE_WAY</option>
            <option value="ROUND_TRIP" <%= "ROUND_TRIP".equals(lineType) ? "selected" : "" %>>ROUND_TRIP</option>
        </select><br><br>
        <button type="submit" name="action" value="update">Update</button>
        <button type="submit" name="action" value="delete">Delete</button>
    </form>
    <form action="servicerepPortal.jsp" method="get" style="margin-top:20px;">
        <input type="submit" value="Back to Home">
    </form>
</body>
</html>
