FROM openjdk:8-jre-alpine as buildwar
MAINTAINER Chris Peck <crpeck@wm.edu>
RUN cd /tmp \
  && apk --no-cache add maven git \
  && git clone -b master --single-branch https://github.com/apereo/cas-overlay-template.git cas-overlay \
  && mkdir -p /tmp/cas-overlay/src/main/webapp
COPY src/main/webapp/ /tmp/cas-overlay/src/main/webapp/
WORKDIR /tmp/cas-overlay
RUN  mvn clean package

FROM openjdk:8-jre-alpine
MAINTAINER Chris Peck <crpeck@wm.edu>
RUN mkdir /etc/cas \
  && cd /etc/cas \
  && keytool -genkey -noprompt -keystore thekeystore -storepass changeit -keypass changeit -validity 3650 \
             -keysize 2048 -keyalg RSA -dname "CN=localhost, OU=MyOU, O=MyOrg, L=Somewhere, S=VA, C=US"
WORKDIR /root
COPY --from=buildwar /tmp/cas-overlay/target/cas.war .
COPY etc/cas /etc/cas
EXPOSE 8443
CMD [ "/usr/bin/java", "-jar", "/root/cas.war" ]
