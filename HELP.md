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

* Kubernetes dashboard command
```
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

kubectl proxy

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

kubectl create serviceaccount dashboard-admin-sa

kubectl create clusterrolebinding dashboard-admin-sa \
  --clusterrole=cluster-admin \
  --serviceaccount=default:dashboard-admin-sa

kubectl get secrets

kubectl describe secret dashboard-admin-sa-token-p5jvq
```