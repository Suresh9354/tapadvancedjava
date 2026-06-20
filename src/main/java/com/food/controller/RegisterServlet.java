package com.food.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.food.DAOImpl.UserDAOImpl;
import com.food.Model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet("/register")
public class RegisterServlet extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		String password = req.getParameter("password");
		String address = req.getParameter("address");
		
		String hashpw = BCrypt.hashpw(password, BCrypt.gensalt(12));
		
		UserDAOImpl userDAOImpl = new UserDAOImpl();
		
		User existingUser = userDAOImpl.getUserByEmail(email);

        HttpSession session = req.getSession();

        if(existingUser != null){

        	session.setAttribute("error", "Email Already Registered");

            resp.sendRedirect("register.jsp");
            return;
        }
		
        User user = new User();
        
        user.setName(name);
        user.setEmail(email);
        user.setPassword(hashpw);
        user.setAddress(address);
        user.setRole("customer");
        
        userDAOImpl.addUser(user);
        
        resp.sendRedirect("restaurant");
	}
	
}
