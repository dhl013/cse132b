<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Department Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- DEPARTMENT INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String dep_insert = "INSERT INTO Department VALUES (?)";
		String dep = request.getParameter("DEPARTMENT");
		
		pstmt = db.getPreparedStatment(dep_insert);
		
		pstmt.setString(1, dep);

		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
	}
%>
<!-- DEPARTMENT UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){


	
	}
%>
<!-- DEPARTMENT DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){

		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String depts;
	String query = "SELECT * FROM Department";
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
			<a href="student.jsp" id="banner-link">Student</a>
		</div>
	</div>
	
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>Department Title</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_dep" action="department.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="DEPARTMENT" size="60"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_dep" action="department.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("dept_title") %>" name="DEPARTMENT" size="60"></td>
							<td><input type="submit" value="Update" disabled></td>
						</form>
						<form id="delete_dep" action="department.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("dept_title") %>" name="DEPARTMENT">
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