<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Section Instructor Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- SECTION INSTRUCTOR INSERT CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String section_inst_insert = "INSERT INTO Section_instructor VALUES (?,?,?)";
		
		pstmt = db.getPreparedStatment(section_inst_insert);
		
		pstmt.setString(1, request.getParameter("SECTION_ID"));
		pstmt.setString(2, request.getParameter("QUARTER"));
		pstmt.setString(3, request.getParameter("FACULTY"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
	}
%>
<!-- SECTION INSTRUCTOR INITALIZATION CODE -->
<%
	String faculty_select = "<select name=\"FACULTY\"size=\"15\" form=\"insert_section_inst\">";
	
	String query = "SELECT * FROM Faculty";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
	
	while( rs.next() ){
		faculty_select += "<option value=\"" + rs.getString("faculty_name") + "\">" + rs.getString("faculty_name") +"</option>";
	}
	faculty_select += "</select>";
	
	query = "SELECT * FROM Section_instructor";
	db.executeQuery(query);
	rs = db.getResultSet();
%>
<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
		</div>
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>Section ID</th>
					<th>Quarter ID</th>
					<th>Faculty Name</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_section_inst" action="section_instructor.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="SECTION_ID"></th>
						<th><input value="" name="QUARTER"></th>
						<th><%= faculty_select %></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_sec_inst" action="section_instructor.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<<th><input value="<%= rs.getString("section_id") %>" name="SECTION_ID"></th>
								<th><input value="<%= rs.getString("q_id") %>" name="QUARTER"></th>
								<th><input value="<%= rs.getString("faculty_name") %>"></th>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_sec_inst" action="section_instructor.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("section_id") %>" name="SECTION_ID">
								<input type="hidden" value="<%= rs.getString("q_id") %>" name="QUARTER">
								<td><input type="submit" value="Delete"></td>
							</form>
						</tr>
				<%
					}
				%>
	</div>
</body>
</html>