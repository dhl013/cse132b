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
		String course_insert = "INSERT INTO Course VALUES (?,?,?,?)";
		String cnum = request.getParameter("COURSE_NUMBER");
		
		pstmt = db.getPreparedStatment(course_insert);
		
		pstmt.setString(1, cnum);
		pstmt.setBoolean(2, (request.getParameter("HAS_LAB").equals("true")) ? true : false );
		pstmt.setBoolean(3, (request.getParameter("NEEDS_CONSENT").equals("true")) ? true : false );
		pstmt.setString(4, request.getParameter("GRADE_OPTION"));
		
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
		
		String course_units_insert = "INSERT INTO Course_units VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(course_units_insert);
		pstmt.setString(1, cnum);
		pstmt.setInt(2, Integer.parseInt(request.getParameter("UNITS")));
		pstmt.setBoolean(3, (request.getParameter("UP_TO").equals("true")) ? true : false );
		
		success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Course Units PreparedStatement with a success of : " + success);
	}
%>
<!-- COURSE INITALIZATION CODE -->
<%
	String prereq, prev;
	String unit_select = "<select name=\"UNITS\" form=\"insert_course\" >";
	String query = "SELECT * FROM Course c INNER JOIN Course_units cu ON c.course_number = cu.course_number";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
	
	for (int i = 1 ; i < 9 ; i++ ){
		unit_select += "<option value=\"" + i + "\">" + i +"</option>";
	}
	unit_select += "</select>";
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
					<th>Course Number</th>
					<th>Has Lab</th>
					<th>Need Consent</th>
					<th>Grade Option</th>
					<th>Prerequisites</th>
					<th>Previous Course Numbers</th>
					<th>Units</th>
					<th>Variable(Up-To #)</th>
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
						<td><select name="GRADE_OPTION" form="insert_course" style="float : right">
							<option value="Letter">Letter</option>
							<option value="PNP">Pass/No Pass</option>
							<option value="Both">Both</option>
						</select></td>	
						<td><input value="" name="PREREQ" size="25"></td>
						<td><input value="" name="PREV_NUM" size="25"></td>
						<td><input value="" name="UNITS" size="3"></td>
						<td><select name="UP_TO" form="insert_course" style="float : right">
								<option value="false">False</option>
								<option value="true">True</option>
						</select></td>	
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
							<td><select name="GRADE_OPTION" form="update_course" style="float : right">
									<option value="Letter" <% if(rs.getString("grade_option").equals("Letter")) out.println("selected"); %> >Letter</option>
									<option value="PNP" <% if(rs.getString("grade_option").equals("PNP")) out.println("selected"); %> >Pass/No Pass</option>
									<option value="Both" <% if(rs.getString("grade_option").equals("Both")) out.println("selected"); %> >Both</option>
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
							<td><input value="<%= rs.getInt("unit") %>" size="4"></td>
							<td><select name="UP_TO" form="update_course" style="float : right">
									<option value="true" <% if(rs.getBoolean("up_to")) out.println("selected"); %> >True</option>
									<option value="false" <% if(!rs.getBoolean("up_to")) out.println("selected"); %> >False</option>
								</select></td>
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