<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Major Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- MAJOR INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		
		//// INSERTING MAJOR ////
		boolean success;
		String major = "INSERT INTO Major VALUES (?,?)";
		pstmt = db.getPreparedStatment(major);
		String[] majors = request.getParameter("MAJORS").split(",");
		for(String title : majors){
			pstmt.setString(1, request.getParameter("PID") );
			pstmt.setString(2, title);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Major with a success of : " + success);
		}
	}
%>
<!-- MAJOR UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){


	
	}
%>
<!-- MAJOR DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){

		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String student_major;
	String query = "SELECT * FROM Major";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
%>
<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="undergraduate.jsp" id="banner-link">Student->Undergraduate</a>
		</div>
	</div>
	
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>PID</th>
					<th>Major</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_major" action="major.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="15"></th>
						<th><input value="" name="MAJORS" size="30"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
						<tr>
							<form id="update_major" action="major.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" readonly="true" size="15"></td>
								<td><input value="<%= rs.getString("field_name") %>" name="MAJORS" readonly="true" size="30"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_major" action="major.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
								<td><input type="submit" value="Delete"></td>
							</form>
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