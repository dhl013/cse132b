<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="../css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Display the classes ever taken by a student</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>

<!-- DISPLAY CODE -->
<%


%>

<!-- Query Code -->
<%
	String student = request.getParameter("SSN");
	String query = "SELECT se.course_number, se.class_title, se.section_id, ct.units, ct.grade, ct.q_id " +
				   "FROM Student st, Course_taken ct, Section se " +
				   "WHERE st.PID = ct.PID AND " +
				         "ct.section_id = se.section_id AND " +
				         "st.SSN = " + student + " " +
				   "GROUP BY ct.q_id";
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="report_main.jsp" id="banner-link">Reports</a>
			<a href="report_1c.jsp" id="banner-link">Back to Student List</a>			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>

			<tbody>
				<tr>
					<th>Course</th>
					<th>Class</th>
					<th>Section</th>
					<th>Units</th>
					<th>Grade</th>
					<th>Quarter/Year</th>
				</tr>
			</tbody>
			
			<tfoot>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="display_class" action="report_1c_result.jsp" method="post">
								<input type="hidden" value="display" name="action">
								<td><input value="<%= rs.getString("course_number") %>" name="COURSE" size="10" disabled="disabled"></td>
								<td><input value="<%= rs.getString("class_title") %>" name="CLASS" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("section_id") %>" name="SECTION" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("units") %>" name="UNITS" size="1" disabled="disabled"></td>
								<td><input value="<%= rs.getString("grade") %>" name="GRADE" size="2" disabled="disabled"></td>
								<td><input value="<%= rs.getString("q_id") %>" name="Q_ID" size="4" disabled="disabled"></td>
							</form>
				<%
					}
				%>
			</tfoot>
		</table>
	</div>
	<%
		db.closeConnections();
	%>
</body>

</html>