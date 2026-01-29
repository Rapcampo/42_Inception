*This project has been created as part of the 42 curriculum by Rapcampo*

# Description

## Brief overview

## Virtual Machines vs Docker

## Secrets vs Enviroment Variables

## Docker Network vs Host Network

## Docker Volumes vs Bind Mounts

# Instruction

# Resources

(link to USER_DOC)

(link to DEV_DOC)

important commands:
`docker exec -it [container name] [command to be used]`
verify ssl certs and version
`openssl s_client -connect [username].42.fr:443 -servername [username].42.fr -showcerts </dev/null`
verify folder struct:
`tree -I -a .`
Verify hostname is correct:
`grap [username].42.fr /etc/hosts`

pid 1 is important for docker to keep track of the health of the container, therefore deamon services should not branch off from this pid as a way to guarantee proper tracking and signals when docker stop is invoked
