# Build the Spring Boot WAR with Java 17
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests clean package

# Run the executable WAR on Java 17
FROM eclipse-temurin:17-jre

WORKDIR /app
COPY --from=build /app/target/production-0.0.1-SNAPSHOT.war app.war

ENV PORT=10000
EXPOSE 10000

ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-10000} -Dserver.address=0.0.0.0 -jar /app/app.war"]
