<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.*,java.sql.*,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Service Representative Portal</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }
        h2 {
            margin-top: 30px;
        }
        form {
            margin-bottom: 20px;
        }
        textarea {
            width: 100%;
            height: 80px;
        }
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null || !"employee".equals(session.getAttribute("role"))) {
        response.sendRedirect("employeeLogin.jsp");
        return;
    }
%>

<h1>Welcome, Service Rep <%= username %></h1>

<h2>Alter Train Schedules</h2>
<p>Edit or delete schedule info.</p>
<form action="manageTrains.jsp" method="post">
    <label for="uid">Transit Line Name:</label><br>
    <input type="text" id="uid" name="uid" required><br><br>
    <input type="submit" value="Change Schedule">
</form>

<h2>Answer Unanswered Customer Questions</h2>
<%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String query = "SELECT * FROM QuestionsAndAnswers WHERE AnswerText IS NULL LIMIT 3";
        PreparedStatement stmt = con.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int questionID = rs.getInt("QuestionID");
            String title = rs.getString("Title");
            String questionText = rs.getString("QuestionText");
%>
    <h3><%= title %></h3>
    <p><%= questionText %></p>
    <form action="answerQuestion.jsp" method="post">
        <input type="hidden" name="questionID" value="<%= questionID %>">
        <input type="hidden" name="username" value="<%= username %>">
        <label for="answerText">Answer:</label><br>
        <textarea name="answerText" required></textarea><br>
        <input type="submit" value="Submit Answer">
    </form>
<%
        }

        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("<p>Error retrieving questions: " + e.getMessage() + "</p>");
    }
%>

<h2>Search Train Schedules Through a Station</h2>
<form action="throughSchedules.jsp" method="get">
    <label for="stationName">Station Name:</label><br>
    <input type="text" name="stationName" required><br><br>
    <input type="submit" value="Search Schedules">
</form>

<h2>Search for Customer Reservations</h2>
<p>Find customers on a specific line and date.</p>
<form action="customerReservations.jsp" method="get">
    <label for="transitLineName">Transit Line Name:</label><br>
    <input type="text" name="transitLineName" required><br>
    <label for="date">Date:</label><br>
    <input type="date" name="date" required><br><br>
    <input type="submit" value="Search Customers">
</form>

<form action="logout.jsp" method="post">
    <input type="submit" value="Logout">
</form>
</body>
</html>
