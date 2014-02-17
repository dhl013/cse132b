<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Teaching Courses Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- TEACHING INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String teach_insert = "INSERT INTO Faculty_teach VALUES (?,?,?)";
		
		pstmt = db.getPreparedStatment(teach_insert);
		
		pstmt.setString(1, request.getParameter("FACULTY"));
		pstmt.setString(2, request.getParameter("COURSE"));
		pstmt.setString(3, request.getParameter("Q_ID"));

		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Faculty_teaching PreparedStatement with a success of : " + success);
	}
%>
<!-- TEACHING UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){


	
	}
%>
<!-- TEACHING DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){

		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String query = "SELECT * FROM Faculty_teach";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
%>
<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="faculty.jsp" id="banner-link">Faculty</a>
		</div>
	</div>
	
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>Faculty Name</th>
					<th>Course Number</th>
					<th>Current Quarter/Year</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_teaching" action="faculty_teaching.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="FACULTY" size="15"></th>
						<th><input value="" name="COURSE" size="15"></th>
						<th><input value="" name="Q_ID" size="10"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_teaching" action="faculty_teaching.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("faculty_name") %>" name="FACULTY" size="15"></td>
							<td><input value="<%= rs.getString("course_number") %>" name="COURSE" size="15"></td>
							<td><input value="<%= rs.getString("q_id") %>" name="Q_ID" size="10"></td>
							<td><input type="submit" value="Update" disabled></td>
						</form>
						<form id="delete_teaching" action="faculty_teaching.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("faculty_name") %>" name="FACULTY">
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