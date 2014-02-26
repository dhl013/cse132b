package com.cse132bServlets;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

import cse132b.DBConn;

/**
 * Servlet implementation class Grade_Report
 */
public class Grade_Report extends HttpServlet {
	private static final long serialVersionUID = 1L;

       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Grade_Report() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String PID = request.getParameter("PID");
		String pid = "PID";
		String first = "first_name",
				last = "last_name",
				middle = "middle_name",
				course = "course_number",
				title = "class_title",
				grade = "grade",
				units = "units",
				q_id = "q_id";

		DBConn db = new DBConn();
		db.openConnection();
		
		String query = "SELECT s.PID, s.first_name, s.middle_name, s.last_name, c.course_number, c.class_title, ct.grade, ct.units, ct.q_id " +
						"FROM Student s, Class c, Course_taken ct, Section st " +
						"WHERE s.pid = '"+PID+"' " +
						"AND   ct.pid = s.pid " +
						"AND   st.section_id = ct.section_id " +
						"AND   c.class_title = st.class_title " +
						"AND   c.course_number = st.course_number " +
						"ORDER BY q_id ";
		
		db.executeQuery(query);
		ResultSet rs = db.getResultSet();
		JsonObject jsData = new JsonObject();
		
		int index = 0;
		try{
			while( rs.next() ){
				JsonObject row = new JsonObject();
				row.add(pid, new JsonPrimitive(rs.getString(pid)));
				row.add(first, new JsonPrimitive(rs.getString(first)));
				row.add(middle,new JsonPrimitive(rs.getString(middle)));
				row.add(last, new JsonPrimitive(rs.getString(last)));
				row.add(course, new JsonPrimitive(rs.getString(course)));
				row.add(title, new JsonPrimitive(rs.getString(title)));
				row.add(grade, new JsonPrimitive(rs.getString(grade)));
				row.add(units, new JsonPrimitive(rs.getInt(units)));
				row.add(q_id, new JsonPrimitive(rs.getString(q_id)));
				
				jsData.add(Integer.toString(index++),row);
				
			}
		}
		catch (Exception e){
			e.printStackTrace();
			System.out.println("Grade Report Exeception");
			
		}
		
		 // Write response data as JSON.
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    try {

	    	response.getWriter().write(jsData.toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    db.closeConnections();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
