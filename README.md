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
Inception is an automated-deployment and containerized WordPress LEMP stack infrastructure using docker-compose on a Debian base.

### Brief overview
The aim of this project is to provide a turn-key Docker infrastructure for running production-like Wordpress website on your local machine. it is composed of:
- Nginx as a secure HTTPS reverse proxy
- Wordpress with pre-configured PHP-FPM
- MariaDB as database engine
- Named Docker volumes for persistence of data
- A Makefile with all the common workflows (build, up, down, clean) and some debug features (database check, logs)

## Instructions
### prerequisites
- Operating System: Linux (requires sudo privileges for host-file edits)
- Docker Engine
- Docker Compose (usually bundled with Docker)
- GNU Make
- Adminstrator access (sudo privileges): for changes in `/etc/hosts` entries & removal of proctected volumes

### Build
1. Clone the repository
```
git clone git@github.com:Rapcampo/42_Inception.git inception
cd inception
```
2. Populate the secret files
```
echo "[your_database_user_pass]" > secrets/db_password.txt
```
3. 
## Technical Considerations

### Virtual Machines vs DockerV

### Secrets vs Environment Variables

### Docker Network vs Host Network

### Docker Volumes vs Bind Mounts

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
