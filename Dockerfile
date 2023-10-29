FROM scratch AS base

FROM eclipse-temurin:17-jre-jammy as builder
WORKDIR application
COPY build/libs/*.jar application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM gcr.io/distroless/java17-debian11:debug

USER nonroot:nonroot

COPY --chown=nonroot:nonroot --from=base / /logs/
COPY --chown=nonroot:nonroot --from=builder application/dependencies/ ./
COPY --chown=nonroot:nonroot --from=builder application/spring-boot-loader/ ./
COPY --chown=nonroot:nonroot --from=builder application/snapshot-dependencies/ ./
COPY --chown=nonroot:nonroot --from=builder application/application/ ./

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
