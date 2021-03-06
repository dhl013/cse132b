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
<!-- PROBATION INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String probation_insert = "INSERT INTO Probation VALUES (?,?,?)";

		pstmt = db.getPreparedStatment(probation_insert);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setString(2, request.getParameter("Q_ID") );
		pstmt.setString(3, request.getParameter("REASON") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Insert PreparedStatement with a success of : " + success);

	}
%>
<!-- PROBATION UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){
		String probation_update = "UPDATE Probation SET PID = ?, q_id = ?, " +
							      "reason = ? " +
								  "WHERE PID = ? AND q_id = ?";
		
		pstmt = db.getPreparedStatment(probation_update);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setString(2, request.getParameter("Q_ID") );
		pstmt.setString(3, request.getParameter("REASON") );
		pstmt.setString(4, request.getParameter("PID") );
		pstmt.setString(5, request.getParameter("Q_ID") );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Update PreparedStatement with a success of : " + success);
		

	}
%>
<!-- STUDENT DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String probation_delete = "DELETE FROM Probation " +
								"WHERE PID=? AND q_id = ?";
		
		pstmt = db.getPreparedStatment(probation_delete);
		
		pstmt.setString(1, request.getParameter("PID"));
		pstmt.setString(2, request.getParameter("Q_ID"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed Student Delete PreparedStatement with a success of : " + success);
		
	}
%>

<!-- Query Code --- MUST BE AFTER INSERT/UPDATE/DELETE SECTIONS -->
<%
	String query = "SELECT * FROM Probation";
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>		
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<th>PID</th>
					<th>Q_ID</th>
					<th>Reason</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_probation" action="probation.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="10"></th>
						<th><input value="" name="Q_ID" size="10"></th>
						<th><input value="" name="REASON" size="80"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_probation" action="probation.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" readonly="true" size="10"></td>
								<td><input value="<%= rs.getString("q_id") %>" name="Q_ID" size="10"></td>
								<td><input value="<%= rs.getString("reason") %>" name="REASON" size="80"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_probation" action="probation.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
								<input type="hidden" value="<%= rs.getString("q_id") %>" name="Q_ID">
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