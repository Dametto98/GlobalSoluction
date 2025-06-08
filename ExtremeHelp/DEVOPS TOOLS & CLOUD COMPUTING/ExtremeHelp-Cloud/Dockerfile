FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /build

COPY ExtemeHelp-JavaBackend/ ./ExtemeHelp-JavaBackend/
WORKDIR /build/ExtemeHelp-JavaBackend
 
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

ENV ACTIVE_PROFILE=prod 

COPY --from=build /build/ExtemeHelp-JavaBackend/target/*.jar app.jar

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
 
USER appuser
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]