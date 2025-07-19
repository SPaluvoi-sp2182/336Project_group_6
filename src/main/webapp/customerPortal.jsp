<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"
    import="com.cs336.pkg.*,java.sql.*,javax.servlet.http.*,javax.servlet.*"
    session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="US-ASCII">
    <title>Customer Portal</title>
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
    </style>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h1>Welcome, <%= username %></h1>

<h2>Search for Train Schedules</h2>
<form action="searchSchedule.jsp" method="post">
    Origin: <input type="text" name="origin"><br>
    Destination: <input type="text" name="destination"><br>
    Date of Travel: <input type="date" id="dateOfTravel" name="dateOfTravel" required><br>

    <script>
        var today = new Date().toISOString().split('T')[0];
        document.getElementById("dateOfTravel").setAttribute('min', today);
    </script>

    <p>Sort by:</p>
    <input type="radio" id="arrivalTime" name="sortCriteria" value="ArrivalTime">
    <label for="arrivalTime">Arrival Time</label><br>
    <input type="radio" id="departureTime" name="sortCriteria" value="DepartureTime">
    <label for="departureTime">Departure Time</label><br>
    <input type="radio" id="fare" name="sortCriteria" value="Fare">
    <label for="fare">Fare</label><br><br>

    <input type="submit" value="Search">
</form>

<h2>View Reservations</h2>
<form action="pastReservations.jsp" method="post">
    <input type="submit" value="See Past Reservations">
</form>

<form action="futureReservations.jsp" method="post">
    <input type="submit" value="See Upcoming Reservations">
</form>

<h2>Ask a Question</h2>
<form action="postQuestion.jsp" method="post">
    Title: <input type="text" name="title" maxlength="255" required><br>
    Question: <br>
    <textarea name="questionText" rows="4" cols="50" required></textarea><br><br>
    <input type="submit" value="Post Question">
</form>

<h2>Search Questions</h2>
<small>Leave blank to see all answers</small><br>
<form action="searchQuestions.jsp" method="get">
    <input type="text" name="keyword">
    <input type="submit" value="Search">
</form>

<form action="logout.jsp" method="post">
    <input type="submit" value="Logout">
</form>

</body>
</html>
