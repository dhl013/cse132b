<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="../css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Display the classes currently taken by a student</title>
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
	String class_title = request.getParameter("CLASS");
	String query = "SELECT st.PID, st.first_name, st.middle_name, st.last_name, st.SSN, st.enrolled, st.residency, ce.units, ce.grade_option " +
				   "FROM Student st, Currently_Enrolled ce, Section se " +
				   "WHERE st.PID = ce.PID AND " +
				         "ce.section_id = se.section_id AND " +
				         "se.class_title = '" + class_title + "'"; 
				   		 
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="report_main.jsp" id="banner-link">Reports</a>
			<a href="report_1b.jsp" id="banner-link">Back to Class List</a>			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>

			<tbody>
				<tr>
					<th>PID</th>
					<th>First Name</th>
					<th>Middle Name</th>
					<th>Last Name</th>
					<th>SSN</th>
					<th>Currently Enrolled</th>
					<th>Residency</th>
					<th>Grade Option</th>
				</tr>
			</tbody>
			
			<tfoot>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="display_students" action="report_1b_result.jsp" method="post">
								<input type="hidden" value="display" name="action">
								<td><input value="<%= rs.getString("st.PID") %>" name="PID" size="10" disabled="disabled"></td>
								<td><input value="<%= rs.getString("st.first_name") %>" name="FIRSTNAME" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("st.middle_name") %>" name="MIDDLENAME" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("st.last_name") %>" name="LASTNAME" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("st.SSN") %>" name="SSN" size="10" disabled="disabled"></td>
								<td><input value="<%= rs.getString("st.enrolled") %>" name="ENROLLED" size="5" disabled="disabled"></td>
								<td><input value="<%= rs.getString("st.residency") %>" name="RESIDENCY" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("ce.units") %>" name="UNITS" size="5" disabled="disabled"></td>
								<td><input value="<%= rs.getString("ce.grade_option") %>" name="GRADE_OPTION" size="6" disabled="disabled"></td>
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