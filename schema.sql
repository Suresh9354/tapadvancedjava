-- Database schema for Food App

CREATE DATABASE IF NOT EXISTS food_delivery;
USE food_delivery;

-- 1. User table
CREATE TABLE IF NOT EXISTS User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Address TEXT,
    Role VARCHAR(50) DEFAULT 'Customer'
);

-- 2. Restaurant table
CREATE TABLE IF NOT EXISTS Restaurant (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CuisineType VARCHAR(100),
    DeliveryTime INT,
    Address TEXT,
    Rating DECIMAL(3,2),
    IsActive BOOLEAN DEFAULT TRUE,
    ImagePath VARCHAR(255)
);

-- 3. Menu table
CREATE TABLE IF NOT EXISTS Menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT,
    ItemName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    IsAvailable BOOLEAN DEFAULT TRUE,
    ImagePath VARCHAR(255),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE CASCADE
);

-- 4. ordertable table
CREATE TABLE IF NOT EXISTS ordertable (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    RestaurantID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending',
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE SET NULL,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE SET NULL
);

-- 5. orderitem table
CREATE TABLE IF NOT EXISTS orderitem (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    MenuID INT,
    Quantity INT NOT NULL,
    ItemTotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES ordertable(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID) ON DELETE CASCADE
);
