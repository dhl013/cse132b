<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Pursuing Degree Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- PURSUING DEGREE INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		
		//// INSERTING degree acquired ////
		boolean success;
		String pur = "INSERT INTO Pursuing_Degree VALUES (?,?)";
		pstmt = db.getPreparedStatment(pur);
		String[] degrees = request.getParameter("DEGREE").split(",");
		for(String deg : degrees){
			pstmt.setString(1, request.getParameter("PID") );
			pstmt.setString(2, deg);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Pursuing Degree with a success of : " + success);
		}
	}
%>
<!-- Pursuing DEGREE UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){


	
	}
%>
<!-- Pursuing DEGREE DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){

		
	}
%> 
<!-- PAGE INITALIZATION CODE -->
<%
	String query = "SELECT * FROM Pursuing_Degree";
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
					<th>Pursuing Degree</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_acq" action="pursuing_degree.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="15"></th>
						<th><input value="" name="DEGREE" size="30"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
						<tr>
							<form id="update_acq" action="purusing_degree.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" readonly="true" size="15"></td>
								<td><input value="<%= rs.getString("deg_title") %>" name="DEGREE" size="30"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_acq" action="purusing_degree.jsp" method="post">
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