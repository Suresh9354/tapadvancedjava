package com.food.Util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebListener
public class DBInitializerListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[DBInitializerListener] Application starting. Checking database schema...");
        
        try {
            Connection conn = DBConnection.getConnection();
            if (conn == null) {
                System.out.println("[DBInitializerListener] Connection was null. Waiting 3 seconds to retry database connection...");
                Thread.sleep(3000);
                conn = DBConnection.getConnection();
            }

            if (conn != null) {
                initializeDatabase(conn);
            } else {
                System.err.println("[DBInitializerListener] Could not establish database connection. Skipping automatic schema initialization.");
            }
        } catch (Exception e) {
            System.err.println("[DBInitializerListener] Error during database initialization:");
            e.printStackTrace();
        }
    }

    private void initializeDatabase(Connection conn) {
        try {
            // Check for DB_CLEAN environment variable to drop and reset tables
            String dbClean = System.getenv("DB_CLEAN");
            if ("true".equalsIgnoreCase(dbClean)) {
                System.out.println("[DBInitializerListener] DB_CLEAN=true environment variable detected. Dropping existing tables for a clean setup...");
                try (Statement stmt = conn.createStatement()) {
                    // Disable foreign key checks to prevent drop lockups from other tables (like cartitem)
                    stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
                    System.out.println("[DBInitializerListener] Foreign key checks temporarily disabled.");

                    // Drop tables in order of dependency
                    stmt.execute("DROP TABLE IF EXISTS orderitem, orderitemtable, orderitems");
                    stmt.execute("DROP TABLE IF EXISTS ordertable, orders, `order`");
                    stmt.execute("DROP TABLE IF EXISTS Menu, menu");
                    stmt.execute("DROP TABLE IF EXISTS Restaurant, restaurant");
                    stmt.execute("DROP TABLE IF EXISTS User, user");
                    stmt.execute("DROP TABLE IF EXISTS cartitem, category_images"); // Drop any old leftover tables
                    
                    // Re-enable foreign key checks
                    stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
                    System.out.println("[DBInitializerListener] Drop tables completed successfully and foreign key checks re-enabled.");
                } catch (Exception e) {
                    System.err.println("[DBInitializerListener] Error dropping tables: " + e.getMessage());
                    try (Statement stmt = conn.createStatement()) {
                        stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
                    } catch (Exception ex) {
                        // ignore
                    }
                }
            }

            boolean userTableExists = checkTableExists(conn, "User");
            boolean restaurantTableExists = checkTableExists(conn, "Restaurant");
            boolean menuTableExists = checkTableExists(conn, "Menu");
            boolean orderTableExists = checkTableExists(conn, "ordertable");
            boolean orderItemTableExists = checkTableExists(conn, "orderitem");

            try (Statement stmt = conn.createStatement()) {
                // Step 1: Create tables if they do not exist
                if (!userTableExists) {
                    System.out.println("[DBInitializerListener] Creating table: User");
                    stmt.execute(
                        "CREATE TABLE IF NOT EXISTS User (" +
                        "    UserID INT AUTO_INCREMENT PRIMARY KEY," +
                        "    Username VARCHAR(100) NOT NULL," +
                        "    Email VARCHAR(100) NOT NULL UNIQUE," +
                        "    Password VARCHAR(255) NOT NULL," +
                        "    Address TEXT," +
                        "    Role VARCHAR(50) DEFAULT 'Customer'" +
                        ")"
                    );
                }

                if (!restaurantTableExists) {
                    System.out.println("[DBInitializerListener] Creating table: Restaurant");
                    stmt.execute(
                        "CREATE TABLE IF NOT EXISTS Restaurant (" +
                        "    RestaurantID INT AUTO_INCREMENT PRIMARY KEY," +
                        "    Name VARCHAR(100) NOT NULL," +
                        "    CuisineType VARCHAR(100)," +
                        "    DeliveryTime INT," +
                        "    Address TEXT," +
                        "    Rating DECIMAL(3,2)," +
                        "    IsActive BOOLEAN DEFAULT TRUE," +
                        "    ImagePath VARCHAR(255)" +
                        ")"
                    );
                }

                if (!menuTableExists) {
                    System.out.println("[DBInitializerListener] Creating table: Menu");
                    stmt.execute(
                        "CREATE TABLE IF NOT EXISTS Menu (" +
                        "    MenuID INT AUTO_INCREMENT PRIMARY KEY," +
                        "    RestaurantID INT," +
                        "    ItemName VARCHAR(100) NOT NULL," +
                        "    Description TEXT," +
                        "    Price DECIMAL(10,2) NOT NULL," +
                        "    IsAvailable BOOLEAN DEFAULT TRUE," +
                        "    ImagePath VARCHAR(255)," +
                        "    CONSTRAINT fk_menu_restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE CASCADE" +
                        ")"
                    );
                }

                if (!orderTableExists) {
                    System.out.println("[DBInitializerListener] Creating table: ordertable");
                    stmt.execute(
                        "CREATE TABLE IF NOT EXISTS ordertable (" +
                        "    OrderID INT AUTO_INCREMENT PRIMARY KEY," +
                        "    UserID INT," +
                        "    RestaurantID INT," +
                        "    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                        "    TotalAmount DECIMAL(10,2) NOT NULL," +
                        "    Status VARCHAR(50) DEFAULT 'Pending'," +
                        "    PaymentMethod VARCHAR(50)," +
                        "    CONSTRAINT fk_order_user FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE SET NULL," +
                        "    CONSTRAINT fk_order_restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE SET NULL" +
                        ")"
                    );
                }

                if (!orderItemTableExists) {
                    System.out.println("[DBInitializerListener] Creating table: orderitem");
                    stmt.execute(
                        "CREATE TABLE IF NOT EXISTS orderitem (" +
                        "    OrderItemID INT AUTO_INCREMENT PRIMARY KEY," +
                        "    OrderID INT," +
                        "    MenuID INT," +
                        "    Quantity INT NOT NULL," +
                        "    ItemTotal DECIMAL(10,2) NOT NULL," +
                        "    CONSTRAINT fk_item_order FOREIGN KEY (OrderID) REFERENCES ordertable(OrderID) ON DELETE CASCADE," +
                        "    CONSTRAINT fk_item_menu FOREIGN KEY (MenuID) REFERENCES Menu(MenuID) ON DELETE CASCADE" +
                        ")"
                    );
                }

                // Step 2: Seed data if Restaurant table is empty
                if (isTableEmpty(conn, "Restaurant")) {
                    System.out.println("[DBInitializerListener] Seeding Restaurant data...");
                    stmt.execute(
                        "INSERT INTO Restaurant (RestaurantID, Name, CuisineType, DeliveryTime, Address, Rating, IsActive, ImagePath) VALUES " +
                        "(1, 'Adyar Ananda Bhavan (A2B)', 'South Indian', 25, 'Indiranagar, Bangalore', 4.3, true, 'images/a2b.png')," +
                        "(2, 'Barbeque Nation', 'Buffet & Barbeque', 45, 'Koramangala, Bangalore', 4.5, true, 'images/bbq.png')," +
                        "(3, 'Burger King', 'Fast Food', 20, 'Jayanagar, Bangalore', 4.1, true, 'images/burgerking.png')," +
                        "(4, 'Dominos Pizza', 'Pizza & Italian', 30, 'MG Road, Bangalore', 4.2, true, 'images/dominos.png')," +
                        "(5, 'KFC', 'Fried Chicken', 25, 'HSR Layout, Bangalore', 4.0, true, 'images/kfc.png')," +
                        "(6, 'Meghana Foods', 'Biryani & Andhra', 35, 'Koramangala, Bangalore', 4.6, true, 'images/meghana.png')," +
                        "(7, 'SS Hyderabad Biryani', 'Biryani & Mughlai', 30, 'BTM Layout, Bangalore', 4.4, true, 'images/ss-biryani.png')," +
                        "(8, 'Starbucks', 'Coffee & Desserts', 15, 'Indiranagar, Bangalore', 4.5, true, 'images/starbucks.png')"
                    );
                }

                if (isTableEmpty(conn, "Menu")) {
                    System.out.println("[DBInitializerListener] Seeding Menu data...");
                    stmt.execute(
                        "INSERT INTO Menu (MenuID, RestaurantID, ItemName, Description, Price, IsAvailable, ImagePath) VALUES " +
                        "(1, 1, 'Masala Dosa', 'Crispy golden crepe filled with potato masala served with chutney and sambar.', 80.00, true, 'images/dosa.jpg')," +
                        "(2, 1, 'Idli Sambar (2 Pcs)', 'Soft steamed rice cakes dipped in aromatic lentil sambar.', 60.00, true, 'images/idlisambar.png')," +
                        "(3, 1, 'Idli Vada Combo', 'One soft steamed idli and one crispy fried lentil vada.', 70.00, true, 'images/idlivada.png')," +
                        "(4, 1, 'Poori Masala (3 Pcs)', 'Fluffy deep fried whole wheat flatbreads served with potato curry.', 90.00, true, 'images/poori.jpg')," +
                        "(5, 2, 'Chicken Biryani', 'Aromatic basmati rice layered with spiced chicken and herbs.', 250.00, true, 'images/chicken_biryani.jpg')," +
                        "(6, 2, 'Chocolate Ice Cream', 'Creamy rich chocolate ice cream topped with fudge sauce.', 90.00, true, 'images/icecream.jpg')," +
                        "(7, 3, 'Crispy Veg Burger', 'Flavored vegetable patty with mayonnaise and lettuce.', 120.00, true, 'images/vegburger.png')," +
                        "(8, 3, 'Classic Chicken Burger', 'Crispy chicken patty with classic mayo and lettuce.', 160.00, true, 'images/chickenburger.png')," +
                        "(9, 4, 'Classic Margherita Pizza', 'Tangy tomato sauce with loaded mozzarella cheese.', 199.00, true, 'images/margherita.png')," +
                        "(10, 4, 'Farmhouse Pizza', 'Loaded with onion, crisp capsicum, mushrooms, and tomatoes.', 299.00, true, 'images/farmhouse.jpg')," +
                        "(11, 5, 'Hot & Crispy Bucket (8 Pcs)', 'Signature KFC crispy chicken bucket.', 499.00, true, 'images/kfcbucket.jpg')," +
                        "(12, 5, 'Chicken Zinger Burger', 'Signature chicken zinger patty with fresh lettuce and mayo.', 180.00, true, 'images/chickenburger.png')," +
                        "(13, 6, 'Special Chicken Biryani', 'Spiced boneless chicken pieces layered with flavored basmati rice.', 280.00, true, 'images/chicken_biryani.jpg')," +
                        "(14, 6, 'Mutton Biryani', 'Aromatic basmati rice cooked with tender mutton and traditional spices.', 340.00, true, 'images/mutton_biryani.jpg')," +
                        "(15, 7, 'Hyderabadi Chicken Biryani', 'Authentic Hyderabadi chicken biryani cooked dum style.', 260.00, true, 'images/chicken_biryani.jpg')," +
                        "(16, 7, 'Hyderabadi Mutton Biryani', 'Authentic Hyderabadi mutton biryani cooked dum style.', 320.00, true, 'images/mutton_biryani.jpg')," +
                        "(17, 8, 'Chocolate Fudge Cake', 'Rich and decadent chocolate cake slice.', 150.00, true, 'images/cake.jpg')"
                    );
                }

                System.out.println("[DBInitializerListener] Database successfully checked and initialized.");
            }
        } catch (Exception e) {
            System.err.println("[DBInitializerListener] Error executing initialization SQL:");
            e.printStackTrace();
        }
    }

    private boolean checkTableExists(Connection conn, String tableName) {
        try (Statement stmt = conn.createStatement()) {
            stmt.executeQuery("SELECT 1 FROM " + tableName + " LIMIT 1");
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private boolean isTableEmpty(Connection conn, String tableName) {
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM " + tableName)) {
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        } catch (Exception e) {
            // Return true on error so it attempts to seed if check failed
        }
        return true;
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[DBInitializerListener] Application shutting down.");
    }
}
