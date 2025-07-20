<%@ page language="java" contentType="text/html;charset=ISO-8859-1"
    import="com.cs336.pkg.ApplicationDB, java.sql.*"
    session="true" %>
<%
    String customerID = (String) session.getAttribute("username");
    if (customerID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String title = request.getParameter("title");
    String questionText = request.getParameter("questionText");

    String msg = "";
    if (title != null && questionText != null) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO QuestionsAndAnswers (CustomerID, Title, QuestionText) VALUES (?, ?, ?)"
            );
            ps.setString(1, customerID);
            ps.setString(2, title);
            ps.setString(3, questionText);
            ps.executeUpdate();
            ps.close(); con.close();
            msg = "Question posted!";
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
        }
    }
%>

<html><head><title>Post Question</title></head>
<body>
    <p><%= msg %></p>
    <form action="customerPortal.jsp" method="get">
        <input type="submit" value="Back to Customer Portal">
    </form>
</body>
</html>