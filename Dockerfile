# ---------- Stage 1: Build ----------
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml first so Docker can cache dependencies separately from source code
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Now copy the actual source code and build the jar
COPY src ./src
RUN mvn clean package -DskipTests

# ---------- Stage 2: Run ----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy only the built jar from the previous stage — keeps final image small
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
