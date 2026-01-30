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
Inception is a system administration and DevOps-oriented project. The project is focused on automated-deployment and containerized WordPress LEMP stack small infrastructure. The goal is to design, build and run a multi-service stack with strong isolation, reproducibility, and security constraints, using Docker Compose and custom-built Docker images.

### Brief overview
The aim of this project is to provide a turn-key Docker infrastructure for running a persistent production-like Wordpress website on your local machine. it is composed of:
- Nginx as a secure HTTPS reverse proxy acting as a single entrypoint into the infrastructe
- Wordpress with pre-configured PHP-FPM
- MariaDB as database backend
- Named Docker volumes for persistence of data
- A Makefile with all the common workflows (build, up, down, clean) and some debug features (database check, logs)

### Key goals
The key goals for this project are the following:
- Understand how services are separated into containers and connect through Docker Networking
- Understand how to build custom Docker images (one Docker file per service) without relying on pre-built images from Dockerhub
- Understand how Docker volumes work to create persistent data on ephemeral docker containers
- Learn how to configure secure access (TLS) and SSL certificate, as well as avoinding leaking secrets
- Provide a simple, reliable and reproducible workflow via Makefile and docker compose setup

## Instructions

### prerequisites
- Operating System: Linux (requires sudo privileges for host-file edits)
- Docker Engine
- Docker Compose (usually bundled with Docker)
- GNU Make
- Adminstrator access (sudo privileges): for changes in `/etc/hosts` entries & removal of proctected volumes

### Build
1. Clone the repository
```bash
git clone git@github.com:Rapcampo/42_Inception.git inception
cd inception
```
2. Populate the secret files
```bash
echo "[your_database_user_password]" > secrets/db_password.txt
echo "[your_database_root_password]" > secrets/db_root_password.txt
echo "[your_wordpress_user_password]" > secrets/wp_user_password.txt
echo "[your_wordpress_admin_password]" > secrets/wp_admin_password.txt
```
3. Build and launch
On the root of the project folder where you see Makefile file.
```bash
make up #or just "make" as a shorhand
```
**Note**: services will keep running and restarting unless stopped using `make down`

## Technical Considerations
Since the project has very specific requirements regarding volume mounting, password protection and networking, it is important to notice a few technical considerations regarding the choises required for this project. 

### Virtual Machines vs Docker

### Secrets vs Environment Variables

### Docker Network vs Host Network

### Docker Volumes vs Bind Mounts

## Resources


### Use of AI

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
