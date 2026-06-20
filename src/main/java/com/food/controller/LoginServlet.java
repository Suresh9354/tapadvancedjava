package com.food.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.food.DAOImpl.UserDAOImpl;
import com.food.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String email = req.getParameter("email");

        String password = req.getParameter("password");
        
        HttpSession session = req.getSession();
        

        UserDAOImpl userDAO = new UserDAOImpl();

        User user = userDAO.getUserByEmail(email);
        
        String showpwd = user.getPassword();

        if(BCrypt.checkpw(password, showpwd)) {


            session.setAttribute( "loggedInUser", user);

            resp.sendRedirect("restaurant");

        } else {

            req.setAttribute( "error", "Invalid Email or Password");

            req.getRequestDispatcher( "login.jsp").forward(req, resp);
        }
    }
}

