<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<script type="text/javascript" src="javascript/jquery-1.11.0.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Course Enrollment Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- COURSE ENROLLMENT INITALIZATION CODE -->
<%
	String course_select = "<select id=\"course_select\" name=\"COURSE\" form=\"insert_course_enrollment\" size=\"10\">";

	String query = "SELECT * FROM Course";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
	
	while( rs.next() ){
		course_select += "<option value=\"" + rs.getString("course_number") + "\">" + rs.getString("course_number") + "</option>";
	}
	course_select += "</select>";

%>
<body>

<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="class.jsp" id="banner-link">Class</a>
			<a href="course.jsp "id="banner-link">Course</a>
			<a href="faculty.jsp" id="banner-link">Faculty</a>
			<a href="student.jsp" id="banner-link">Student</a>
		</div>
	</div>
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>Student PID</th>
					<th>Course</th>
					<th>Section</th>
					<th>Units</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_course_enrollment" action="course_enrollment.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="PID"></td>
						<td><%= course_select %></td>
						<td></td>
						<td></td>
					</form>	
				</tr>
			</tbody>
		</table>
	</div>
	<script>
		$(document).ready(function() {
			$('#course_select').on('change', function(){
				$.ajax('Course_section?value=CSE100')
					.success(function(){
						console.log('here');
					});
			});		
		});
	</script>
	<%
		db.closeConnections();
	%>
</body>
</html>