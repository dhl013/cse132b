<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
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
	String student = request.getParameter("SSN");

	String query = "SELECT st.SSN, st.first_name, st.middle_name, st.last_name, se.section_id, se.class_title, " +
				   "se.course_number, se.discussion_mandatory, se.enrollment_limit, ce.units, si.faculty_name " +
				   "FROM Student st, Currently_Enrolled ce, Section se, Section_instructor si " +  
			       "WHERE st.PID = ce.PID AND " +  
			       "ce.section_id = se.section_id AND " +  
			       "ce.section_id = si.section_id AND " +  
				   "si.q_id = 'WI14' AND " +
				   "st.SSN = '" + student + "';";
	System.out.println(query);
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="report_main.jsp" id="banner-link">Reports</a>
			<a href="report_1a.jsp" id="banner-link">Back to Student List</a>			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>

			<tbody>
				<tr>
					<th>SSN</th>
					<th>First Name</th>
					<th>Middle Name</th>
					<th>Last Name</th>
					<th>Section ID</th>
					<th>Class Title</th>
					<th>Course Number</th>
					<th>Mandatory Discussion</th>
					<th>Enrollment Limit</th>
					<th>Units</th>
					<th>Instructor</th>
				</tr>
			</tbody>
			
			<tfoot>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="display_student" action="report_1a_result.jsp" method="post">
								<input type="hidden" value="display" name="action">
								<td><input value="<%= rs.getString("SSN") %>" name="SSN" size="10" disabled="disabled"></td>
								<td><input value="<%= rs.getString("first_name") %>" name="FIRSTNAME" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("middle_name") %>" name="MIDDLENAME" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("last_name") %>" name="LASTNAME" size="15" disabled="disabled"></td>
								<td><input value="<%= rs.getString("section_id") %>" name="SECTION" size="10" disabled="disabled"></td>
								<td><input value="<%= rs.getString("class_title") %>" name="CLASS" size="20" disabled="disabled"></td>
								<td><input value="<%= rs.getString("course_number") %>" name="COURSE" size="10" disabled="disabled"></td>
								<td><input value="<%= rs.getString("discussion_mandatory") %>" name="DIS_MAN" size="5" disabled="disabled"></td>
								<td><input value="<%= rs.getString("enrollment_limit") %>" name="ENR_LIM" size="5" disabled="disabled"></td>
								<td><input value="<%= rs.getString("units") %>" name="UNITS" size="1" disabled="disabled"></td>
								<td><input value="<%= rs.getString("faculty_name") %>" name="FACULTY" size="15" disabled="disabled"></td>
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