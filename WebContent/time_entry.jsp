<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Course Enrollment Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- TIME_TABLE INSERT CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String insert_time = "INSERT INTO Time_Table VALUES(?,?,?)";
		
		pstmt = db.getPreparedStatment(insert_time);
		
		pstmt.setString(1, request.getParameter("T_ID"));
		DateFormat formatter = new SimpleDateFormat("HH:mm:ss");
		Time t = new java.sql.Time(formatter.parse(request.getParameter("TIME")).getTime());
		pstmt.setTime(2, t);
		pstmt.setInt(3, Integer.parseInt(request.getParameter("DURATION")));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Insert Time PreparedStatement with a success of : " + success);
		
	
	}

%>
<!-- TIME PAGE INITALIZTION CODE -->
<%
	String query = "SELECT * FROM Time_Table";
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
					<th>Time ID</th>
					<th>Starting Time</th>
					<th>Duration</th>
				</tr>
			</thead>
			<tbody> 
				<tr>
					<form id="insert_time" action="time_entry.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="T_ID" size="5"></td>
						<td><input value="" name="TIME" size="20" placeholder="HH:MM:SS -- 24HR"></td>
						<td><input value="" name="DURATION" size="5"></td>
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
					<tr>
						<form id="udpate_time" action="time_entry.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("t_id") %>" name="T_ID" size="5"></td>
							<td><input value="<%= rs.getTime("starting_time") %>" name="TIME" size="20"></td>
							<td><input value="<%= rs.getInt("duration") %>" name="DURATION" size="5"></td>
							<td><input type="submit" value="Update" disabled="disabled"></td>
						</form>
						<form id="delete_time" action="time_entry.jsp" method="post">
							<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("t_id") %>" name="T_ID">
								<td><input type="submit" value="Delete" disabled="disabled"></td>
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