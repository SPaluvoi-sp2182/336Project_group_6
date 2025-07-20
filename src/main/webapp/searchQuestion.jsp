<%@ page language="java" contentType="text/html;charset=ISO-8859-1"
    import="com.cs336.pkg.ApplicationDB, java.sql.*"
    session="true" %>
<%
    String keyword = request.getParameter("keyword");
%>

<html>
<head><title>Search Questions</title></head>
<body>
<h2>Search Results</h2>
<%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String query = "SELECT * FROM QuestionsAndAnswers WHERE AnswerText IS NOT NULL";
        if (keyword != null && !keyword.trim().isEmpty()) {
            query += " AND (Title LIKE ? OR QuestionText LIKE ?)";
        }

        PreparedStatement ps = con.prepareStatement(query);
        if (query.contains("?")) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
%>
    <h3><%= rs.getString("Title") %></h3>
    <p><%= rs.getString("QuestionText") %></p>
    <p><b>Answer:</b> <%= rs.getString("AnswerText") %></p>
    <hr>
<%
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<form action="customerPortal.jsp" method="get">
    <input type="submit" value="Back to Portal">
</form>
</body>
</html>
