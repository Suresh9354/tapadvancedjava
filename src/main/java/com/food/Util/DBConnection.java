package com.food.Util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection connection;

    public static Connection getConnection() {

        try {

            if(connection == null || connection.isClosed()) {

                String host = System.getenv("MYSQLHOST");

                if(host == null) {

                    connection =
                            DriverManager.getConnection(
                                    "jdbc:mysql://localhost:3306/food_delivery",
                                    "root",
                                    "root");
                }
                else {

                    String port = System.getenv("MYSQLPORT");
                    String database = System.getenv("MYSQLDATABASE");
                    String user = System.getenv("MYSQLUSER");
                    String password = System.getenv("MYSQLPASSWORD");

                    String url =
                            "jdbc:mysql://" +
                            host + ":" +
                            port + "/" +
                            database;

                    connection =
                            DriverManager.getConnection(
                                    url,
                                    user,
                                    password);
                }
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return connection;
    }
}