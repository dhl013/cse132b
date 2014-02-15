<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Quarter_year Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- Quarter_year INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String quarter_year_insert = "INSERT INTO Quarter_year VALUES (?,?,?)";

		pstmt = db.getPreparedStatment(quarter_year_insert);
		
		pstmt.setString(1, request.getParameter("Q_ID") );
		pstmt.setString(2, request.getParameter("QUARTER").toLowerCase());
		pstmt.setInt(3, Integer.parseInt(request.getParameter("YEAR")) );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Quarter_year Insert PreparedStatement with a success of : " + success);

	}
%>

<!-- Quarter_year UPDATE CODE -->
<%
/*
	if( null != action && action.equals("update") ){
		String quarter_year_update = "UPDATE Quarter_year SET Q_ID = ?, Quarter = ?, " +
									 "Year = ?, WHERE Q_ID = ?";
		
		pstmt = db.getPreparedStatment(quarter_year_update);
		
		pstmt.setString(1, request.getParameter("Q_ID") );
		pstmt.setString(2, request.getParameter("QUARTER").toLowerCase());
		pstmt.setInt(3, Integer.parseInt(request.getParameter("YEAR")) );
		pstmt.setString(1, request.getParameter("Q_ID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Quarter_year Update PreparedStatement with a success of : " + success);
		

	}
*/
%>

<!-- Quarter_year DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String quarter_year_delete = "DELETE FROM Quarter_year " +
									 "WHERE Q_ID=?;";
		
		pstmt = db.getPreparedStatment(quarter_year_delete);
		
		pstmt.setString(1, request.getParameter("Q_ID"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Delete PreparedStatement with a success of : " + success);
		
	}
%>

<!-- Query Code --- MUST BE AFTER INSERT/UPDATE/DELETE SECTIONS -->
<%
	String query = "SELECT * FROM Quarter_year";
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
			<a href="probation.jsp" id="banner-link">Probation</a>
			<a href="quarter_year.jsp" id="banner-link">Quarter/Year</a>
			<a href="student.jsp" id="banner-link">Student</a>

			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<th>Q_ID</th>
					<th>Quarter</th>
					<th>Year</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_quarter_year" action="quarter_year.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="Q_ID" size="10"></th>
						<th><select name="QUARTER" form="insert_quarter_year">
								<option value="sp">Spring</option>
								<option value="su">Summer</option>
								<option value="fa">Fall</option>
								<option value="wi">Winter</option>
							</select></th>
						<th><input value="" name="YEAR" size="15"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_quarter_year" action="quarter_year.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("Q_ID") %>" name="Q_ID" size="10"></td>
								
								<td><select name="QUARTER" form="update_qurater_year">
									<option value="SP" <% if(rs.getString("Quarter").equals("sp")) out.println("selected"); %> >Spring</option>
									<option value="SU" <% if(rs.getString("Quarter").equals("su")) out.println("selected"); %> >Summer</option>
									<option value="FA" <% if(rs.getString("Quarter").equals("fa")) out.println("selected"); %> >Fall</option>
									<option value="WI" <% if(rs.getString("Quarter").equals("wi")) out.println("selected"); %> >Winter</option>
									</select></td>
								<td><input value="<%= rs.getString("YEAR") %>" name="YEAR" size="15"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_quarter_year" action="quarter_year.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("Q_ID") %>" name="Q_ID">
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