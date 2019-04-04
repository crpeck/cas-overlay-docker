CAS Docker Overlay
==================
NOTE - this will onlyh build CAS version 5.3 for now. It's based on the Maven build process
       NOT the gradel build.

# Docker Compose setup using a multi-stage build:
* First stage builds a Docker image that:
  * clones https://github.com/apereo/cas-overlay-template
  * copies the src (local overlay) tree into it
  * builds cas.war
* Second stage runs CAS in a Docker container
  * copies the directory etc/cas into the container at /etc/cas
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

Notes
=====
If you want to grab a copy of the cas.war file that is running in the container use the 'docker cp' command, for example:
```
wishbringer:~ $ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                  PORTS                    NAMES
79e44dd14c7e        dockercasdev_cas    "/usr/bin/java -ja..."   21 seconds ago      Up 20 seconds           0.0.0.0:8443->8443/tcp   dockercasdev_cas_1
6f5bc662213b        nginx               "nginx -g 'daemon ..."   5 days ago          Exited (0) 5 days ago                            webserver
de061f8c8aef        alpine              "env"                    5 days ago          Exited (0) 5 days ago                            amazing_feynman
4e3975361ef2        alpine              "ifconfig"               5 days ago          Exited (0) 5 days ago                            keen_jang
wishbringer:~ $ docker cp 79e44dd14c7e:/root/cas.war .
wishbringer:~ $ ls -l cas.war
-rw-r--r--  1 crpeck  staff  91251638 Aug 15 14:40 cas.war
```

The end result is an image of about 173MB that has a full implementation of CAS.
```
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
casoverlaydocker_cas   latest              954457811c53        18 seconds ago      173MB
```

References
==========
[Documentation](https://apereo.github.io/cas/5.1.x/index.html)  
[Issue Tracker](https://github.com/apereo/cas/issues)  
[Mailing Lists](https://apereo.github.io/cas/Mailing-Lists.html)  
[Chatroom](https://gitter.im/apereo/cas)  
[Blog](https://apereo.github.io/)  
