package com.food.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.food.DAOImpl.OrderDAOImpl;
import com.food.Model.CartItem;
import com.food.Model.Order;
import com.food.Model.OrderItem;
import com.food.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    // ── GET /checkout ─────────────────────────────────────────────────────────
    // Show the checkout page with the current cart summary
    @Override
    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // 1. Must be logged in
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 2. Cart must not be empty
        HashMap<Integer, CartItem> cart =
                (HashMap<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect("cart");
            return;
        }

        // 3. Calculate grand total
        double grandTotal = 0;
        for (CartItem item : cart.values()) {
            grandTotal += item.getSubTotal();
        }

        req.setAttribute("cart", cart);
        req.setAttribute("grandTotal", grandTotal);

        // 4. Pre-fill the user's address
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        req.setAttribute("userAddress", loggedInUser.getAddress());

        req.getRequestDispatcher("checkout.jsp").forward(req, resp);
    }

    // ── POST /checkout ────────────────────────────────────────────────────────
    // Place the order: save to DB, clear cart, redirect to confirmation
    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // 1. Session / login guard
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        HashMap<Integer, CartItem> cart =
                (HashMap<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect("cart");
            return;
        }

        // 2. Read form fields
        String paymentMethod = req.getParameter("paymentMethod");
        // Null-safe: default to COD if radio somehow missing
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "COD";
        }

        // 3. Build Order object
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // ✅ Get restaurantId from the FIRST cart item (stored there from menu.jsp)
        // This is reliable — the session attribute was previously null (causing FK failure)
        int restaurantId = 0;
        for (CartItem item : cart.values()) {
            if (item.getRestaurantId() > 0) {
                restaurantId = item.getRestaurantId();
                break;
            }
        }

        double grandTotal = 0;
        for (CartItem item : cart.values()) {
            grandTotal += item.getSubTotal();
        }

        Order order = new Order();
        order.setUserId(loggedInUser.getUserId());
        order.setRestaurantId(restaurantId);
        order.setTotalAmount(grandTotal);
        order.setPaymentMethod(paymentMethod);
        order.setStatus("Pending");

        // 4. Build OrderItem list from cart
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cart.values()) {
            OrderItem oi = new OrderItem();
            oi.setMenuId(cartItem.getMenuId());
            oi.setQuantity(cartItem.getQuantity());
            oi.setItemTotal(cartItem.getSubTotal());     // price × qty → ItemTotal column
            oi.setItemName(cartItem.getItemName());      // display only
            oi.setUnitPrice(cartItem.getPrice());        // display only
            orderItems.add(oi);
        }
        order.setItems(orderItems);

        // 5. Persist to DB
        OrderDAOImpl orderDAO = new OrderDAOImpl();
        int orderId = orderDAO.placeOrder(order);

        if (orderId == -1) {
            // DB error — re-forward to checkout.jsp with all required attributes
            req.setAttribute("error", "Order could not be placed. Please try again.");
            req.setAttribute("cart", cart);
            req.setAttribute("grandTotal", grandTotal);
            // ✅ FIX: also set userAddress so checkout.jsp doesn't throw NPE
            req.setAttribute("userAddress", loggedInUser.getAddress() != null ? loggedInUser.getAddress() : "");
            req.getRequestDispatcher("checkout.jsp").forward(req, resp);
            return;
        }

        // 6. Clear the cart from session
        session.removeAttribute("cart");
        session.removeAttribute("currentRestaurantId");

        // 7. Redirect to confirmation page
        resp.sendRedirect("orderConfirmation?id=" + orderId);
    }
}
