<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.*,java.sql.*,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Admin Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        h1, h2 {
            margin-top: 30px;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
        }
        th, td {
            border: 1px solid #555;
            padding: 8px;
            text-align: left;
        }
        form {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>

<h1>Welcome, Admin <%= username %></h1>

<h2>Manage Customer Rep Accounts</h2>
<form action="manageServiceRep.jsp" method="post">
    <label for="ssn">SSN:</label><br>
    <input type="text" id="ssn" name="ssn" required><br><br>
    <input type="submit" value="Edit or Create Account">
</form>

<%
    try {
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();

        // Total revenue from last month
        String query = "SELECT SUM(total_fare) AS totalFare FROM Reservations " +
                       "WHERE YEAR(reservation_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) " +
                       "AND MONTH(reservation_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)";
        PreparedStatement stmt = con.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            out.println("<h2>Last Month's Revenue: $" + rs.getDouble("totalFare") + "</h2>");
        }

        // Reservations by line
        query = "SELECT r.reservation_number, r.reservation_date, r.departure_datetime, r.arrival_datetime, " +
                "r.total_fare, c.first_name, c.last_name, s1.station_name AS origin, s2.station_name AS destination, " +
                "r.transit_line_name FROM Reservations r " +
                "JOIN Customers c ON r.customer_id = c.username " +
                "JOIN Stations s1 ON r.origin_station_id = s1.id " +
                "JOIN Stations s2 ON r.destination_station_id = s2.id " +
                "ORDER BY r.transit_line_name, r.reservation_date";
        stmt = con.prepareStatement(query);
        rs = stmt.executeQuery();
%>

<h2>Reservations by Transit Line</h2>
<table>
<tr><th>Res #</th><th>Date</th><th>Passenger</th><th>Fare</th><th>Origin</th><th>Destination</th><th>Line</th><th>Depart</th><th>Arrive</th></tr>
<%
        while (rs.next()) {
%>
<tr>
<td><%= rs.getInt("reservation_number") %></td>
<td><%= rs.getDate("reservation_date") %></td>
<td><%= rs.getString("first_name") + " " + rs.getString("last_name") %></td>
<td>$<%= rs.getDouble("total_fare") %></td>
<td><%= rs.getString("origin") %></td>
<td><%= rs.getString("destination") %></td>
<td><%= rs.getString("transit_line_name") %></td>
<td><%= rs.getTimestamp("departure_datetime") %></td>
<td><%= rs.getTimestamp("arrival_datetime") %></td>
</tr>
<%
        }
%>
</table>

<%
        // Revenue by line
        query = "SELECT transit_line_name, SUM(total_fare) AS totalFare FROM Reservations GROUP BY transit_line_name";
        stmt = con.prepareStatement(query);
        rs = stmt.executeQuery();
%>

<h2>Revenue by Transit Line</h2>
<table>
<tr><th>Transit Line</th><th>Total Revenue</th></tr>
<%
        while (rs.next()) {
%>
<tr>
<td><%= rs.getString("transit_line_name") %></td>
<td>$<%= rs.getDouble("totalFare") %></td>
</tr>
<%
        }

        // Top spending customer
        query = "SELECT c.first_name, c.last_name, SUM(r.total_fare) AS totalFare " +
                "FROM Reservations r JOIN Customers c ON r.customer_id = c.username " +
                "GROUP BY c.username ORDER BY totalFare DESC LIMIT 1";
        stmt = con.prepareStatement(query);
        rs = stmt.executeQuery();
        if (rs.next()) {
%>
<h2>Top Customer</h2>
<p><b><%= rs.getString("first_name") + " " + rs.getString("last_name") %></b> with $<%= rs.getDouble("totalFare") %> in total fares</p>
<%
        }

        // Most popular lines
        query = "SELECT transit_line_name, COUNT(*) AS count FROM Reservations GROUP BY transit_line_name ORDER BY count DESC LIMIT 5";
        stmt = con.prepareStatement(query);
        rs = stmt.executeQuery();
%>

<h2>Top 5 Transit Lines by Usage</h2>
<table>
<tr><th>Line</th><th>Reservations</th></tr>
<%
        while (rs.next()) {
%>
<tr>
<td><%= rs.getString("transit_line_name") %></td>
<td><%= rs.getInt("count") %></td>
</tr>
<%
        }

        con.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>

<form action="logout.jsp" method="post">
    <input type="submit" value="Logout">
</form>

</body>
</html>
