<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Acquired Degree Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- ACQUIRED DEGREE INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		
		//// INSERTING degree acquired ////
		boolean success;
		String acq = "INSERT INTO Acquired_Degree VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(acq);
		String[] degrees = request.getParameter("DEGREE").split(",");
		for(String deg : degrees){
			pstmt.setString(1, request.getParameter("PID") );
			pstmt.setString(2, deg);
			pstmt.setString(1, request.getParameter("FROM") );
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Acquired From with a success of : " + success);
		}
	}
%>
<!-- ACQUIRED DEGREE UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){


	
	}
%>
<!-- ACQUIRED DEGREE DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){

		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String student_attendance;
	String query = "SELECT * FROM Acquired_Degree";
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
					<th>Acquired Degree</th>
					<th>From</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_acq" action="acquired_degree.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="15"></th>
						<th><input value="" name="DEGREE" size="30"></th>
						<th><input value="" name="FROM" size="20"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
						<tr>
							<form id="update_acq" action="acquired_degree.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" readonly="true" size="15"></td>
								<td><input value="<%= rs.getString("deg_title") %>" name="DEGREE" size="30"></td>
								<td><input value="<%= rs.getString("acquired_from") %>" name="FROM" size="20"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_acq" action="acquired_degree.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
								<input type="hidden" value="<%= rs.getString("deg_title") %>" name="DEGREE">
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