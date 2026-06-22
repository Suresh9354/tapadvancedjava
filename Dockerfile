# Stage 1: Build the Maven project
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the app in Tomcat
FROM tomcat:10.1-jdk21
COPY --from=build /app/target/food_app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

# Dynamically bind to the PORT assigned by Railway (or fallback to 8080)
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/g\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]