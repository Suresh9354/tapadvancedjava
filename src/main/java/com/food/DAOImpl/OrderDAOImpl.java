package com.food.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.food.DAO.OrderDAO;
import com.food.Model.Order;
import com.food.Model.OrderItem;
import com.food.Util.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    // SQL Queries — column names must EXACTLY match your DB schema
    private static final String INSERT_ORDER =
            "INSERT INTO ordertable (UserID, RestaurantID, OrderDate, TotalAmount, Status, PaymentMethod) "
          + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String INSERT_ORDER_ITEM =
            "INSERT INTO orderitem (OrderID, MenuID, Quantity, ItemTotal) "
          + "VALUES (?, ?, ?, ?)";

    private static final String GET_ORDER_BY_ID =
            "SELECT * FROM ordertable WHERE OrderID = ?";

    private static final String GET_ITEMS_BY_ORDER_ID =
            "SELECT * FROM orderitem WHERE OrderID = ?";

    // ── placeOrder ────────────────────────────────────────────────────────────

    @Override
    public int placeOrder(Order order) {

        int generatedOrderId = -1;

        // ✅ FIX 1: Get a FRESH connection inside the method every time
        // The static shared connection from other DAOs may be stale/closed
        Connection con = DBConnection.getConnection();

        // ✅ FIX 2: Null-check the connection before using it
        if (con == null) {
            System.err.println("[OrderDAOImpl] ERROR: Could not get DB connection. Check DBConnection.java credentials.");
            return -1;
        }

        try {
            // STEP 1: Insert the Order header row
            PreparedStatement orderStmt =
                    con.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS);

            orderStmt.setInt(1, order.getUserId());
            orderStmt.setInt(2, order.getRestaurantId());
            orderStmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            orderStmt.setDouble(4, order.getTotalAmount());
            orderStmt.setString(5, "Pending");
            orderStmt.setString(6, order.getPaymentMethod());

            System.out.println("[OrderDAOImpl] Inserting order: UserID=" + order.getUserId()
                    + " RestaurantID=" + order.getRestaurantId()
                    + " Total=" + order.getTotalAmount()
                    + " Payment=" + order.getPaymentMethod());

            int rows = orderStmt.executeUpdate();

            if (rows > 0) {
                // STEP 2: Get the auto-generated OrderID
                ResultSet keys = orderStmt.getGeneratedKeys();
                if (keys.next()) {
                    generatedOrderId = keys.getInt(1);
                    System.out.println("[OrderDAOImpl] Order inserted. Generated OrderID = " + generatedOrderId);
                }
            }

            // STEP 3: Insert each OrderItem row using batch
            if (generatedOrderId != -1 && order.getItems() != null && !order.getItems().isEmpty()) {

                PreparedStatement itemStmt = con.prepareStatement(INSERT_ORDER_ITEM);

                for (OrderItem item : order.getItems()) {
                    itemStmt.setInt(1, generatedOrderId);
                    itemStmt.setInt(2, item.getMenuId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getItemTotal()); // price × qty
                    itemStmt.addBatch();

                    System.out.println("[OrderDAOImpl] Adding orderitem: MenuID=" + item.getMenuId()
                            + " Qty=" + item.getQuantity()
                            + " ItemTotal=" + item.getItemTotal());
                }

                itemStmt.executeBatch();
                System.out.println("[OrderDAOImpl] All order items inserted successfully.");
            }

        // ✅ FIX 3: Catch ALL exceptions — not just SQLException
        // NullPointerException (on null con), NumberFormatException, etc.
        } catch (SQLException e) {
            System.err.println("[OrderDAOImpl] SQLException in placeOrder: " + e.getMessage());
            System.err.println("[OrderDAOImpl] SQL State: " + e.getSQLState() + " | Error Code: " + e.getErrorCode());
            e.printStackTrace();
            generatedOrderId = -1;

        } catch (Exception e) {
            System.err.println("[OrderDAOImpl] Unexpected error in placeOrder: " + e.getMessage());
            e.printStackTrace();
            generatedOrderId = -1;
        }

        return generatedOrderId;
    }

    // ── getOrderById ─────────────────────────────────────────────────────────

    @Override
    public Order getOrderById(int orderId) {

        Order order = null;

        // ✅ FIX 1 (same): Fresh connection per method call
        Connection con = DBConnection.getConnection();

        if (con == null) {
            System.err.println("[OrderDAOImpl] ERROR: Could not get DB connection in getOrderById.");
            return null;
        }

        try {
            // Fetch the Order header
            PreparedStatement orderStmt = con.prepareStatement(GET_ORDER_BY_ID);
            orderStmt.setInt(1, orderId);
            ResultSet rs = orderStmt.executeQuery();

            if (rs.next()) {
                order = new Order();
                order.setOrderId(rs.getInt("OrderID"));
                order.setUserId(rs.getInt("UserID"));
                order.setRestaurantId(rs.getInt("RestaurantID"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setStatus(rs.getString("Status"));
                order.setPaymentMethod(rs.getString("PaymentMethod"));
            }

            // Fetch the OrderItems
            if (order != null) {
                PreparedStatement itemStmt = con.prepareStatement(GET_ITEMS_BY_ORDER_ID);
                itemStmt.setInt(1, orderId);
                ResultSet itemRs = itemStmt.executeQuery();

                List<OrderItem> items = new ArrayList<>();
                while (itemRs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(itemRs.getInt("OrderItemID"));
                    item.setOrderId(itemRs.getInt("OrderID"));
                    item.setMenuId(itemRs.getInt("MenuID"));
                    item.setQuantity(itemRs.getInt("Quantity"));
                    item.setItemTotal(itemRs.getDouble("ItemTotal"));
                    items.add(item);
                }

                order.setItems(items);
            }

        } catch (SQLException e) {
            System.err.println("[OrderDAOImpl] SQLException in getOrderById: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("[OrderDAOImpl] Unexpected error in getOrderById: " + e.getMessage());
            e.printStackTrace();
        }

        return order;
    }
}
