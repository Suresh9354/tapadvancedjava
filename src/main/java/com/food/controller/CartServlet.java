package com.food.controller;

import java.io.IOException;
import java.util.HashMap;

import com.food.Model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processCart(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processCart(req, resp);
    }

    @SuppressWarnings("unchecked")
    private void processCart(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Get or create the cart from session
        HashMap<Integer, CartItem> cart =
                (HashMap<Integer, CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
        }

        String action = req.getParameter("action");

        // No action means user just wants to view the cart
        if (action == null) {
            req.setAttribute("cart", cart);
            req.getRequestDispatcher("cart.jsp").forward(req, resp);
            return;
        }

        // All actions require a menuId
        String menuIdParam = req.getParameter("menuId");
        if (menuIdParam == null || menuIdParam.isEmpty()) {
            resp.sendRedirect("cart");
            return;
        }

        int menuId = Integer.parseInt(menuIdParam);

        switch (action) {

            case "add":
                String itemName  = req.getParameter("itemName");
                double price     = Double.parseDouble(req.getParameter("price"));
                String imagePath = req.getParameter("imagePath");

                // Read restaurantId — passed as hidden field from menu.jsp
                int restaurantId = 0;
                String restIdParam = req.getParameter("restaurantId");
                if (restIdParam != null && !restIdParam.isEmpty()) {
                    restaurantId = Integer.parseInt(restIdParam);
                }

                // Swiggy logic: Clear previous restaurant items if adding from a different restaurant
                if (!cart.isEmpty()) {
                    CartItem firstItem = cart.values().iterator().next();
                    if (firstItem.getRestaurantId() != restaurantId) {
                        cart.clear();
                        session.setAttribute("cartAlert", "Your cart was reset because you added items from a different restaurant.");
                    }
                }

                if (cart.containsKey(menuId)) {
                    // Item already in cart → just increment quantity
                    CartItem existing = cart.get(menuId);
                    existing.setQuantity(existing.getQuantity() + 1);
                } else {
                    // New item → build a CartItem and put it in the map
                    CartItem item = new CartItem();
                    item.setMenuId(menuId);
                    item.setRestaurantId(restaurantId);   // ← save restaurantId
                    item.setItemName(itemName);
                    item.setPrice(price);
                    item.setQuantity(1);
                    item.setImagePath(imagePath);
                    cart.put(menuId, item);
                }
                break;

            case "increase":
                if (cart.containsKey(menuId)) {
                    CartItem item = cart.get(menuId);
                    item.setQuantity(item.getQuantity() + 1);
                }
                break;

            case "decrease":
                if (cart.containsKey(menuId)) {
                    CartItem item = cart.get(menuId);
                    if (item.getQuantity() > 1) {
                        item.setQuantity(item.getQuantity() - 1);
                    } else {
                        // quantity would reach 0 → remove the item entirely
                        cart.remove(menuId);
                    }
                }
                break;

            case "remove":
                cart.remove(menuId);
                break;

            default:
                break;
        }

        // Save updated cart back to session
        session.setAttribute("cart", cart);

        // ✅ Redirect to the SERVLET (not cart.jsp directly)
        // This ensures the JSP always gets data passed via the servlet
        resp.sendRedirect("cart");
    }
}