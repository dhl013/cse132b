<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<script type="text/javascript" src="javascript/jquery-1.11.0.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Past Classes Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- PAST CLASSES INSERT CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String past_class_insert = "INSERT INTO Course_taken VALUES (?,?,?,?,?,?)";
		
		String class_title_query = "SELECT class_title FROM Class c WHERE c.course_number ='" + request.getParameter("COURSE") + "'";
		System.out.println(class_title_query);
		db.executeQuery(class_title_query);
		ResultSet tmprs = db.getResultSet();
		tmprs.next();
		
		pstmt = db.getPreparedStatment(past_class_insert);
		pstmt.setString(1, request.getParameter("PID"));
		pstmt.setString(2, request.getParameter("COURSE"));
		pstmt.setString(3, tmprs.getString("class_title"));
		pstmt.setString(4, request.getParameter("SECTION_ID"));
		pstmt.setString(5, request.getParameter("GRADE"));
		pstmt.setString(6, request.getParameter("Q_ID"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed past_classes Insert PreparedStatement with a success of : " + success);
	}
%>
<!-- PAST CLASSES INITALIZATION CODE -->
<%
	String course_select = "<select id=\"course_select\" name=\"COURSE\" form=\"insert_past_classes\" size=\"10\">";

	String query = "SELECT * FROM Course";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
	
	while( rs.next() ){
		course_select += "<option value=\"" + rs.getString("course_number") + "\">" + rs.getString("course_number") + "</option>";
	}
	course_select += "</select>";
	
	query = "SELECT * FROM Course_taken";
	db.executeQuery(query);
	rs = db.getResultSet();
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
					<th>Quarter</th>
					<th>Grade</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_past_classes" action="past_classes.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="PID" size="15"></td>
						<td><%= course_select %></td>
						<td><select id="section_select" name="SECTION_ID" form="insert_past_classes" size="10" style="width:200px">
							</select></td>
						<td><select id="quarter_select" name="QUARTER" form="insert_past_classes" size="10" style="width:100px;pointer-events: none; cursor: default;">
							</select></td>
							<input id="quarter_id" type="hidden" value="" name="Q_ID">
						<td><input value="" name="GRADE" size="2"></td>
						<td><input type="submit" value="Insert"></td>
					</form>	
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_past_classes" action="past_classes.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("PID") %>" size="15"></td>
							<td><input value="<%= rs.getString("course_number") %>" size="10"></td>
							<input value="<%= rs.getString("class_title") %>" type="hidden" name="CLASS">
							<td><input value="<%= rs.getString("section_id") %>" size="25"></td>
							<td><input value="<%= rs.getString("q_id") %>" size="10"></td>
							<td><input value="<%= rs.getString("grade") %>" size="2"></td>
							<td><input type="submit" value="Update" disabled="disabled"></td>
						</form>
						<form id="delete_past_classes" action="past_classes.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
							<input type="hidden" value="<%= rs.getString("course_number") %>" name="COURSE" >
							<input type="hidden" value="<%= rs.getString("section_id") %>" name="SECTION_ID" >
							<input value="<%= rs.getString("class_title") %>" type="hidden" name="CLASS">
							<td><input type="submit" value="Delete" disabled="disabled"></td>
						</form>
					</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>
<%
	db.closeConnections();
%>
	<script>
		$(document).ready(function() {
			$('#course_select').on('change', function(){
				var val = $(this).val();
				$.ajax('Past_Classes?value=' + val)
				 .success(function(data){
					var $section = $('#section_select');
					$section.empty();
					$.each(data.Section, function(k,v){
						$section.append($('<option></option>')	
								.attr("value",k)
								.text(v));
					});
					var $quarter = $('#quarter_select');
					$quarter.empty();
					$.each(data.Quarter, function(k,v){
						$quarter.append($('<option></option>')
								 .attr("value", k)
								 .text(v));
					});
				});
			});
			$('#section_select').on('change', function(){
				$('#quarter_select').val($(this).val());
				$('#quarter_id').val($('#quarter_select').children(':selected').text());	
				
			});
		});
	</script>
</body>
</html>