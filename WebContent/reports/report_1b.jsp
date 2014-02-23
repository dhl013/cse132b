<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="../css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Display all classes</title>
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
	String query = "SELECT cl.class_title, cl.course_number, co.q_id " +
				   "FROM Class cl, Class_offered co " +
				   "WHERE cl.class_titler = co.class_title AND " +
				         "cl.course_number = co.course_number";
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="report_main.jsp" id="banner-link">Reports</a>			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<td>Enter the class title: </td>
					<form id="search_class" action="report_1b_result.jsp" method="post">
						<input type="hidden" value="search" name="action">
						<th><input value="" name="CLASS" size="10"></th>
						<th><input type="submit" value="Search"></th>
					</form>
				</tr>			
			</thead>
			
			<tbody>
				<tr>
					<th>Class</th>
					<th>Course</th>
					<th>Quarter/Year</th>
				</tr>
			</tbody>
			
			<tfoot>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="display_class" action="report_1b.jsp" method="post">
								<input type="hidden" value="display" name="action">
								<td><input value="<%= rs.getString("class_title") %>" name="CLASS" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("course_number") %>" name="COURSE" size="10" disabled="disabled"></td>
								<td><input value="<%= rs.getString("q_id") %>" name="Q_ID" size="5" disabled="disabled"></td>
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