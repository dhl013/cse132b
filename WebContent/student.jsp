<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Student Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- STUDENT INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String student_insert = "INSERT INTO Student VALUES (?,?,?,?,?,?,?)";

		pstmt = db.getPreparedStatment(student_insert);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setString(2, request.getParameter("FIRSTNAME") );
		pstmt.setString(3, request.getParameter("MIDDLENAME") );
		pstmt.setString(4, request.getParameter("LASTNAME") );
		pstmt.setBoolean(5, (request.getParameter("ENROLLED").equals("true")) ? true : false );
		pstmt.setInt(6, Integer.parseInt(request.getParameter("SSN")) );
		pstmt.setString(7, request.getParameter("RESIDENCY").toLowerCase());
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Insert PreparedStatement with a success of : " + success);
	}
%>
<!-- STUDENT UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){
		String student_update = "UPDATE Student SET PID = ?, SSN = ?, " +
								"first_name = ?, middle_name = ?, last_name = ?, " +
								"enrolled = ?, residency = ? " +
								"WHERE PID = ?";
		
		pstmt = db.getPreparedStatment(student_update);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setInt(2, Integer.parseInt(request.getParameter("SSN")) );
		pstmt.setString(3, request.getParameter("FIRSTNAME") );
		pstmt.setString(4, request.getParameter("MIDDLENAME") );
		pstmt.setString(5, request.getParameter("LASTNAME") );
		pstmt.setBoolean(6, (request.getParameter("ENROLLED").equals("true")) ? true : false );
		pstmt.setString(7, request.getParameter("RESIDENCY").toLowerCase());
		pstmt.setString(8, request.getParameter("PID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Update PreparedStatement with a success of : " + success);
		

	}
%>
<!-- STUDENT DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String student_delete = "DELETE FROM Student " +
								"WHERE PID=?;";
		
		pstmt = db.getPreparedStatment(student_delete);
		
		pstmt.setString(1, request.getParameter("PID"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Delete PreparedStatement with a success of : " + success);
		
	}
%>

<!-- Query Code --- MUST BE AFTER INSERT/UPDATE/DELETE SECTIONS -->
<%
	String student_major, student_minor;
	String query = "SELECT * FROM Student";
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="undergraduate.jsp" id="banner-link">Student->Undergraduate</a>
			<a href="graduate.jsp" id="banner-link">Student->Graduate</a>
			<a href="attendance.jsp" id="banner-link">Student->Attendance</a>
			<a href="acquired_degree.jsp" id="banner-link">Student->Acquired Degree</a>
			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<th>PID</th>
					<th>SSN</th>
					<th>First Name</th>
					<th>Middle Name</th>
					<th>Last Name </th>
					<th>Enrolled</th>
					<th>Residency</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_student" action="student.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="10"></th>
						<th><input value="" name="SSN" size="10"></th>
						<th><input value="" name="FIRSTNAME" size="15"></th>
						<th><input value="" name="MIDDLENAME" size="15"></th>
						<th><input value="" name="LASTNAME" size="15"></th>
						<th><select name="ENROLLED" form="insert_student">
								<option value="true">True</option>
								<option value="false">False</option>
							</select></th>
						<th><select name="RESIDENCY" form="insert_student">
								<option value="ca">California Resident</option>
								<option value="nonca">Non-California Resident</option>
								<option value="foreign">Foreign Resident</option>
							</select></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_student" action="student.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" readonly="true" size="10"></td>
								<td><input value="<%= rs.getString("SSN") %>" name="SSN" size="10"></td>
								<td><input value="<%= rs.getString("first_name") %>" name="FIRSTNAME" size="15"></td>
								<td><input value="<%= rs.getString("middle_name") %>" name="MIDDLENAME" size="15"></td>
								<td><input value="<%= rs.getString("last_name") %>" name="LASTNAME" size="15"></td>
								<td><select name="ENROLLED" form="update_student">
									<option value="true" <% if(rs.getBoolean("enrolled")) out.println("selected"); %> >True</option>
									<option value="false" <% if(!rs.getBoolean("enrolled")) out.println("selected"); %> >False</option>
									</select></td>
								<td><select name="RESIDENCY" form="update_student">
									<option value="CA" <% if(rs.getString("residency").equals("ca")) out.println("selected"); %> >California Resident</option>
									<option value="NONCA" <% if(rs.getString("residency").equals("nonca")) out.println("selected"); %> >Non-California Resident</option>
									<option value="FOREIGN" <% if(rs.getString("residency").equals("foreign")) out.println("selected"); %> >Foreign Resident</option>
									</select></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_student" action="student.jsp" method="post">
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