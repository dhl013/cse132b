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
<!-- FACULTY INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String faculty_insert = "INSERT INTO Faculty VALUES (?,?,?)";
		
		pstmt = db.getPreparedStatment(faculty_insert);
		
		pstmt.setString(1, request.getParameter("FACULTY_NAME") );
		pstmt.setString(2, request.getParameter("POSITION"));
		pstmt.setString(3, request.getParameter("DEPARTMENT"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
	}
%>
<!-- FACULTY UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){

		String faculty_update = "UPDATE Faculty SET faculty_name = ?, " +
								"position = ?, dept_title = ? " +
								"WHERE faculty_name = ?";
		
		pstmt = db.getPreparedStatment(faculty_update);
		
		pstmt.setString(1, request.getParameter("FACULTY_NAME") );
		pstmt.setString(2, request.getParameter("POSITION") );
		pstmt.setString(3, request.getParameter("DEPARTMENT") );
		pstmt.setString(4, request.getParameter("FACULTY_NAME") );

		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
	
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String query = "SELECT * FROM Department";
	db.executeQuery(query);
	ResultSet rs = db.getResultSet();
	
	String dept_options = "";
	String dept;
	
	while( rs.next() ){
		dept = rs.getString("dept_title");
		dept_options += "<option value=\"" + dept + "\">" + dept + "</option>\n";
	}
	
	query = "SELECT * FROM Faculty";
	db.executeQuery(query);
	rs = db.getResultSet();
%>
<body>
	<div id="banner">
		<div id="banner-content">
			<span id="banner-text">Links to other Forms: </span>
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
					<th>Faculty Name</th>
					<th>Position</th>
					<th>Department</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_faculty" action="faculty.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="FACULTY_NAME" size="30"></th>
						<th><input value="" name="POSITION" size="20"></th>
						<th><select name="DEPARTMENT" form="insert_faculty">
							<%= dept_options %>
							</select></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_faculty" action="faculty.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("faculty_name") %>" name="FACULTY_NAME" size="30"></td>
							<td><input value="<%= rs.getString("position") %>" name="POSITION" size="20"></td>
							<td><select name="DEPARTMENT" form="update_faculty">
								<%
									//Get the selected department
									String lines[] = dept_options.split("\\r?\\n");
									String line;
									dept = rs.getString("dept_title");
									
									for( int i = 0 ; i < lines.length ; i++ ){
										if(lines[i].contains(dept)){
											line = lines[i];
											int index = line.indexOf(">");
											String beg = line.substring(0, index);
											String end = line.substring(index);
											lines[i] = beg + " selected " + end;
										}
									}
									
									StringBuilder builder = new StringBuilder();
									for(String s : lines){
										builder.append(s);
									}
									line = builder.toString();
								%>
								<%= line %>
								</select>
								<td><input type="submit" value="Update"></td>
						</form>
						<form id="delete_faculty" action="faculty.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("faculty_name") %>" name="FACULTY_NAME">
							<td><input type="submit" value="Delete"></td>
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