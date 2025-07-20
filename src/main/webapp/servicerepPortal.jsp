<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.ApplicationDB, java.sql.*, javax.servlet.http.*, javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Service Representative Portal</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h2 { margin-top: 30px; }
        form { margin-bottom: 20px; }
    </style>
</head>
<body>
<%
    String username = (String)session.getAttribute("username");
    String role     = (String)session.getAttribute("role");
    if (username==null || !"employee".equals(role)) {
        response.sendRedirect("employeeLogin.jsp");
        return;
    }
%>
<h1>Welcome, Service Rep <%= username %></h1>

<h2>Alter Train Schedules</h2>
<form action="manageTrains.jsp" method="get">
    <label for="transitLineName">Transit Line Name:</label><br>
    <input type="text" id="transitLineName" name="transitLineName" required><br><br>
    <input type="submit" value="Change Schedule">
</form>

<h2>Answer Unanswered Customer Questions</h2>
<%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        String sql = "SELECT QuestionID, Title, QuestionText FROM QuestionsAndAnswers "
                   + "WHERE AnswerText IS NULL LIMIT 3";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            int qid        = rs.getInt("QuestionID");
            String title   = rs.getString("Title");
            String qtext   = rs.getString("QuestionText");
%>
    <h3><%= title %></h3>
    <p><%= qtext %></p>
    <form action="answerQuestion.jsp" method="post">
        <input type="hidden" name="questionID" value="<%= qid %>">
        <input type="hidden" name="employeeID"  value="<%= username %>">
        <label for="answerText">Answer:</label><br>
        <textarea name="answerText" required></textarea><br>
        <input type="submit" value="Submit Answer">
    </form>
<%
        }
        rs.close(); ps.close(); con.close();
    } catch(Exception e) {
        out.println("<p>Error: "+e.getMessage()+"</p>");
    }
%>

<h2>Search Train Schedules Through a Station</h2>
<form action="searchByStation.jsp" method="get">
    <label for="stationId">Station ID:</label><br>
    <input type="text" id="stationId" name="stationId" required><br><br>
    <input type="submit" value="Search Schedules">
</form>

<h2>Search for Customer Reservations</h2>
<form action="customerReservations.jsp" method="get">
    <label for="transitLineName">Transit Line Name:</label><br>
    <input type="text" name="transitLineName" required><br>
    <label for="reservationDate">Date:</label><br>
    <input type="date" name="reservationDate" required><br><br>
    <input type="submit" value="Search Customers">
</form>

<form action="logout.jsp" method="post">
    <input type="submit" value="Logout">
</form>
</body>
</html>
