<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Faculty Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- FACULTY INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String faculty_insert = "INSERT INTO Faculty VALUES (?,?)";
		String fac = request.getParameter("FACULTY_NAME");
		
		pstmt = db.getPreparedStatment(faculty_insert);
		
		pstmt.setString(1, fac);
		pstmt.setString(2, request.getParameter("POSITION"));

		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
		String fac_dept = "INSERT INTO Faculty_Department VALUES (?,?)";
		pstmt = db.getPreparedStatment(fac_dept);
		String[] belong_depts = request.getParameter("DEPARTMENTS").split(",");
		for(String depart : belong_depts){
			pstmt.setString(1, fac);
			pstmt.setString(2, depart);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Faculty_Department with a success of : " + success);
		}
	}
%>
<!-- FACULTY UPDATE CODE -->
<%
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
		
	
	}
%>
<!-- FACULTY DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String faculty_delete = "DELETE FROM Faculty " +
								"WHERE faculty_name=?;";
		
		pstmt = db.getPreparedStatment(faculty_delete);
		
		pstmt.setString(1, request.getParameter("FACULTY_NAME"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String depts;
	String query = "SELECT * FROM Faculty";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
%>
<body>
	<div id="banner">
		<div id="banner-content">
			<span id="banner-text">Links to other Forms: </span>
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
					<th>Faculty Name</th>
					<th>Position</th>
					<th>Departments</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_faculty" action="faculty.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="FACULTY_NAME" size="30"></th>
						<th><input value="" name="POSITION" size="20"></th>
						<th><input value="" name="DEPARTMENTS" size="60"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_faculty" action="faculty.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("faculty_name") %>" name="FACULTY_NAME" size="30"></td>
							<td><input value="<%= rs.getString("position") %>" name="POSITION" size="20"></td>
							<%
								Statement stmt = db.getStatement();
								query = "SELECT * FROM Faculty_Department WHERE faculty_name='" + rs.getString("faculty_name") +"'";  
								ResultSet fdrs = stmt.executeQuery(query);
								StringBuilder builder = new StringBuilder();
								while( fdrs.next() ){
									builder.append(fdrs.getString("dept_title"));
									builder.append(",");
								}
								depts = builder.toString();
								
							%>
							<td><input value="<%= depts.substring(0, depts.length() -1 ) %>" name="DEPARTMENTS" size="60"></td>
							<td><input type="submit" value="Update" disabled></td>
						</form>
						<form id="delete_faculty" action="faculty.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("faculty_name") %>" name="FACULTY_NAME">
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