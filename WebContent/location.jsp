<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Location Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- LOCATION INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String location_insert = "INSERT INTO Location VALUES (?,?,?)";

		pstmt = db.getPreparedStatment(location_insert);
		
		pstmt.setString(1, request.getParameter("LOC_ID") );
		pstmt.setString(2, request.getParameter("BUILDING_NAME") );
		pstmt.setString(3, request.getParameter("ROOM_NUMBER") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Insert PreparedStatement with a success of : " + success);

	}
%>
<!-- LOCATION UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){
		String probation_update = "UPDATE Location SET LOC_ID = ?, BUILDING_NAME = ?, " +
							      "ROOM_NUMBER = ? " +
								  "WHERE LOC_ID = ?";
		
		pstmt = db.getPreparedStatment(probation_update);
		
		pstmt.setString(1, request.getParameter("LOC_ID") );
		pstmt.setString(2, request.getParameter("BUILDING_NAME") );
		pstmt.setString(3, request.getParameter("ROOM_NUMBER") );
		pstmt.setString(4, request.getParameter("LOC_ID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Update PreparedStatement with a success of : " + success);
		

	}
%>
<!-- LOCATION DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String probation_delete = "DELETE FROM Location " +
								"WHERE LOC_ID=?";
		
		pstmt = db.getPreparedStatment(probation_delete);
		
		pstmt.setString(1, request.getParameter("LOC_ID"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Delete PreparedStatement with a success of : " + success);
		
	}
%>

<!-- Query Code --- MUST BE AFTER INSERT/UPDATE/DELETE SECTIONS -->
<%
	String query = "SELECT * FROM Location";
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
			<a href="location.jsp" id="banner-link">Location</a>
			<a href="probation.jsp" id="banner-link">Probation</a>
			<a href="quarter_year.jsp" id="banner-link">Quarter/Year</a>
			<a href="student.jsp" id="banner-link">Student</a>

			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<th>Loc ID</th>
					<th>Building Name</th>
					<th>Room Number</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_location" action="location.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="LOC_ID" size="10"></th>
						<th><input value="" name="BUILDING_NAME" size="10"></th>
						<th><input value="" name="ROOM_NUMBER" size="80"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_location" action="location.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("Loc_ID") %>" name="LOC_ID" readonly="true" size="10"></td>
								<td><input value="<%= rs.getString("Building_name") %>" name="BUILDING_NAME" size="10"></td>
								<td><input value="<%= rs.getString("Room_number") %>" name="ROOM_NUMBER" size="80"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_location" action="location.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("Loc_ID") %>" name="LOC_ID">
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