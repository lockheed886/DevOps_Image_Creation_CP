# Stage 1: Build the application using Maven
FROM maven:3.8.7-eclipse-temurin-11 AS build

WORKDIR /app

# Copy pom.xml first to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build the project
COPY src ./src
RUN mvn clean package -DskipTests -B

# Stage 2: Run the application
FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/Calculator-1.0-SNAPSHOT.jar app.jar

# Set the entrypoint to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
