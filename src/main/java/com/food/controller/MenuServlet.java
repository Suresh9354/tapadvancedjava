package com.food.controller;

import java.io.IOException;
import java.util.List;

import com.food.DAOImpl.MenuDAOImpl;
import com.food.Model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/menu")
public class MenuServlet extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
		
		int RestaurantID = Integer.parseInt(req.getParameter("RestaurantID"));
		
		List<Menu> menuByRestaurantId = menuDAOImpl.getMenuByRestaurantId(RestaurantID);

		req.setAttribute("menuByRestaurantId", menuByRestaurantId);
		
		// Store restaurantId in session so CheckoutServlet can use it for Orders table
		req.getSession().setAttribute("currentRestaurantId", RestaurantID);
		
		RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
		
		rd.forward(req, resp);
	}
}
