package com.cse132bServlets;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import cse132b.DBConn;

/**
 * Servlet implementation class Course_section
 */
public class Course_section extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Course_section() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String type = request.getParameter("type");
		if( type.equals("section")){
			DBConn db = new DBConn();
			db.openConnection();
			String course = request.getParameter("value");
			
			String query = "SELECT s.section_id, t.starting_time, wk.w_type, md.day " +
						   "FROM Section s, Meeting_time mt, Time_table t, Weekly_meeting wk, Meeting_Day md " +
						   "WHERE s.course_number ='" + course + "'" +
						   "AND   s.section_id = mt.section_id " +
						   "AND   mt.t_id = t.t_id "+
						   "AND   wk.section_id = s.section_id " +
						   "AND   md.section_id = s.section_id ";
			
			db.executeQuery(query);
			ResultSet rs = db.getResultSet();
		    Map<String, Object> data = new HashMap<String, Object>();
	
		    try {
				while( rs.next() ){
					data.put(rs.getString("section_id"), rs.getString("starting_time") + " -- " 
							+ rs.getString("w_type") + " -- " + rs.getString("day"));
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		     
		    // Write response data as JSON.
		    response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    try {
				response.getWriter().write(new Gson().toJson(data));
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if(type.equals("units")){
			DBConn db = new DBConn();
			db.openConnection();
			String course = request.getParameter("value");
			
			String query = "SELECT * FROM Course_units cu WHERE cu.course_number='" + course +"'";
			db.executeQuery(query);
			ResultSet rs = db.getResultSet();
		    Map<String, Object> data = new HashMap<String, Object>();
	
		    try {
				while( rs.next() ){
					data.put(rs.getString("course_number"), rs.getInt("unit"));
					data.put("variable", rs.getBoolean("up_to"));
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		     
		    // Write response data as JSON.
		    response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    try {
				response.getWriter().write(new Gson().toJson(data));
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
