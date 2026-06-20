package com.food.DAO;

import java.util.List;

import com.food.Model.Restaurant;

public interface RestaurantDAO {
	
	void addRestaurant(Restaurant restaurant);

    Restaurant getRestaurant(int restaurantId);

    List<Restaurant> getAllRestaurants();
    
    List<Restaurant> getTopRestaurants();

    void updateRestaurant(Restaurant restaurant);

    void deleteRestaurant(int restaurantId);
}
