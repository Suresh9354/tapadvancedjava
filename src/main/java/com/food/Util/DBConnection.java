package com.food.Util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	 private static Connection connection;
	 
	private static final String URL = "jdbc:mysql://localhost:3306/food_delivery";

    private static final String USERNAME = "root";

    private static final String PASSWORD = "root";
    
    public static Connection getConnection() {
    	
    	try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return connection;
    	
    }
    
}
