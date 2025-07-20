<%@ page language="java" contentType="text/html;charset=ISO-8859-1" 
    pageEncoding="ISO-8859-1"
    import="com.cs336.pkg.ApplicationDB, java.sql.*"
    session="true" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    String msg = "";
    String ssn = request.getParameter("ssn");
    String action = request.getParameter("action");

    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    if ("delete".equals(action)) {
        try {
            PreparedStatement ps = con.prepareStatement("DELETE FROM Employees WHERE ssn = ?");
            ps.setString(1, ssn);
            int deleted = ps.executeUpdate();
            msg = deleted > 0 ? "Rep deleted successfully." : "No rep found to delete.";
            ps.close();
        } catch (Exception e) {
            msg = "Error deleting: " + e.getMessage();
        }
    } else if ("update".equals(action)) {
        String repUsername = request.getParameter("repUsername");
        String password = request.getParameter("repPassword");

        try {
            PreparedStatement check = con.prepareStatement("SELECT * FROM Employees WHERE ssn = ?");
            check.setString(1, ssn);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                PreparedStatement update = con.prepareStatement(
                    "UPDATE Employees SET username=?, employee_password=? WHERE ssn=?"
                );
                update.setString(1, repUsername);
                update.setString(2, password);
                update.setString(3, ssn);
                update.executeUpdate();
                update.close();
                msg = "Rep updated.";
            } else {
                PreparedStatement insert = con.prepareStatement(
                    "INSERT INTO Employees (ssn, username, employee_password) VALUES (?, ?, ?)"
                );
                insert.setString(1, ssn);
                insert.setString(2, repUsername);
                insert.setString(3, password);
                insert.executeUpdate();
                insert.close();
                msg = "New rep created.";
            }

            rs.close();
            check.close();
        } catch (Exception e) {
            msg = "Error saving: " + e.getMessage();
        }
    }
    con.close();
%>

<html>
<head>
    <title>Manage Customer Reps</title>
</head>
<body>
    <h2>Manage Customer Representative</h2>

    <form method="post" action="manageServiceRep.jsp">
        SSN: <input type="text" name="ssn" required><br>
        Username: <input type="text" name="repUsername" required><br>
        Password: <input type="text" name="repPassword" required><br>
        <input type="hidden" name="action" value="update">
        <input type="submit" value="Add / Update Rep">
    </form>

    <form method="post" action="manageServiceRep.jsp">
        SSN to Delete: <input type="text" name="ssn" required><br>
        <input type="hidden" name="action" value="delete">
        <input type="submit" value="Delete Rep">
    </form>

    <p style="color:green;"><%= msg %></p>
    <form action="adminPortal.jsp" method="get">
        <input type="submit" value="Back to Admin Portal">
    </form>
</body>
</html>

