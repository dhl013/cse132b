<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>College Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- COLLEGE INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String col_insert = "INSERT INTO College VALUES (?)";
		String col = request.getParameter("COLLEGE");
		
		pstmt = db.getPreparedStatment(col_insert);
		
		pstmt.setString(1, col);

		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
	}
%>
<!-- COLLEGE UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){


	
	}
%>
<!-- COLLEGE DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){

		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String col;
	String query = "SELECT * FROM College";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
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
					<th>College Name</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_col" action="college.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="COLLEGE" size="60"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_col" action="college.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("college_name") %>" name="COLLEGE" size="60"></td>
							<td><input type="submit" value="Update" disabled></td>
						</form>
						<form id="delete_col" action="college.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("college_name") %>" name="COLLEGE">
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