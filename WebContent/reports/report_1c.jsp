<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="../css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Display all students ever enrolled</title>
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
	String query = "SELECT SSN, first_name, middle_name, last_name FROM Student";
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
					<td>Enter the student's SSN: </td>
					<form id="search_student_class" action="report_1c_result.jsp" method="post">
						<input type="hidden" value="search" name="action">
						<th><input value="" name="SSN" size="10"></th>
						<th><input type="submit" value="Search"></th>
					</form>
				</tr>			
			</thead>
			
			<tbody>
				<tr>
					<th>SSN</th>
					<th>First Name</th>
					<th>Middle Name</th>
					<th>Last Name</th>
				</tr>
			</tbody>
			
			<tfoot>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="display_student" action="report_1c.jsp" method="post">
								<input type="hidden" value="display" name="action">
								<td><input value="<%= rs.getString("SSN") %>" name="SSN" size="10" disabled="disabled"></td>
								<td><input value="<%= rs.getString("first_name") %>" name="FIRSTNAME" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("middle_name") %>" name="MIDDLENAME" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("last_name") %>" name="LASTNAME" size="15" disabled="disabled"></td>
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