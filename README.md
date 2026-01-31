*This project has been created as part of the 42 curriculum by Rapcampo*

# Contents
- [Description](#description)
  - [Brief Overview](#brief-overview) 
- [Instructions](#instructions)
  - [Pre-requisites](#pre-requisites)
  - [Build](#build)
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

### Pre-requisites
- Operating System: Linux (requires sudo privileges for host-file edits)
- Docker Engine
- Docker Compose (usually bundled with Docker)
- GNU Make
- Adminstrator access (sudo privileges): for changes in `/etc/hosts` entries and removal of protected volumes

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
Since the project has very specific requirements regarding volume mounting, password protection and networking, it is important to notice a few technical considerations regarding the choices required for this project. 

### Virtual Machines vs Docker
When it comes to the difference between Virtual Machines (hereforth VMs) and Docker, one must understand the security, resources and isolation requirements, here is a basic overview of the differences between both:

| VMs | Docker |
| --- | ------ |
| Virtualizes hardware | Virtualizes application layer |
| Runs a separate kernel | Uses host kernel |
| Larger resource footprint | Lightweight and fast |
| Large space requirements | Comparatively low space requirement |
| Very strong isolation | Strong-enough isolation, less than VMs |

In the case of the project, both are used since the infrastucture is deployed inside a virtual machine. However, if we were to look at just the infrastructure itself, the requirements are easy of deployment, reproducibility, clear service separation and isolation. Being ephemeral, idempotent and immutable makes these Docker containers a clear choice for the project.

### Secrets vs Environment Variables
In this project the use of Docker Secrets is heavily emphasized, a simple breakdown of the differences is:

| Secrets | Envs |
| --- | ------ |
| Especially designated for sensitive data | Intended for non-sensitive configuration |
| Typically mounted as in-memory files | Usually embedded in images or .env files |
| Reduced accidental exposure through logs and env dumps | Can be leaked through logs, process listing, container inspection |

As there is a risk of exposure of sensitive data through env dumps and logging, the use of secrets is a very important good practice for an overall more secure infrastructure. A .env file should almost always only have non-sensitive information in it.

### Docker Network vs Host Network
It is very important that the project runs on an isolated network using Docker networks, as a host network creates security risks and possible port conflicts, to summarize:

| Docker Network | Host Network |
| --- | ------ |
| Containers get private IPs and can resolve each other through DNS | Containers shares the host's network (as if running directly on the host) |
| Selectively push ports limit what is publicly reachable | Internal services may become reachable and port conflicts are more likely |
| Internal services are unreachable from outside and cleaner architecture | Not recommended unless absolutely necessary |
| Requires NAT | Does not require NAT and no "userland-proxy" is created |

As a general rule of thumb, should only be used as an exception for cases where optimization is required or a container needs to handle a large number of ports. Since Docker has a plentitude of network driver options for different use cases, such as Bridge, Macvlan, IPvlan, none and Overlay, in most cases, one should opt for a Docker network. 

### Docker Volumes vs Bind Mounts
When it comes to Docker volumes and Bind mounts, here are the follwing considerations:

| Docker Volume| Bind Mounts |
| --- | ------ |
| Managed by Docker (lifecycle, location and permimssions) | Direct mapping of a host path into a container |
| Portable and safer for persistent service data | Useful for local development and for controlled host directories |
| Works well across environments | Tighter coupling to host filesystem layout and permissions |
| Recommended for stateful data such as MariaDB data directories | Higher risk of permission issues and accidental overwrites |

Since Inception requires persistence, these are best met with Docker volumes, hence why it is emphasized.

## Resources

- [How to setup your VM](https://github.com/Bakr-1/inceptionVm-guide)
- [What is Docker?](https://devopscube.com/what-is-docker/)
- [Docker Official installation documentation](https://docs.docker.com/engine/install/debian/)
- [Understanding the diference between VMs and Docker](https://medium.com/@h.stoychev87/containerization-docker-and-containers-8e8f28fd0694)
- [Docker Volume Documentation](https://docs.docker.com/engine/storage/volumes/)
- [Understanding Docker networking](https://ostechnix.com/explaining-docker-networking-concepts/)
- [How containers talk to each other](https://tomd.xyz/why-containers-wont-talk/)
- [Nginx Beginner's Guide Documentation](https://nginx.org/en/docs/beginners_guide.html)
- [How to configure Nginx to use TLS 1.2/1.3](https://www.cyberciti.biz/faq/configure-nginx-to-use-only-tls-1-2-and-1-3/)
- [LEMP stack deployment with Docker compose](https://medium.com/swlh/wordpress-deployment-with-nginx-php-fpm-and-mariadb-using-docker-compose-55f59e5c1a)
- [Installing MariaDB](https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-ubuntu-20-04)
- [Installing Wordpress with WP-CLI](https://blog.sucuri.net/2022/11/wp-cli-how-to-install-wordpress-via-ssh.html)
- [Understanding PID 1](https://medium.com/@imyzf/inception-3979046d90a0)
- [User intended documentation](USER_DOC.md)
- [Developer intended documentation](DEV_DOC.md)

### Use of AI

```
In this project, there was use of artificial inteligence (AI) for the following:
- Help identifying possible causes of bugs and issues, namely MariaDB incorrect folder creation and ownership, leading to very hard to nail down issues with the database persistence.
- Finding out how to verify TLS version used in Nginx through the terminal.
- Debugging SSL certification issue as it stopped working at some point during testing phase and could not revert.
- Setting up a blueprint for this documentation, however, the documentation was handwritten as an execise and review of the project, as well as adding more relavant and rich information than provided.
```
