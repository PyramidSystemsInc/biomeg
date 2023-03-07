# Build stage
#
FROM maven:3.8.3-openjdk-17 AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

#
# Package stage
#
FROM docker.io/openjdk:17-jdk-slim
COPY --from=build /home/app/target/biomeg-oss-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
CMD java -jar app.jar
