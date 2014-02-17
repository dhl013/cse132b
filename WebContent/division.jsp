<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Division Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- DIVISION INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String division_insert = "INSERT INTO Division VALUES (?)";
		String field = request.getParameter("FIELD_NAME");
		
		pstmt = db.getPreparedStatment(division_insert);
		
		pstmt.setString(1, field);
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
		String div_dept = "INSERT INTO Division_part_of VALUES (?,?)";
		pstmt = db.getPreparedStatment(div_dept);
		String[] belong_depts = request.getParameter("DEPARTMENTS").split(",");
		for(String depart : belong_depts){
			pstmt.setString(1, field);
			pstmt.setString(2, depart);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Division_Department with a success of : " + success);
		}
	}
%>
<!-- DIVISION UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){

	}
%>
<!-- DIVISION DELETE CODE -->
<% // NOT WORKING PROPERLY
	if( null != action && action.equals("delete") ){
		String division_delete = "DELETE FROM Division " +
								"WHERE field_name=?;";
		
		pstmt = db.getPreparedStatment(division_delete);
		
		pstmt.setString(1, request.getParameter("FIELD_NAME"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String depts;
	String query = "SELECT * FROM Division	";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
%>
<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="department.jsp" id="banner-link">Department</a>
		</div>
	</div>
	
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>Field Name</th>
					<th>Departments</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_division" action="division.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="FIELD_NAME" size="30"></th>
						<th><input value="" name="DEPARTMENTS" size="60"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_division" action="division.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("field_name") %>" name="FIELD_NAME" size="30"></td>
							<%
								Statement stmt = db.getStatement();
								query = "SELECT * FROM Division_part_of WHERE field_name='" + rs.getString("field_name") +"'";  
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
						<form id="delete_division" action="division.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("field_name") %>" name="FIELD_NAME">
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