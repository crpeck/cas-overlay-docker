#FROM adoptopenjdk/openjdk11:alpine-slim as buildwar
FROM openjdk:11-jre-slim as buildwar
MAINTAINER Chris Peck <crpeck@wm.edu>
RUN cd /tmp \
  && apt-get update \
  && apt-get -y install git \
  && git clone -b master --single-branch https://github.com/apereo/cas-overlay-template.git cas-overlay \
  && mkdir -p /tmp/cas-overlay/src/main/webapp
WORKDIR /tmp/cas-overlay
COPY src/ /tmp/cas-overlay/src
RUN  ./gradlew clean build

#FROM adoptopenjdk/openjdk11:alpine-slim
FROM openjdk:11-jre-slim
MAINTAINER Chris Peck <crpeck@wm.edu>
RUN mkdir /etc/cas
COPY etc/cas /etc/cas
WORKDIR /etc/cas
RUN keytool -genkey -noprompt -keystore thekeystore -storepass changeit -keypass changeit -validity 3650 \
             -keysize 2048 -keyalg RSA -dname "CN=localhost, OU=MyOU, O=MyOrg, L=Somewhere, S=VA, C=US"
RUN keytool -noprompt -importcert -keystore /usr/local/openjdk-11/lib/security/cacerts -storepass changeit \
             -file /etc/cas/config/certificate.pem -alias "casclient"
WORKDIR /root
COPY --from=buildwar /tmp/cas-overlay/build/libs/cas.war .
EXPOSE 8443
CMD [ "/usr/local/openjdk-11/bin/java", "-jar", "/root/cas.war" ]
