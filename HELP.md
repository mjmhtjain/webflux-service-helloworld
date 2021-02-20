# Getting Started

### Reference Documentation
For further reference, please consider the following sections:

* [Official Apache Maven documentation](https://maven.apache.org/guides/index.html)
* [Spring Boot Maven Plugin Reference Guide](https://docs.spring.io/spring-boot/docs/2.4.3/maven-plugin/reference/html/)
* [Create an OCI image](https://docs.spring.io/spring-boot/docs/2.4.3/maven-plugin/reference/html/#build-image)

### Helpful commands

* Maven build and run commands
```
mvn clean package -DskipTests
java -jar target/WebfluxService-0.0.1-SNAPSHOT.jar
```

* docker build and run using the default Dockerfile and docker-compose file
```
docker build --tag webfluxbasicapi .
docker run -p 8090:8090 webfluxbasicapi

docker-compose up
docker-compose down
```

* clean docker images
```
docker system prune -f
```

* remove docker images
```
docker rmi <image-name/image-id>
```