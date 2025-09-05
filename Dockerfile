# Step 1: Use Java 17 base image
FROM openjdk:17-jdk-slim

# Step 2: Copy jar file from Maven target folder
COPY target/*.jar app.jar

# Step 3: Expose port 8080
EXPOSE 8080

# Step 4: Run the jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

