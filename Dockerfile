# Step 1: Build the Spring Boot Application (Java)
FROM maven AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and install dependencies (for cache optimization)
COPY pom.xml .
RUN mvn install

# Copy the source code to the container
COPY . .

# Package the application as a JAR file - i don't think this is needed (Hamza)
RUN mvn clean package -DskipTests

# # Step 2: Set up Nginx and copy the JAR file
# FROM nginx:1.23-alpine

# # Copy the JAR file from the build stage - these paths may need editing
# COPY --from=build /app/build /usr/share/nginx/html

# # Copy the Nginx configuration file
# COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

FROM eclipse-temurin:17-jre-jammy 
ARG JAR_FILE=/usr/app/target/*.jar
COPY --from=build $JAR_FILE /app/runner.jar
# Expose the necessary ports
EXPOSE 8000
CMD ["java", "-jar",  "/app/runner.jar"]

# Command to run the Spring Boot application using Nginx - not sure about this
# CMD ["sh", "-c", "java -jar /usr/share/nginx/html/my-app.jar & nginx -g 'daemon off;'"]