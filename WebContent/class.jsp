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
		boolean success;
		//Check if class already exists before inserting into
		String class_check = "SELECT * FROM Class c WHERE c.course_number = '" + request.getParameter("COURSE") + "'";
		db.executeQuery(class_check);
		ResultSet tmprs = db.getResultSet();
		boolean insert_class = true;
		while( tmprs.next() ){
			insert_class = false;
		}
		if(insert_class) {
			String class_insert = "INSERT INTO Class VALUES (?,?)";
			
			pstmt = db.getPreparedStatment(class_insert);
			pstmt.setString(1, request.getParameter("COURSE"));
			pstmt.setString(2, request.getParameter("CLASS_TITLE"));
			
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed Class Insert PreparedStatement with a success of : " + success);
		}
		
		String section_check = "SELECT * FROM Section s WHERE s.section_id = '" + request.getParameter("SECTION_ID") + "'";
		db.executeQuery(section_check);
		tmprs = db.getResultSet();
		boolean insert_section = true;
		while( tmprs.next() ){
			insert_section = false;
		}
		
		if(insert_section){
			String section_insert = "INSERT INTO Section VALUES (?,?,?,?,?)";
			pstmt = db.getPreparedStatment(section_insert);
			pstmt.setString(1, request.getParameter("COURSE"));
			pstmt.setString(2, request.getParameter("CLASS_TITLE"));
			pstmt.setString(3, request.getParameter("SECTION_ID"));
			pstmt.setBoolean(4, request.getParameter("DISC_MAN").equals("true") ? true : false );
			pstmt.setString(5, request.getParameter("ENROLL_LIM"));
			
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed Section Insert PreparedStatement with a success of : " + success);
		}
		
		String weekly_meeting_insert = "INSERT INTO Weekly_Meeting VALUES (?,?,?,?,?)";
		pstmt = db.getPreparedStatment(weekly_meeting_insert);
		pstmt.setString(1, request.getParameter("COURSE"));
		pstmt.setString(2, request.getParameter("CLASS_TITLE"));
		pstmt.setString(3, request.getParameter("SECTION_ID"));
		pstmt.setString(4, request.getParameter("W_ID") );
		pstmt.setString(5, request.getParameter("TYPE"));	
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Weekly Meeting Insert PreparedStatement with a success of : " + success);
		
		String insert_meetings = "INSERT INTO Meeting_Day VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(insert_meetings);
		pstmt.setString(1, request.getParameter("SECTION_ID"));
		pstmt.setString(2, request.getParameter("W_ID"));
		pstmt.setString(3, request.getParameter("DAY"));
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Meetings_Day Insert PreparedStatement with a success of : " + success + " For day: " + request.getParameter("DAY"));

		
		String insert_meet_loc = "INSERT INTO Meeting_Location VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(insert_meet_loc);
		pstmt.setString(1, request.getParameter("SECTION_ID"));
		pstmt.setString(2, request.getParameter("W_ID"));
		//Is the already LOC ID??
		pstmt.setString(3, request.getParameter("LOCATION"));
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Meetings Location Insert PreparedStatement with a success of : " + success);
		
		String insert_meet_time = "INSERT INTO Meeting_Time VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(insert_meet_time);
		pstmt.setString(1, request.getParameter("SECTION_ID"));
		pstmt.setString(2, request.getParameter("W_ID"));
		pstmt.setString(3, request.getParameter("TIME"));
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Meetings Time Insert PreparedStatement with a success of : " + success);
		
		if(insert_class) {
			String insert_offered = "INSERT INTO Class_offered VALUES (?,?,?)";
			pstmt = db.getPreparedStatment(insert_offered);
			pstmt.setString(1, request.getParameter("COURSE"));
			pstmt.setString(2, request.getParameter("CLASS_TITLE"));
			pstmt.setString(3, request.getParameter("QUARTER"));
			
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed Class_offered Insert PreparedStatement with a success of : " + success);
		}
	}
