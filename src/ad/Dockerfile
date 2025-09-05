# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0


FROM --platform=${BUILDPLATFORM} amazoncorretto:21-al2023-jdk AS builder
ARG _JAVA_OPTIONS
WORKDIR /usr/src/app/

COPY ./src/ad/gradlew* ./src/ad/settings.gradle* ./src/ad/build.gradle ./
COPY ./src/ad/gradle ./gradle

RUN yum update -y && yum install -y findutils

RUN chmod +x ./gradlew
RUN ./gradlew
RUN ./gradlew downloadRepos

COPY ./src/ad/ ./
COPY ./pb/ ./proto
RUN chmod +x ./gradlew
RUN ./gradlew installDist -PprotoSourceDir=./proto

# -----------------------------------------------------------------------------

FROM amazoncorretto:21-al2023-jdk

ARG OTEL_JAVA_AGENT_VERSION
ARG _JAVA_OPTIONS

WORKDIR /usr/src/app/

RUN yum update -y && yum install -y findutils

COPY --from=builder /usr/src/app/ ./
COPY ../../agent-all.jar /usr/agent-all.jar
ADD --chmod=644 https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v$OTEL_JAVA_AGENT_VERSION/opentelemetry-javaagent.jar /usr/src/app/opentelemetry-javaagent.jar
ENV JAVA_TOOL_OPTIONS="-javaagent:/usr/src/app/opentelemetry-javaagent.jar -Dotel.javaagent.extensions=/usr/agent-all.jar -Dtools.profiler.exporter.args='profilerOptions=start,loop=6s,interval=1ns;endpoint=pyroscope:4040;secure=false' -Dio.netty.tryReflectionSetAccessible=false -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager"

# RUN apt update -y && apt install -y gdb

EXPOSE ${AD_PORT}
ENTRYPOINT [ "./build/install/opentelemetry-demo-ad/bin/Ad" ]
