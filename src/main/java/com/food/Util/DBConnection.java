package com.food.Util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection connection;

    public static Connection getConnection() {

        try {

            if (connection == null || connection.isClosed()) {

                Class.forName("com.mysql.cj.jdbc.Driver");

                String host = System.getenv("MYSQLHOST");

                System.out.println("HOST = " + host);

                if (host == null || host.isEmpty()) {

                    connection =
                        DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/food_delivery?useSSL=false&allowPublicKeyRetrieval=true",
                            "root",
                            "root");

                } else {

                    String port = System.getenv("MYSQLPORT");
                    String database = System.getenv("MYSQL_DATABASE");
                    String username = System.getenv("MYSQLUSER");
                    String password = System.getenv("MYSQLPASSWORD");

                    System.out.println("PORT = " + port);
                    System.out.println("DB = " + database);
                    System.out.println("USER = " + username);
                    System.out.println("PASSWORD = " + (password != null));

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return connection;
    }
}