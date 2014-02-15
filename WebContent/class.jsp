<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Class Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- CLASS INSERT CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String class_insert = "INSERT INTO Class VALUES (?,?)";
		
		pstmt = db.getPreparedStatment(class_insert);
		pstmt.setString(1, request.getParameter("COURSE"));
		pstmt.setString(2, request.getParameter("CLASS_TITLE"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Class Insert PreparedStatement with a success of : " + success);
		
		String section_insert = "INSERT INTO Section VALUES (?,?,?,?,?)";
		pstmt = db.getPreparedStatment(section_insert);
		pstmt.setString(1, request.getParameter("COURSE"));
		pstmt.setString(2, request.getParameter("CLASS_TITLE"));
		pstmt.setString(3, request.getParameter("SECTION_ID"));
		pstmt.setBoolean(4, request.getParameter("DISC_MAN").equals("true") ? true : false );
		pstmt.setString(5, request.getParameter("ENROLL_LIM"));
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Section Insert PreparedStatement with a success of : " + success);
		
		String weekly_meeting_insert = "INSERT INTO Weekly_Meetings VALUES (?,?,?,?,?)";
		pstmt = db.getPreparedStatment(weekly_meeting_insert);
		pstmt.setString(1, request.getParameter("COURSE"));
		pstmt.setString(2, request.getParameter("CLASS_TITLE"));
		pstmt.setString(3, request.getParameter("SECTION_ID"));
		pstmt.setString(4, request.getParameter("W_ID") );
		pstmt.setString(5, request.getParameter("TYPE"));	
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Weekly Meeting Insert PreparedStatement with a success of : " + success);
		
		String[] insert_days = request.getParameter("DAY").split("(?=\\p{Upper})");
		String insert_meetings = "INSERT INTO Meetings_Day VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(insert_meetings);
		pstmt.setString(1, request.getParameter("SECTION_ID"));
		pstmt.setString(2, request.getParameter("W_ID"));
		for(String d : insert_days){
			pstmt.setString(3, d);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed Meetings_Day Insert PreparedStatement with a success of : " + success + "For day: " + d);
		}
		
		String insert_meet_loc = "INSERT INTO Meetings_Location VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(insert_meet_loc);
		pstmt.setString(1, request.getParameter("SECTION_ID"));
		pstmt.setString(2, request.getParameter("W_ID"));
		//Is the already LOC ID??
		pstmt.setString(3, request.getParameter("LOCATION"));
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Meetings Location Insert PreparedStatement with a success of : " + success);
		
		String insert_meet_time = "INSERT INTO Meetings_Time VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(insert_meet_time);
		pstmt.setString(1, request.getParameter("SECTION_ID"));
		pstmt.setString(2, request.getParameter("W_ID"));
		pstmt.setString(3, request.getParameter("TIME"));
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Meetings Time Insert PreparedStatement with a success of : " + success);
		
		String insert_offered = "INSERT INTO Class_offered VALUES (?,?,?)";
		pstmt.setString(1, request.getParameter("COURSE"));
		pstmt.setString(2, request.getParameter("CLASS_TITLE"));
		pstmt.setString(3, request.getParameter("QUARTER"));
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Class_offered Insert PreparedStatement with a success of : " + success);
	}
%>
<!-- CLASS INITALIZTION -->
<%
	String course_select = "<select name=\"COURSE\"size=\"5\" form=\"insert_class\">";
	String meeting_day_select = "<select name=\"DAY\"form=\"insert_class\">";
	String time_select = "<select name=\"TIME\"form=\"insert_class\">";
	String quarter_select = "<select name=\"QUARTER\" form=\"insert_class\">";
	String[] days = {"M","Tu","W","Th","F","MWF","TuTh", "MW"};
	String query = "SELECT * FROM Course";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
	
	while( rs.next() ){
		course_select += "<option value=\"" + rs.getString("course_number") + "\">" + rs.getString("course_number") +"</option>";
	}
	course_select += "</select>";
	
	for(String day : days){
		meeting_day_select += "<option value=\"" + day + "\">" + day + "</option>";	
	}
	meeting_day_select += "</select>";
	
	query = "SELECT * FROM Time_Table";
	db.executeQuery(query);
	rs = db.getResultSet();
	
	while( rs.next() ){
		time_select += "<option value=\"" + rs.getString("t_id") + "\">" + rs.getString("starting_time") 
					+ " --- " + rs.getString("Duration") +" min" +"</option>";
	}
	time_select += "</select>";

	query = "SELECT * FROM Quarter_year";
	db.executeQuery(query);
	rs = db.getResultSet();
	
	while(rs.next()){
		quarter_select += "<option value=\"" + rs.getString("q_id") +"\">" + rs.getString("quarter") + " "
						  + rs.getString("year") + "</option>";
	}
			
	quarter_select += "</select>";
	
	query = "SELECT * FROM Class";
	db.executeQuery(query);
	rs = db.getResultSet();
	
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
				<th>Course</th>
				<th>Class Title</th>
				<th>Section ID</th>
				<th>Disc. Req.</th>
				<th>Enroll Lim</th>
				<th>Meeting ID</th>
				<th style="text-align : center">Days</th>
				<th style="text-align : center">Time - Duration</th>
				<th style="text-align : center"> Location </th>
				<th>Type</th>
				<th>Quarter Offered</th>
			</thead>
			<tbody>
				<tr>
					<form id="insert_class" action="class.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<td><%= course_select %></td>
						<td><input value="" name="CLASS_TITLE" size="20"></td>
						<td><input value="" name="SECTION_ID" size="7"></td>
						<td><select name="DISC_MAN" form="insert_class" style="float : right">
								<option value="false">False</option>
								<option value="true">True</option>
							</select></td>	
						<td><input value="" name="ENROLL_LIM" size="3"></td>
						<td><input value="" name="W_ID" size="5"></td>
						<td><%= meeting_day_select %></td>
						<td><%= time_select %></td>
						<td><input value="" name="LOCATION" size="15"></td>
						<td><select name="TYPE" form="insert_class" style="float : right">
								<option value="LE">Lecture</option>
								<option value="DI">Discussion</option>
								<option value="LAB">Lab</option>
							</select></td>
						<td><%= quarter_select %></td>
						<td><input type="submit" value="Insert"></td>
					</form>
			</tbody>
			
		</table>
	</div>
	<%
		db.closeConnections();
	%>
</body>
</html>