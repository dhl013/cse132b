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
<!-- COURSE ENROLLMENT INSERT CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String course_enroll_insert = "INSERT INTO Currently_Enrolled VALUES (?,?,?,?,?,?)";
		
		String class_title_query = "SELECT class_title FROM SECTION s WHERE s.section_id='"+ request.getParameter("SECTION_ID") +"'";
		db.executeQuery(class_title_query);
		ResultSet tmprs = db.getResultSet();
		tmprs.next();
		
		pstmt = db.getPreparedStatment(course_enroll_insert);
		pstmt.setString(1, request.getParameter("PID"));
		pstmt.setString(2, request.getParameter("COURSE"));
		pstmt.setString(3, tmprs.getString("class_title"));
		pstmt.setString(4, request.getParameter("SECTION_ID"));
		pstmt.setString(5, "");
		pstmt.setInt(6, Integer.parseInt(request.getParameter("UNIT")));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed currently_enrolled Insert PreparedStatement with a success of : " + success);
	}
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
	
	query = "SELECT * FROM Currently_Enrolled";
	db.executeQuery(query);
	rs = db.getResultSet();
	
%>
<body>

<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
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
						<td><input value="" name="PID" size="15"></td>
						<td><%= course_select %></td>
						<td><select id="section_select" name="SECTION_ID" form="insert_course_enrollment" size="10" style="width:200px">
							</select></td>
						<td><select id="unit_select" name="UNIT" form="insert_course_enrollment" size="10" style="width:100px">
							</select></td>
						<td><input type="submit" value="Insert"></td>
					</form>	
				</tr>
				<%
					while( rs.next() ) {
				%>
					<tr>
						<form id="update_course_enrollment" action="course_enrollment.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("PID") %>" size="15"></td>
							<td><input value="<%= rs.getString("course_number") %>" size="10"></td>
							<td><input value="<%= rs.getString("section_id") %>" size="25"></td>
							<td><input value="<%= rs.getString("num_units") %>" size="10"></td>
							<td><input type="submit" value="Update" disabled="disabled"></td>
						</form>
						<form id="delete_course_enrollment" action="course_enrollment.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
							<input type="hidden" value="<%= rs.getString("course_number") %>" name="COURSE">
							<input type="hidden" value="<%= rs.getString("section_id") %>" name="SECTION_ID">
							<td><input type="submit" value="Delete" disabled="disabled"></td>
						</form>
					</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>
	<script>
		$(document).ready(function() {
			$('#course_select').on('change', function(){
				var val = $(this).val();
				$.ajax('Course_section?type=section&value='+val)
					.success(function(data){
						console.log(data);
						var $section = $('#section_select');
						$section.empty();
						console.log($section);
						$.each(data, function(k,v){
							console.log(k,v);
							$section.append($('<option></option>')	
									.attr("value",k)
									.text(v));
						});
						$.ajax('Course_section?type=units&value='+val)
							.success(function(data){
								console.log(data);
								$unit = $('#unit_select');
								$unit.empty();
								var num = data[val];
								if(true === data['variable']){
									for(var i = 1; i <= num; i++){
										console.log(num);
										$unit.append($('<option></option>')
												 .attr("value", i)
												 .text(i));
									}
								}
								else{
									$unit.append($('<option></option>')
										 .attr("value", num)
										 .text(num));
								}
								
							});
					});
			});		
		});
	</script>
	<%
		db.closeConnections();
	%>
</body>
</html>