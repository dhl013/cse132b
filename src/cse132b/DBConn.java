package cse132b;

import java.sql.*;


public class DBConn {
	
	private static final boolean DEBUG = true;
	
	private String connectionUrl;
	public Connection conn;
	public Statement stmt;
	public ResultSet rs;
	
	//Constructor -- Create DBConn with variables instantiated
	//Store default variables here, can create this object
	//In each servlet page without having to repeat variables
	public DBConn(){
		//Create a variable for the connection string.
		this.connectionUrl = "jdbc:sqlserver://localhost:1433;" +
		   "databaseName=CSE132B; username=sa; password=cse132b";

		// Declare the JDBC objects.
		this.conn = null;
		this.stmt = null;
		this.rs = null;
	}
	
	public void openConnection(){
		try {
			   // Establish the connection.
			   Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			   this.conn = DriverManager.getConnection(this.connectionUrl);
			   this.stmt = this.conn.createStatement();
			   if(DEBUG) System.out.println("Connection to DB initalized.");
		}
			// Handle any errors that may have occurred.
			catch (Exception e) {
			   e.printStackTrace();
			   if(DEBUG) System.out.println("Connection to DB failed.");
			}

	}
	
	public void closeConnections(){
			try {
				if( null != this.rs ) this.rs.close();
				if( null != this.stmt ) this.stmt.close();
				if( null != this.conn ) this.conn.close();
				if(DEBUG) System.out.println("Connection to DB closed.");
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}
	
	public void executeQuery(String query){
		try {
			this.rs = this.stmt.executeQuery(query);
		} catch (SQLException e) {
			e.printStackTrace();
			if(DEBUG){ System.out.println("Query failed to execute:");
					   System.out.println(query);
			}
		}
	}
	
	public PreparedStatement getPreparedStatment(String statement){
		try {
			this.conn.setAutoCommit(false);
			PreparedStatement pstmt = this.conn.prepareStatement(statement);	
			return pstmt;
			
		} catch (SQLException e) {
			e.printStackTrace();
			if(DEBUG) System.out.println("Failed to create PreparedStatement.");
		}
		System.out.println("no");
		return null;
	}
	
	public boolean executePreparedStatement(PreparedStatement pstmt){
		boolean success = false;
		try{
			pstmt.executeUpdate();
			this.conn.commit();
			this.conn.setAutoCommit(true);
			success = true;
			return success;
		}
		catch (SQLException e) {
			e.printStackTrace();
			if(DEBUG){ System.out.println("Failed to execute prepared statement");
					   System.out.println(pstmt.toString());
			}
		}
		return success;
	}
	
	public ResultSet getResultSet(){
		return this.rs;
	}
	
	public Statement getStatement(){
		try {
			return this.conn.createStatement();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

}
