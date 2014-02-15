<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Thesis_Committee Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
%>
<!-- THESIS COMMITTEE INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String thesis_committee_insert = "INSERT INTO Thesis_committee VALUES (?,?,?)";
		
		String pid = request.getParameter("PID");
		String comm_pid = request.getParameter("COMMITTEE_ID");
		
		pstmt = db.getPreparedStatment(thesis_committee_insert);
		
		pstmt.setString(1, pid);
		pstmt.setString(2, comm_pid);
		pstmt.setString(3, request.getParameter("THESIS"));

		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
		String comm_member = "INSERT INTO Committee_Member VALUES (?,?,?)";
		pstmt = db.getPreparedStatment(comm_member);
		String[] in_committee = request.getParameter("IN_COMMITTEE").split(",");
		for(String member : in_committee){
			pstmt.setString(1, pid);
			pstmt.setString(2, comm_pid);
			pstmt.setString(3, member);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Committee Member with a success of : " + success);
		}
	}
%>
<!-- THESIS COMMITTEE UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){

		String thesis_committee_update = "UPDATE Thesis_committee SET PID = ?, " +
								         "committee_id = ?, thesis = ?" +
								    	 "WHERE PID = ?, committee_id = ?";
		
		String pid = request.getParameter("PID");
		String comm_pid = request.getParameter("COMMITTEE_ID");
		
		pstmt = db.getPreparedStatment(thesis_committee_update);

		pstmt.setString(1, pid );
		pstmt.setString(2, comm_pid );
		pstmt.setString(3, request.getParameter("THESIS") );
		pstmt.setString(4, pid );
		pstmt.setString(5, comm_pid );

		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
		
		String comm_member_update = "UPDATE INTO Committee_Member SET PID = ?, " +
									"committee_id = ?, faculty_name = ? " +
									"WHERE PID = ? AND committee_id = ? AND faculty_name = ?";
		
		pstmt = db.getPreparedStatment(comm_member_update);
		
		String[] in_committee = request.getParameter("IN_COMMITTEE").split(",");
		for(String member : in_committee){
			pstmt.setString(1, pid);
			pstmt.setString(2, comm_pid);
			pstmt.setString(3, member);
			pstmt.setString(4, pid);
			pstmt.setString(5, comm_pid);
			pstmt.setString(6, member);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Committee Member with a success of : " + success);
		}
	}
%>
<!-- FACULTY DELETE CODE -->
<%
	if( null != action && action.equals("delete") ){
		String thesis_committee_update = "DELETE FROM Thesis_committee " +
					                     "WHERE PID = ?, committee_id = ?";

		String pid = request.getParameter("PID");
		String comm_pid = request.getParameter("COMMITTEE_ID");
		
		pstmt = db.getPreparedStatment(thesis_committee_update);

		pstmt.setString(1, pid );
		pstmt.setString(2, comm_pid );
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
		
		String comm_member_update = "DELETE FROM Committee_Member " +
									"WHERE PID = ? AND committee_id = ? AND faculty_name = ?";
		
		pstmt = db.getPreparedStatment(comm_member_update);
		
		String[] in_committee = request.getParameter("IN_COMMITTEE").split(",");
		for(String member : in_committee){
			pstmt.setString(1, pid);
			pstmt.setString(2, comm_pid);
			pstmt.setString(3, member);
			success = db.executePreparedStatement(pstmt);
			System.out.println("Executed PreparedStatment for Committee Member with a success of : " + success);
		}		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String in_committee;
	String query = "SELECT * FROM Thesis_committee";
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
			<a href="thesis_committee.jsp" id="banner-link">Thesis Committee</a>
		</div>
	</div>
	
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>PID</th>
					<th>Committee_ID</th>
					<th>Professor</th>
					<th>Thesis</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_thesis_committee" action="thesis_committee.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="PID" size="30"></th>
						<th><input value="" name="COMMITTEE_ID" size="20"></th>
						<th><input value="" name="THESIS" size="60"></th>
						<th><input value="" name="PROFESSOR" size="60"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){
				%>
					<tr>
						<form id="update_thesis_committee" action="thesis_commmittee.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("PID") %>" name="PID" size="30"></td>
							<td><input value="<%= rs.getString("commmittee_id") %>" name="COMMITTEE_ID" size="20"></td>
							<td><input value="<%= rs.getString("thesis") %>" name="THESIS" size="60"></td>
							<%
								Statement stmt = db.getStatement();
								query = "SELECT * FROM Committee_Member WHERE PID='" + rs.getString("PID") +"' AND committee_id='" + rs.getString("COMMITTEE_ID") + "' AND thesis='" + rs.getString("THESIS") + "'";  
								ResultSet fdrs = stmt.executeQuery(query);
								StringBuilder builder = new StringBuilder();
								while( fdrs.next() ){
									builder.append(fdrs.getString("in_committee"));
									builder.append(",");
								}
								in_committee = builder.toString();
								
							%>
							<td><input value="<%= in_committee.substring(0, in_committee.length() -1 ) %>" name="PROFESSOR" size="60"></td>
							<td><input type="submit" value="Update" disabled></td>
						</form>
						<form id="delete_thesis_committee" action="thesis_committee.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("PID") %>" name="PID">
							<td><input type="submit" value="Delete" disabled></td>
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