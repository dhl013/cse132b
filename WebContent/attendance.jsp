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
<!-- ATTENDANCE INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		
		//// INSERTING Quarter attended ////
		boolean success;
		String att = "INSERT INTO Attendance VALUES (?,?)";
		pstmt = db.getPreparedStatment(att);
		String[] quarters = request.getParameter("Q_ID").split(",");
		for(String q_id : quarters){
			pstmt.setString(1, request.getParameter("PID") );
			pstmt.setString(2, q_id);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Attendance with a success of : " + success);
		}
	}
%>
<!-- Attendance UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){


	
	}
%>
<!-- Attendance DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){

		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String student_attendance;
	String query = "SELECT * FROM Attendance";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
%>
<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="student.jsp" id="banner-link">Student</a>
		</div>
	</div>
	
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>PID</th>
					<th>Quarters Attended</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_attend" action="attendance.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="15"></th>
						<th><input value="" name="Q_ID" size="30"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
						<tr>
							<form id="update_attend" action="attendance.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" readonly="true" size="15"></td>
								<td><input value="<%= rs.getString("q_id") %>" name="Q_ID" readonly="true" size="30"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_attend" action="attendance.jsp" method="post">
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