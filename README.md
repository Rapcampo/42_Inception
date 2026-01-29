*This project has been created as part of the 42 curriculum by Rapcampo*

# Contents
- [Description](#description)
  - [Brief Overview](#brief-overview) 
- [Instructions](#instructions)
- [Technical Considerations](#technical-considerations)
  - [Virtual Machines vs Docker](#virtual-machines-vs-docker)
  - [Secrets vs Environment Variables](#secrets-vs-environment-variables)
  - [Docker Network vs Host Network](#docker-network-vs-host-network)
  - [Docker Volumes vs Bind Mounts](#docker-volumes-vs-bind-mounts)
- [Resources](#resources)

## Description

### Brief overview

### Virtual Machines vs Docker

### Secrets vs Environment Variables

### Docker Network vs Host Network

### Docker Volumes vs Bind Mounts

## Instructions

## Technical Considerations

## Resources

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
