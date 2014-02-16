<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Degree Requirement - Category Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- Category INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String cat_insert = "INSERT INTO Category VALUES (?,?,?)";

		String cat_name = request.getParameter("CAT_NAME");
		
		pstmt = db.getPreparedStatment(cat_insert);
		
		pstmt.setString(1, cat_name);
		pstmt.setFloat(2, Float.parseFloat(request.getParameter("MIN_GPA")) );
		pstmt.setInt(3, Integer.parseInt(request.getParameter("MIN_UNITS")) );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed cat_insert PreparedStatement with a success of : " + success);

		//// CATEGORY_COURSE PART ////
		String cat_course = "INSERT INTO Category_course VALUES (?,?)";
		pstmt = db.getPreparedStatment(cat_course);
		String[] course_in_cat = request.getParameter("COURSE").split(",");
		for(String course : course_in_cat){
			pstmt.setString(1, cat_name);
			pstmt.setString(2, course);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Category_Course with a success of : " + success);
		}
	}
%>
<!-- Category UPDATE CODE -->
<%/*
	if( null != action && action.equals("update") ){

		String faculty_update = "UPDATE Faculty SET faculty_name = ?, " +
								"position = ?" +
								"WHERE faculty_name = ?";
		
		pstmt = db.getPreparedStatment(faculty_update);
		
		pstmt.setString(1, request.getParameter("FACULTY_NAME") );
		pstmt.setString(2, request.getParameter("POSITION") );
		pstmt.setString(3, request.getParameter("FACULTY_NAME") );

		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
	
	}*/
%>
<!-- CATEGORY DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		
		String cat_name = request.getParameter("CAT_NAME");

		//// CATEGORY_COURSE PART ////
		String cat_course = "DELETE FROM Category_course WHERE cat_name = ? AND course_number = ?;";
		pstmt = db.getPreparedStatment(cat_course);
		String[] course_in_cat = request.getParameter("COURSE").split(",");
		boolean success;
		for(String course : course_in_cat){
			pstmt.setString(1, cat_name);
			pstmt.setString(2, course);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Category_Course with a success of : " + success);
		}
		
		
		
		//// Main Part DELETE FROM CATEGORY ////
		String cat_delete = "DELETE FROM Category WHERE cat_name=? AND course_number = ?;";
		
		pstmt = db.getPreparedStatment(cat_delete);
		
		pstmt.setString(1, request.getParameter("FACULTY_NAME"));
		
		boolean success2 = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success2);
		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String courses;
	String query = "SELECT * FROM Category";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
%>
<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="class.jsp" id="banner-link">Class</a>
			<a href="course.jsp "id="banner-link">Course</a>
			<a href="faculty.jsp" id="banner-link">Faculty</a>
			<a href="department.jsp" id="banner-link">Department</a>
			<a href="student.jsp" id="banner-link">Student</a>
		</div>
	</div>
	
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>Category</th>
					<th>Min GPA</th>
					<th>Min Units</th>
					<th>Courses</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_category" action="category.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="CAT_NAME" size="30"></th>
						<th><input value="" name="MIN_GPA" size="10"></th>
						<th><input value="" name="MIN_UNITS" size="10"></th>
						<th><input value="" name="COURSE" size="50"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_category" action="category.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("cat_name") %>" name="CAT_NAME" size="30"></td>
							<td><input value="<%= rs.getString("min_gpa") %>" name="MIN_GPA" size="10"></td>
							<td><input value="<%= rs.getString("min_units") %>" name="MIN_UNITS" size="10"></td>
							<%
								Statement stmt = db.getStatement();
								query = "SELECT * FROM Category_course WHERE cat_name = '" + rs.getString("cat_name") +"'";  
								ResultSet fdrs = stmt.executeQuery(query);
								StringBuilder builder = new StringBuilder();
								while( fdrs.next() ){
									builder.append(fdrs.getString("course_number"));
									builder.append(",");
								}
								courses = builder.toString();
								
							%>
							<td><input value="<%= courses.substring(0, courses.length() -1 ) %>" name="COURSE" size="50"></td>
							<td><input type="submit" value="Update" disabled></td>
						</form>
						<form id="delete_category" action="category.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("cat_name") %>" name="CAT_NAME">
							<td><input type="submit" value="Delete" disabled></td>
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
</body>
</html>