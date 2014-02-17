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
		String grads_insert = "INSERT INTO Grads VALUES (?,?)";

		pstmt = db.getPreparedStatment(grads_insert);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setString(2, request.getParameter("DEPARTMENT") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Grads Insert PreparedStatement with a success of : " + success);

	}
%>
<!-- GRADUATE UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){
		String grads_update = "UPDATE Grads SET PID = ?, dept_title = ? WHERRE PID = ?";
		
		pstmt = db.getPreparedStatment(grads_update);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setString(2, request.getParameter("DEPARTMENT") );
		pstmt.setString(3, request.getParameter("PID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed GRADS Update PreparedStatement with a success of : " + success);
		

	}
%>
<!-- STUDENT DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String grads_delete = "DELETE FROM Grads " +
								"WHERE PID=?";
		
		pstmt = db.getPreparedStatment(grads_delete);
		
		pstmt.setString(1, request.getParameter("PID"));
		pstmt.setString(2, request.getParameter("DEPARTMENT"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed GRADS Delete PreparedStatement with a success of : " + success);
		
	}
%>

<!-- Query Code --- MUST BE AFTER INSERT/UPDATE/DELETE SECTIONS -->
<%
	String query = "SELECT * FROM Grads";
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="student.jsp" id="banner-link">Student</a>
			<a href="ph_d.jsp" id="banner-link">Student->Graduate->Ph.D</a>

			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<th>PID</th>
					<th>Department</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_grads" action="graduate.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="10"></th>
						<th><input value="" name="DEPARTMENT" size="15"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_grads" action="graduate.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" readonly="true" size="10"></td>
								<td><input value="<%= rs.getString("dept_title") %>" name="DEPARTMENT" size="15"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_grads" action="graduate.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
								<input type="hidden" value="<%= rs.getString("dept_title") %>" name="DEPARTMENT">
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