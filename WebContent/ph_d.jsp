<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Ph.D Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- Ph.D INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String phd_insert = "INSERT INTO Ph_D VALUES (?,?,?)";

		pstmt = db.getPreparedStatment(phd_insert);
		
		pstmt.setString(1, request.getParameter("PID") );
		pstmt.setString(2, request.getParameter("STATUS"));
		pstmt.setString(3, request.getParameter("ADVISOR"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PHD Insert PreparedStatement with a success of : " + success);

	}
%>

<!-- Ph.D UPDATE CODE -->
<%
/*
	if( null != action && action.equals("update") ){
		String quarter_year_update = "UPDATE Quarter_year SET Q_ID = ?, Quarter = ?, " +
									 "year = ?, WHERE q_id = ?";
		
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

<!-- Ph.D DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String phd_delete = "DELETE FROM Ph_D " +
									 "WHERE PID=?;";
		
		pstmt = db.getPreparedStatment(phd_delete);
		
		pstmt.setString(1, request.getParameter("PID"));
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PHD Delete PreparedStatement with a success of : " + success);
		
	}
%>

<!-- Query Code --- MUST BE AFTER INSERT/UPDATE/DELETE SECTIONS -->
<%
	String query = "SELECT * FROM Ph_D";
	db.executeQuery(query);
	
	ResultSet rs = db.getResultSet();
%>

<body>
	<div id="banner">
		<div id="banner-content">
			<a href="index.jsp" id="banner-link">Home</a>
			<a href="graduate.jsp" id="banner-link">Student->Graduate</a>

			
		</div>
	</div>
	<div id="form-table" style="float:left">
		<table>
			<thead>
				<tr>
					<th>PID</th>
					<th>Status</th>
					<th>Advisor</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_phd" action="ph_d.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="10"></th>
						<th><select name="STATUS" form="insert_phd">
								<option value="Ph.D Candidiate">Ph.D Candidiate</option>
								<option value="Pre-Candidacy">Pre-Candidacy</option>
							</select></th>
						<th><input value="" name="ADVISOR" size="15"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ) {
				%>
						<tr>
							<form id="update_phd" action="ph_d.jsp" method="post">
								<input type="hidden" value="update" name="action">
								<td><input value="<%= rs.getString("PID") %>" name="PID" size="10"></td>
								<td><select name="STATUS" form="update_phd">
									<option value="Ph.D Candidiate" <% if(rs.getString("status").equals("Ph.D Candidiate")) out.println("selected"); %> >Ph.D Candidiate</option>
									<option value="Pre-Candidacy" <% if(rs.getString("status").equals("Pre-Candidacy")) out.println("selected"); %> >Pre-Candidacy</option>
									</select></td>
								<td><input value="<%= rs.getString("faculty_name") %>" name="ADVISOR" size="15"></td>
								<td><input type="submit" value="Update"></td>
							</form>
							<form id="delete_phd" action="ph_d.jsp" method="post">
								<input type="hidden" value="delete" name="action">
								<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
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