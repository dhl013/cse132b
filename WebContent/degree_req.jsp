<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="test/css" href="css/student.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Degree Requirement Modification Page</title>
</head>
<%@ page language="java" import="cse132b.DBConn" %>
<%@ page import="java.sql.*" %>
<%
	DBConn db = new DBConn();
	db.openConnection();
	PreparedStatement pstmt;
	
	String degree_level = "";
	String level_name = "";
	String degree_of = "";
	
%>
<!-- DEGREE_REQ INSERTION CODE -->
<%
	String action = request.getParameter("action");
	if( null != action && action.equals("insert") ){
		String degree_req_insert = "INSERT INTO Degree VALUES (?,?,?)";
		
		String deg_title = request.getParameter("DEGREE_TITLE");
		
		pstmt = db.getPreparedStatment(degree_req_insert);
		
		pstmt.setString(1, deg_title);
		pstmt.setString(2, request.getParameter("DEGREE_LEVEL"));
		pstmt.setInt(3, Integer.parseInt(request.getParameter("REQUIRED_UNITS")) );

		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
		
		///// DEGREE_???? PART /////
		
		degree_level = request.getParameter("DEGREE_LEVEL");		
		
		if(degree_level.toString().equals("BS")) {
			degree_of = "Degree_Category";
			level_name = "cat_name";
		}
		
		else if(degree_level.toString().equals("MS")) {
			degree_of = "Degree_Concentration";
			level_name = "con_name";
		}
		
		if(!degree_level.toString().equals("Ph.D")) {
			String deg_part = "INSERT INTO " + degree_of + " VALUES (?,?)";
			pstmt = db.getPreparedStatment(deg_part);
			String[] belong_deg = request.getParameter("REQUIRED_PARTS").split(",");
			for(String part : belong_deg){
				pstmt.setString(1, deg_title);
				pstmt.setString(2, part);
				success = db.executePreparedStatement(pstmt);
				System.out.println("Executed PreparedStatment for Degree_???? with a success of : " + success);
			}
		}
		////// END of DEGREE_???? PART ///// 
		
	}
%>
<!-- DEGREE_REQ UPDATE CODE -->
<%
	if( null != action && action.equals("update") ){

		String degree_req_update = "UPDATE Degree SET deg_title = ?, required_units = ? " +
								   "WHERE deg_title = ?";
		
		String deg_title = request.getParameter("DEGREE_TITILE");
		
		pstmt = db.getPreparedStatment(degree_req_update);

		pstmt.setString(1, deg_title);
		pstmt.setInt(2, Integer.parseInt(request.getParameter("REQUIRED_UNITS")) );
		pstmt.setString(3, deg_title);
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);
	}
%>
<!-- DEGREE_REQ DELETE CODE -->
<%	//// NOT WORKING YET ////
	if( null != action && action.equals("delete") ){
		String degree_req_delete = "DELETE FROM Degree " +
					                     "WHERE deg_title = ?";

		String deg_title = request.getParameter("DEGREE_TITLE");
		
		pstmt = db.getPreparedStatment(degree_req_delete);

		pstmt.setString(1, deg_title);
		
		boolean success = db.executePreparedStatement(pstmt);
		System.out.println("Executed PreparedStatement with a success of : " + success);		
	}
%>
<!-- PAGE INITALIZATION CODE -->
<%
	String parts = "";
	String query = "SELECT * FROM Degree";
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
			<a href="category.jsp" id="banner-link">Degree->Category</a>
		</div>
	</div>
	
	<div id="form-table">
		<table>
			<thead>
				<tr>
					<th>Degree</th>
					<th>Degree Level</th>
					<th>Required Unit</th>
					<th>Required Categories/Concentrations</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<form id="insert_degree_req" action="degree_req.jsp" method="post">
						<input type="hidden" value="insert" name="action">
						<th><input value="" name="DEGREE_TITLE" size="30"></th>
						<th><select name="DEGREE_LEVEL" form="insert_degree_req">
								<option value="BS">BS</option>
								<option value="MS">MS</option>
								<option value="Ph.D">Ph.D</option>
							</select></th>
						<th><input value="" name="REQUIRED_UNITS" size="20"></th>
						<th><input value="" name="REQUIRED_PARTS" size="80"></th>
						<th><input type="submit" value="Insert"></th>
					</form>
				</tr>
				<%
					while( rs.next() ){	
				%>
					<tr>
						<form id="update_degree_req" action="degree_req.jsp" method="post">
							<input type="hidden" value="update" name="action">
							<td><input value="<%= rs.getString("deg_title") %>" name="DEGREE_TITLE" size="30"></td>
							<td><select name="DEGREE_LEVEL" form="update_degree_req">
									<option value="BS" <% if(rs.getString("deg_level").equals("BS")) { 
															out.println("selected"); 
															degree_of = "Degree_Category"; 
															level_name = "cat_name";
														  } %> >BS</option>
									<option value="MS" <% if(rs.getString("deg_level").equals("MS")) { 
															out.println("selected"); 
															degree_of = "Degree_Concentration";
															level_name = "con_name";
														  } %> >MS</option>
									<option value="Ph.D" <% if(rs.getString("deg_level").equals("Ph.D")) { 
															out.println("selected");
															degree_of = "NULL";
															level_name = "NULL";
														  } %> >Ph.D</option>
							</select></td>
							<td><input value="<%= rs.getString("required_units") %>" name="REQUIRED_UNITS" size="20"></td>
							<%
							   if(!degree_of.equals("NULL")) {
									Statement stmt = db.getStatement();
									query = "SELECT * FROM " + degree_of + " WHERE deg_title='" + rs.getString("deg_title") +"'";  
									ResultSet fdrs = stmt.executeQuery(query);
									StringBuilder builder = new StringBuilder();
									while( fdrs.next() ){
										builder.append(fdrs.getString(level_name));
										builder.append(",");
									}
									parts = builder.toString();
							   }
								
							%>
							<td><input value="<%= parts.substring(0, parts.length() -1 ) %>" name="REQUIRED_PARTS" size="80"></td>
							<td><input type="submit" value="Update" disabled></td>
						</form>
						<form id="delete_degree_req" action="degree_req.jsp" method="post">
							<input type="hidden" value="delete" name="action">
							<input type="hidden" value="<%= rs.getString("deg_title") %>" name="DEGREE_TITLE">
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