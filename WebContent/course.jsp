<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Course Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
</head>
<!-- COURSE INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String course_insert = "INSERT INTO Course VALUES (?,?,?)";
		String cnum = request.getParameter("COURSE_NUMBER");
		
		pstmt = db.getPreparedStatment(course_insert);
		
		pstmt.setString(1, cnum);
		pstmt.setBoolean(2, (request.getParameter("HAS_LAB").equals("true")) ? true : false );
		pstmt.setBoolean(3, (request.getParameter("NEEDS_CONSENT").equals("true")) ? true : false );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Course Insert PreparedStatement with a success of : " + success);
		
		if( !request.getParameter("PREREQ").equals("") ) {
			String prereq_insert = "INSERT INTO Prerequisite VALUES (?,?)";
			pstmt = db.getPreparedStatment(prereq_insert);
			String[] prereqs = request.getParameter("PREREQ").split(",");
			for( String p : prereqs ){
				pstmt.setString(1, cnum);
				pstmt.setString(2, p);
				success = db.executePreparedStatement(pstmt);
				System.out.println("Executed Course Insert -- Prerequisite PreparedStatement with a success of : " + success);
			}
		}
		if( ! request.getParameter("PREV_NUM").equals("") ) {
			String prev_num_insert = "INSERT INTO Previous_course_number VALUES (?,?)";
			pstmt = db.getPreparedStatment(prev_num_insert);
			String[] prev_nums = request.getParameter("PREV_NUM").split(",");
			for( String p : prev_nums ){
				pstmt.setString(1, cnum);
				pstmt.setString(2, p);
				success = db.executePreparedStatement(pstmt);
				System.out.println("Executed Course Insert -- Previous Course Number PreparedStatement with a success of : " + success);
			}
		
		}
	}
%>
<!-- COURSE INITALIZATION CODE -->
<%
	String prereq, prev;
	String query = "SELECT * FROM Course";
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
					<th>Course Number</th>
					<th>Has Lab</th>
					<th>Need Consent</th>
					<th>Prerequisites</th>
					<th>Previous Course Numbers</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_course" action="course.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<td><input value="" name="COURSE_NUMBER" size="15"></td>
						<td><select name="HAS_LAB" form="insert_course" style="float : right">
								<option value="false">False</option>
								<option value="true">True</option>
							</select></td>	
						<td><select name="NEEDS_CONSENT" form="insert_course" style="float : right">
							<option value="false">False</option>
							<option value="true">True</option>
						</select></td>
						<td><input value="" name="PREREQ" size="25"></td>
						<td><input value="" name="PREV_NUM" size="25"></td>
						<td><input type="submit" value="Insert"></td>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_course" action="course.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("course_number") %>" name="COURSE_NUMBER" size="15"></td>
							<td><select name="HAS_LAB" form="update_course">
									<option value="true" <% if(rs.getBoolean("has_lab")) out.println("selected"); %> >True</option>
									<option value="false" <% if(!rs.getBoolean("has_lab")) out.println("selected"); %> >False</option>
								</select></td>
							<td><select name="NEEDS_CONSENT" form="update_course" style="float : right">
									<option value="true" <% if(rs.getBoolean("needs_consent")) out.println("selected"); %> >True</option>
									<option value="false" <% if(!rs.getBoolean("needs_consent")) out.println("selected"); %> >False</option>
								</select></td>
							<%
								Statement stmt = db.getStatement();
								query = "SELECT * FROM Prerequisite WHERE course_number='" + rs.getString("course_number") +"'";  
								ResultSet ps = stmt.executeQuery(query);
								StringBuilder builder = new StringBuilder();
								while( ps.next() ){
									builder.append(ps.getString("prerequisite_course"));
									builder.append(",");
								}
								prereq = builder.toString();
								
								query = "SELECT * FROM Previous_course_number WHERE course_number='" + rs.getString("course_number") +"'";
								ps = stmt.executeQuery(query);
								builder = new StringBuilder();
								while( ps.next() ){
									builder.append(ps.getString("previous_course_number"));
									builder.append(",");
								}
								prev = builder.toString();
							%>
							<td><input value="<%= prereq %>" name="PREREQ" size="25"></td>
							<td><input value="<%= prev %>" name="PREV_NUM" size="25"></td>
							<td><input type="submit" value="Update" disabled></td>
						</form>
						<form id="delete_faculty" action="faculty.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("course_number") %>" name="COURSE_NUMBER">
							<td><input type="submit" value="Delete" disabled></td>
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