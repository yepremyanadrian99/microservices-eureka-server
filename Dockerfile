FROM gradle:7.2 as build

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle clean build --no-daemon

FROM openjdk:11

RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/*.jar /app/eureka-server.jar

ENV JAVA_OPTS "-Xmx192m -Xms192m -Djava.security.egd=file:///dev/./urandom -XX:+HeapDumpOnOutOfMemoryError "
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar /app/eureka-server.jar" ]