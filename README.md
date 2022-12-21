# BioMEG Open Source Software
This is the Biometric Message Exchange Gateway library that performs translations between various commonly used
biometric request and response XML documents.

## Endpoints
| Method | Path                | Description                                                   |
|--------|---------------------|---------------------------------------------------------------|
| POST   | `/xml/convertXml`   | Translates the input XML and returns a converted XML document |
| POST   | `/xml/identApiCall` | Mocks a call to the DHS identification service                |

For more details, please check out the [Swagger](http://localhost:8080/swagger-ui/index.html) endpoint.

## Libraries and Frameworks
This application uses the following.

- [Spring Boot 3.0.0](https://spring.io/projects/spring-boot)
- [Lombok](https://projectlombok.org/)
- [Jacoco](https://www.jacoco.org/jacoco/trunk/index.html) (for unit testing, code coverage)

## Requirements
For building and running the application, you'll need:

- [JDK 18](https://openjdk.org/projects/jdk/) or later
- [Maven 3](https://maven.apache.org)

## Running the application locally
The simplest way to run a Spring Boot application on your local machine is the use your IDE to execute the `main` method
from the application class: `com.psiit.biomegoss.BiomegOssApplication`.

Alternatively, you can use Maven to run it from the command line:
```shell
mvn spring-boot:run
```

### Access the application
- [http://localhost:8080](http://localhost:8080)
- [Swagger](http://localhost:8080/swagger-ui/index.html)
- [Actuator Endpoints](http://localhost:8080/actuator/)

## Code Coverage

Jacoco plugin is integrated into the application to generate a coverage report locally.

1. Run the tests using the following command:

```shell
mvn clean test
```
2. Open index.html from the following directory to see the report:
```shell
target/site/jacoco
```