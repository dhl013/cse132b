<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Review_Section Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- REVIEW_SECTION INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String review_section_insert = "INSERT INTO Review_Held_on VALUES (?,?,?,?,?,?)";

		pstmt = db.getPreparedStatment(review_section_insert);
		
		pstmt.setString(1, request.getParameter("COURSE_NUMBER") );
		pstmt.setString(2, request.getParameter("CLASS_TITLE") );
		pstmt.setString(3, request.getParameter("SECTION_ID") );
		pstmt.setString(4, request.getParameter("DATE") );
		pstmt.setString(5, request.getParameter("LOC_ID") );
		pstmt.setString(6, request.getParameter("T_ID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Review Insert PreparedStatement with a success of : " + success);

	}
%>
<!-- REVIEW_SECTION UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){
		String review_section_update = "UPDATE Review_Held_on SET course_number = ?, class_title = ?, " +
							      "section_id = ?, date = ?, loc_id = ?, t_id = ? " +
								  "WHERE course_number = ?, class_title = ?, section_id = ?";
		
		pstmt = db.getPreparedStatment(review_section_update);
		
		pstmt.setString(1, request.getParameter("COURSE_NUMBER") );
		pstmt.setString(2, request.getParameter("CLASS_TITLE") );
		pstmt.setString(3, request.getParameter("SECTION_ID") );
		pstmt.setString(4, request.getParameter("DATE") );
		pstmt.setString(5, request.getParameter("LOC_ID") );
		pstmt.setString(6, request.getParameter("T_ID") );
		pstmt.setString(7, request.getParameter("COURSE_NUMBER") );
		pstmt.setString(8, request.getParameter("CLASS_TITLE") );
		pstmt.setString(9, request.getParameter("SECTION_ID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Update PreparedStatement with a success of : " + success);
		

	}
%>
<!-- REVIEW_SECTION DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String review_section_delete = "DELETE FROM Review_Held_on " +
				  						"WHERE course_number = ?, class_title = ?, section_id = ?";
		
		pstmt = db.getPreparedStatment(review_section_delete);
		
		pstmt.setString(1, request.getParameter("COURSE_NUMBER") );
		pstmt.setString(2, request.getParameter("CLASS_TITLE") );
		pstmt.setString(3, request.getParameter("SECTION_ID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Delete PreparedStatement with a success of : " + success);
		
	}
%>

<!-- Query Code --- MUST BE AFTER INSERT/UPDATE/DELETE SECTIONS -->
<%
	String query = "SELECT * FROM Review_Held_on";
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
					<th>Course Number</th>
					<th>Class Title</th>
					<th>Section ID</th>
					<th>Date</th>
					<th>Location</th>
					<th>Time</th>
				</tr>
			</thead>
			<tbody> 
				<tr>
					<form id="insert_review_section" action="review_section.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="COURSE_NUMBER" size="10"></th>
						<th><input value="" name="CLASS_TITLE" size="10"></th>
						<th><input value="" name="SECTION_ID" size="10"></th>
						<th><input value="" name="DATE" size="10"></th>
						<th><input value="" name="LOC_ID" size="10"></th>
						<th><input value="" name="T_ID" size="10"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_review_section" action="review_section.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("course_number") %>" name="COURSE_NUMBER" size="10"></td>
								<td><input value="<%= rs.getString("class_title") %>" name="CLASS_TITLE" size="10"></td>
								<td><input value="<%= rs.getString("section_ID") %>" name="SECTION_ID" size="10"></td>
								<td><input value="<%= rs.getString("date") %>" name="DATE" size="10"></td>
								<td><input value="<%= rs.getString("loc_ID") %>" name="LOC_ID" size="10"></td>
								<td><input value="<%= rs.getString("t_ID") %>" name="T_ID" size="10"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_review_section" action="review_section.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("course_number") %>" name="COURSE_NUMBER">
								<input type="hidden" value="<%= rs.getString("class_title") %>" name="CLASS_TITLE">
								<input type="hidden" value="<%= rs.getString("section_ID") %>" name="SECTION_ID">
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