package com.food.DAO;

import java.util.List;

import com.food.Model.User;

public interface UserDAO {
	
	void addUser(User user);
	
	User getUser(int id);
	
	List<User> getAllUser();
	
	void updateUser(User user);
	
	void deleteUser(int id);
	
	User getUserByEmail(String email);
	
	

}
