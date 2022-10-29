FROM azul/zulu-openjdk-alpine:17-latest
# JDK 17.0.5
LABEL org.opencontainers.image.authors="kunwar.sangram@gmail.com"

RUN apk update && apk add --no-cache bash gnupg ca-certificates curl \
    && update-ca-certificates

ARG SCALA_VERSION=3.2.0
ARG SBT_VERSION=1.7.2

ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV SCALA_VERSION=${SCALA_VERSION}
ENV SBT_VERSION=${SBT_VERSION}

VOLUME /src
WORKDIR /src

RUN cd /usr/local/share \
    && curl -fL https://github.com/lampepfl/dotty/releases/download/${SCALA_VERSION}/scala3-${SCALA_VERSION}.tar.gz |tar -xz && ln -s scala3-${SCALA_VERSION} scala3 \
    && curl -fL https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar -xz && mv sbt sbt-${SBT_VERSION} && ln -s sbt-${SBT_VERSION} sbt \
    && ln -s /usr/local/share/scala3/bin/scala /usr/bin/scala \
    && ln -s /usr/local/share/scala3/bin/scalac /usr/bin/scalac \
    && ln -s /usr/local/share/scala3/bin/scaladoc /usr/bin/scaladoc \
    && ln -s /usr/local/share/sbt/bin/sbt /usr/bin/sbt \
    && echo "-java-home ${JAVA_HOME}" >> /usr/local/share/sbt/conf/sbtopts \
    && cd /src && echo "scalaVersion := \"${SCALA_VERSION}\"" >  build.sbt

#RUN sbt sbtVersion
    
CMD ["scala"]

    
