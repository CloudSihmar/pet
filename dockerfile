FROM schoolofdevops/maven:spring

WORKDIR /app

COPY . .

RUN mvn package && \
    mv target/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar /run/petclinic.jar

EXPOSE 8080

CMD java -jar /run/petclinic.jar
