<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII" %>
<%@ page import="com.cs336.pkg.ApplicationDB, java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Customer Reservations</title>
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

    String transitLineName = request.getParameter("transitLineName");
    String reservationDate = request.getParameter("reservationDate");

    if (transitLineName != null && reservationDate != null
        && !transitLineName.trim().isEmpty()
        && !reservationDate.trim().isEmpty()) {

        try {
            ApplicationDB db   = new ApplicationDB();
            Connection  conn   = db.getConnection();
            String sql =
              "SELECT c.username, c.first_name, c.last_name, c.email "
            + "FROM Customers c "
            + "JOIN Reservations r ON c.username = r.customer_id "
            + "WHERE r.transit_line_name = ? "
            + "  AND r.reservation_date  = ? "
            + "ORDER BY c.last_name, c.first_name";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, transitLineName);
            ps.setDate(2, java.sql.Date.valueOf(reservationDate));
            ResultSet rs = ps.executeQuery();

            boolean found = false;
            while (rs.next()) {
                found = true;
%>
    <h2>
      <%= rs.getString("first_name") %>
      <%= rs.getString("last_name") %>
      (<%= rs.getString("username") %>)
    </h2>
    <p>Email: <%= rs.getString("email") %></p>
<%
            }
            if (!found) {
%>
    <p>No reservations found for line 
       <b><%= transitLineName %></b> on 
       <b><%= reservationDate %></b>.</p>
<%
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p>Error fetching reservations: " 
                        + e.getMessage() + "</p>");
        }
    } else {
%>
    <p>Please specify both a transit line and a date.</p>
<%
    }
%>

<form action="servicerepPortal.jsp" method="get">
    <input type="submit" value="Back to Portal">
</form>
</body>
</html>
