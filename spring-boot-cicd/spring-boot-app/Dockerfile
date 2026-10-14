# CHALLENGE 03:
# This old base image is intentionally used so Trivy can find vulnerabilities.
# Your task: replace it with a safer Java 11 runtime image and rebuild.
FROM adoptopenjdk/openjdk11:alpine-jre

ARG artifact=target/spring-boot-web.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

ENTRYPOINT ["java","-jar","app.jar"]
