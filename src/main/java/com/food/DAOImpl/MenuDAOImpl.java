package com.food.DAOImpl;

import java.util.ArrayList;
import java.util.List;

import com.food.DAO.MenuDAO;
import com.food.Model.Menu;
import com.food.Util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MenuDAOImpl implements MenuDAO{
	
	private Connection con = DBConnection.getConnection();

	
	public List<Menu> getMenuByRestaurantId(int restaurantId) {
		
		List<Menu> menus = new ArrayList<>();
		
		String sql = "SELECT * FROM Menu WHERE RestaurantID = ?";
		
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			
			ps.setInt(1, restaurantId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("MenuID"));
                menu.setRestaurantId(rs.getInt("RestaurantID"));
                menu.setItemName(rs.getString("ItemName"));
                menu.setDescription(rs.getString("Description"));
                menu.setPrice(rs.getDouble("Price"));
                menu.setAvailable(rs.getBoolean("IsAvailable"));
                menu.setImagePath(rs.getString("ImagePath"));

                menus.add(menu);
            }  
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return menus;
		
	}

}
