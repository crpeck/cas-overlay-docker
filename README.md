CAS Overlay Docker
==================
# Docker Compose setup that using a multi-stage build:
* First stage builds a Docker image that:
  * clones https://github.com/apereo/cas-overlay-template
  * copies the src tree into it
  * builds cas.war 
* Second stage runs CAS in a Docker container
  * copy the directory etc/cas into the container at /etc/cas
  * generates a self-signed keystore for CAS to use at startup
  * copies the cas.war file from the first stage 
  * exposes port 8443
  * runs /usr/bin/java -jar cas.war (using the embedded Tocmat server)

To use
=====
* To build & run CAS in Docker type:
```docker-compose up --force-recreate```

* Open up a page at https://localhost:8443/cas/login and login as:
  * user: casuser
  * password: Mellon

* Type ctrl-c to exit, then type this to cleanup:
```docker-compose down --rmi all```
