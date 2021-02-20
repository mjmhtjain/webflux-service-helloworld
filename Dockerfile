FROM openjdk:15-jdk-alpine
VOLUME /tmp
COPY target/WebfluxService-0.0.1-SNAPSHOT.jar webfluxbasicapi.jar
EXPOSE 8090
ENTRYPOINT exec java -jar webfluxbasicapi.jar
#ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar webfluxbasicapi.jar