%>
<!-- CLASS INITALIZTION -->
<%
	String course_select = "<select name=\"COURSE\"size=\"5\" form=\"insert_class\">";
	String meeting_day_select = "<select name=\"DAY\"form=\"insert_class\">";
	String time_select = "<select name=\"TIME\"form=\"insert_class\">";
	String quarter_select = "<select name=\"QUARTER\" form=\"insert_class\">";
	String[] days_keys = {"Monday", "Tuesday", "Wednesday","Thursday","Friday","MW","TuTh","MWF"};
	String query = "SELECT * FROM Course";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
	
	while( rs.next() ){
		course_select += "<option value=\"" + rs.getString("course_number") + "\">" + rs.getString("course_number") +"</option>";
	}
	course_select += "</select>";
	
	
	for(String day : days_keys){
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
	
	query = "SELECT s.*, w.w_id, w.w_type, md.day, ml.loc_id, t.starting_time, t.duration, co.q_id " +
			"FROM Class c, Section s, Weekly_Meeting w, Meeting_Day md, Meeting_Location ml, Meeting_Time mt, Time_Table t, Class_offered co " +
			"WHERE c.course_number = s.course_number " +
			"AND   w.course_number = s.course_number " +
			"AND   md.section_id = s.section_id " +
			"AND   md.w_id = w.w_id " +
			"AND   ml.section_id = s.section_id " +
			"AND   ml.w_id = w.w_id " +
			"AND   mt.section_id = s.section_id " +
			"AND   mt.w_id = w.w_id " +
			"AND   mt.t_id = t.t_id " +
			"AND   c.course_number = co.course_number";
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
						<td><input value="" name="CLASS_TITLE" size="25"></td>
						<td><input value="" name="SECTION_ID" size="6"></td>
						<td><select name="DISC_MAN" form="insert_class" style="float : right">
								<option value="false">False</option>
								<option value="true">True</option>
							</select></td>	
						<td><input value="" name="ENROLL_LIM" size="3"></td>
						<td><input value="" name="W_ID" size="5"></td>
						<td><%= meeting_day_select %></td>
						<td><%= time_select %></td>
						<td><input value="" name="LOCATION" size="6"></td>
						<td><select name="TYPE" form="insert_class" style="float : right">
								<option value="LE">Lecture</option>
								<option value="DI">Discussion</option>
								<option value="LAB">Lab</option>
							</select></td>
						<td><%= quarter_select %></td>
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
					<tr>
						<form id="update_class" action="class.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("course_number") %>" name="COURSE" size="8"></td>
							<td><input value="<%= rs.getString("class_title") %>" name="CLASS_TITLE" size="25"></td>
							<td><input value="<%= rs.getString("section_id") %>" name="SECTION_ID" size="6"></td>
							<td><select name="DISC_MAN" form="update_class">
									<option value="true" <% if(rs.getBoolean("discussion_mandatory")) out.println("selected"); %> >True</option>
									<option value="false" <% if(!rs.getBoolean("discussion_mandatory")) out.println("selected"); %> >False</option>
									</select></td>
							<td><input value="<%= rs.getInt("enrollment_limit") %>" name="ENROLL_LIM" size="3"></td>
							<td><input value="<%= rs.getString("w_id") %>" name="W_ID" size="5"></td>
							<td><input value="<%= rs.getString("day") %>" name="DAY" size="10"></td>
							<td><input value="<%= rs.getString("starting_time") +" -- "+ Integer.toString(rs.getInt("duration")) +" min" %>" name="TIME" size="15"></td>
							<td><input value="<%= rs.getString("loc_id") %>" name="LOCATION" size="6"></td>
							<td><input value="<%= rs.getString("w_type") %>" name="TYPE" size="10"></td>
							<td><input value="<%= rs.getString("q_id")%>" name="QUARTER" size="5"></td> 
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