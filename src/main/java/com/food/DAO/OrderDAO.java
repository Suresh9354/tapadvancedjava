package com.food.DAO;

import com.food.Model.Order;

public interface OrderDAO {

    /**
     * Inserts an Order row and all its OrderItem rows into the database.
     * The Order object must already have its items list populated.
     *
     * @param order the order to persist (with items list attached)
     * @return the generated OrderID, or -1 on failure
     */
    int placeOrder(Order order);

    /**
     * Fetches an order plus its items by orderId.
     *
     * @param orderId the primary key
     * @return the Order with items list populated, or null if not found
     */
    Order getOrderById(int orderId);
}
