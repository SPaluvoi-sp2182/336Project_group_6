<%@ page language="java" contentType="text/html;charset=ISO-8859-1"
    import="com.cs336.pkg.ApplicationDB, java.sql.*"
    session="true" %>
<%
    String employeeID = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (employeeID == null || !"employee".equals(role)) {
        response.sendRedirect("employeeLogin.jsp");
        return;
    }

    String questionID = request.getParameter("questionID");
    String answerText = request.getParameter("answerText");

    String msg = "";
    if (questionID != null && answerText != null) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE QuestionsAndAnswers SET AnswerText=?, EmployeeID=? WHERE QuestionID=?"
            );
            ps.setString(1, answerText);
            ps.setString(2, employeeID);
            ps.setInt(3, Integer.parseInt(questionID));
            ps.executeUpdate();
            ps.close(); con.close();
            msg = "Answer submitted.";
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
        }
    }
%>

<html><head><title>Answer Question</title></head>
<body>
    <p><%= msg %></p>
    <form action="servicerepPortal.jsp" method="get">
        <input type="submit" value="Back to Service Rep Portal">
    </form>
</body>
</html>