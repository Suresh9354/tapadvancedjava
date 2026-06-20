package com.food.DAO;

import java.util.List;

import com.food.Model.Menu;

public interface MenuDAO {
	
	List<Menu> getMenuByRestaurantId(int restaurantId);

}
