package com.food.DAOImpl;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import com.food.DAO.UserDAO;
import com.food.Model.User;
import com.food.Util.DBConnection;



public class UserDAOImpl implements UserDAO{
	
	private  Connection connection;
	
	private static final String INSERT_QUERY = "INSERT INTO User(Username,Email,Password,Address,Role) VALUES(?,?,?,?,?)";
	
	private static final String GET_USER_BY_EMAIL = "SELECT * FROM User WHERE Email=?";
	
	public UserDAOImpl() {
        connection = DBConnection.getConnection();
        System.out.println("UserDAOImpl Connection = " + connection);
    }
	
	@Override
	public void addUser(User user) {
		try {
			PreparedStatement ps = connection.prepareStatement(INSERT_QUERY);
			
			ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getRole());

            int result = ps.executeUpdate();

            if(result > 0) {
                System.out.println("User Added Successfully");
            } else {
                System.out.println("User Not Added");
            }
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public User getUser(int id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<User> getAllUser() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateUser(User user) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteUser(int id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public User getUserByEmail(String email) {
		
		 User user = null;

	        try {

	            PreparedStatement pstmt =
	                    connection.prepareStatement(GET_USER_BY_EMAIL);

	            pstmt.setString(1, email);

	            ResultSet rs = pstmt.executeQuery();

	            if(rs.next()) {

	                user = new User();

	                user.setUserId(rs.getInt("UserID"));
	                user.setName(rs.getString("Username"));
	                user.setEmail(rs.getString("Email"));
	                user.setPassword(rs.getString("Password"));
	                user.setAddress(rs.getString("Address"));
	                user.setRole(rs.getString("Role"));
	            }

	        } catch(Exception e) {
	            e.printStackTrace();
	        }

	        return user;
	}

}
