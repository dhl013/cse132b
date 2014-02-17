<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Probation Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- GRADUATE INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String undergrads_insert = "INSERT INTO UnderGrads VALUES (?,?)";

		pstmt = db.getPreparedStatment(undergrads_insert);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setString(2, request.getParameter("COLLEGE") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed UnderGrads Insert PreparedStatement with a success of : " + success);

	}
%>
<!-- GRADUATE UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){
		String undergrads_update = "UPDATE UnderGrads SET PID = ?, college_name = ? WHERRE PID = ?";
		
		pstmt = db.getPreparedStatment(undergrads_update);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setString(2, request.getParameter("COLLEGE") );
		pstmt.setString(3, request.getParameter("PID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed UNDERGRADS Update PreparedStatement with a success of : " + success);
		

	}
%>
<!-- STUDENT DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String undergrads_delete = "DELETE FROM UnderGrads " +
								"WHERE PID=?";
		
		pstmt = db.getPreparedStatment(undergrads_delete);
		
		pstmt.setString(1, request.getParameter("PID"));
		pstmt.setString(2, request.getParameter("COLLEGE"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed UNDERGRADS Delete PreparedStatement with a success of : " + success);
		
	}
%>

<!-- Query Code --- MUST BE AFTER INSERT/UPDATE/DELETE SECTIONS -->
<%
	String query = "SELECT * FROM UnderGrads";
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="student.jsp" id="banner-link">Student</a>
						<a href="major.jsp" id="banner-link">Student->Undergraduate->Major</a>
			<a href="minor.jsp" id="banner-link">Student->Undergraduate->Minor</a>

			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<th>PID</th>
					<th>College</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_undergrads" action="undergraduate.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="10"></th>
						<th><input value="" name="COLLEGE" size="15"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_undergrads" action="undergraduate.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" readonly="true" size="10"></td>
								<td><input value="<%= rs.getString("college_name") %>" name="COLLEGE" size="15"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_undergrads" action="undergraduate.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
								<input type="hidden" value="<%= rs.getString("college_name") %>" name="COLLEGE">
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