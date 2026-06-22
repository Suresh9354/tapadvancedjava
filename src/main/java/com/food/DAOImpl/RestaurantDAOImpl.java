package com.food.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.food.DAO.RestaurantDAO;
import com.food.Model.Restaurant;
import com.food.Util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

	private Connection con;
	
	public RestaurantDAOImpl() {
        con = DBConnection.getConnection();
    }
	
	@Override
	public void addRestaurant(Restaurant restaurant) {
		String sql = "INSERT INTO Restaurant"
				+ "(Name,CuisineType,DeliveryTime,Address,Rating,IsActive,ImagePath) VALUES(?,?,?,?,?,?,?)";
		
		try {
			PreparedStatement pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, restaurant.getName());
			pstmt.setString(2, restaurant.getCuisineType());
			pstmt.setInt(3, restaurant.getDeliveryTime());
			pstmt.setString(4, restaurant.getAddress());
			pstmt.setDouble(5, restaurant.getRating());
			pstmt.setBoolean(6, restaurant.getIsActive());
			pstmt.setString(7, restaurant.getImagePath());
			
			pstmt.executeUpdate();
			
			System.out.println("Restaurant Added Successfully");
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public Restaurant getRestaurant(int restaurantId) {
		Restaurant restaurant = null;

        String sql = "SELECT * FROM Restaurant WHERE RestaurantID=?";

        try {

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, restaurantId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                restaurant = new Restaurant();

                restaurant.setRestaurantId(rs.getInt("RestaurantID"));
                restaurant.setName(rs.getString("Name"));
                restaurant.setCuisineType(rs.getString("CuisineType"));
                restaurant.setDeliveryTime(rs.getInt("DeliveryTime"));
                restaurant.setAddress(rs.getString("Address"));
                restaurant.setRating(rs.getDouble("Rating"));
                restaurant.setActive(rs.getBoolean("IsActive"));
                restaurant.setImagePath(rs.getString("ImagePath"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return restaurant;
	}

	@Override
	public List<Restaurant> getAllRestaurants() {
		List<Restaurant> list = new ArrayList<>();

        String sql = "SELECT * FROM Restaurant";

        try {

            Statement st = con.createStatement();

            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {

                Restaurant restaurant = new Restaurant();

                restaurant.setRestaurantId(rs.getInt("RestaurantID"));
                restaurant.setName(rs.getString("Name"));
                restaurant.setCuisineType(rs.getString("CuisineType"));
                restaurant.setDeliveryTime(rs.getInt("DeliveryTime"));
                restaurant.setAddress(rs.getString("Address"));
                restaurant.setRating(rs.getDouble("Rating"));
                restaurant.setActive(rs.getBoolean("IsActive"));
                restaurant.setImagePath(rs.getString("ImagePath"));

                list.add(restaurant);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
	}

	@Override
    public void updateRestaurant(Restaurant restaurant) {

        String sql = "UPDATE Restaurant SET Name=?, CuisineType=?, DeliveryTime=?, Address=?, Rating=?, IsActive=?, ImagePath=? WHERE RestaurantID=?";

        try {

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setDouble(5, restaurant.getRating());
            ps.setBoolean(6, restaurant.getIsActive());
            ps.setString(7, restaurant.getImagePath());
            ps.setInt(8, restaurant.getRestaurantId());

            ps.executeUpdate();

            System.out.println("Restaurant Updated Successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        String sql = "DELETE FROM Restaurant WHERE RestaurantID=?";

        try {

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, restaurantId);

            ps.executeUpdate();

            System.out.println("Restaurant Deleted Successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public List<Restaurant> getTopRestaurants() {

        List<Restaurant> restaurants =
                new ArrayList<>();

        String sql =
                "SELECT * FROM Restaurant ORDER BY Rating DESC LIMIT 4";

        try {

            PreparedStatement pstmt =
                    con.prepareStatement(sql);

            ResultSet rs =
                    pstmt.executeQuery();

            while(rs.next()) {

                Restaurant r = new Restaurant();

                r.setRestaurantId(
                        rs.getInt("RestaurantID"));

                r.setName(
                        rs.getString("Name"));

                r.setCuisineType(
                        rs.getString("CuisineType"));

                r.setDeliveryTime(
                        rs.getInt("DeliveryTime"));

                r.setAddress(
                        rs.getString("Address"));

                r.setRating(
                        rs.getDouble("Rating"));

                r.setImagePath(
                        rs.getString("ImagePath"));

                restaurants.add(r);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return restaurants;
    }

	
}
