package com.food.Util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection connection;

    public static Connection getConnection() {

        try {

            if(connection == null || connection.isClosed()) {

                Class.forName("com.mysql.cj.jdbc.Driver");

                String host = System.getenv("MYSQLHOST");

                if(host == null) {

                    connection =
                        DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/food_delivery?useSSL=false&allowPublicKeyRetrieval=true",
                            "root",
                            "root");
                }
                else {

                    String port = System.getenv("MYSQLPORT");
                    String database = System.getenv("MYSQLDATABASE");
                    String username = System.getenv("MYSQLUSER");
                    String password = System.getenv("MYSQLPASSWORD");

                    String url =
                        "jdbc:mysql://" +
                        host + ":" +
                        port + "/" +
                        database +
                        "?useSSL=false&allowPublicKeyRetrieval=true";

                    connection =
                        DriverManager.getConnection(
                            url,
                            username,
                            password);
                }
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return connection;
    }
}