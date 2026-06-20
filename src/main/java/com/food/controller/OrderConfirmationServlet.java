package com.food.controller;

import java.io.IOException;

import com.food.DAOImpl.OrderDAOImpl;
import com.food.Model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orderConfirmation")
public class OrderConfirmationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Must be logged in
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Read orderId from query string  e.g. /orderConfirmation?id=5
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect("restaurant");
            return;
        }

        int orderId = Integer.parseInt(idParam);

        // Fetch full order (with items) from DB
        OrderDAOImpl orderDAO = new OrderDAOImpl();
        Order order = orderDAO.getOrderById(orderId);

        if (order == null) {
            resp.sendRedirect("restaurant");
            return;
        }

        req.setAttribute("order", order);
        req.getRequestDispatcher("order-confirmation.jsp").forward(req, resp);
    }
}
