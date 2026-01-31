*This project has been created as part of the 42 curriculum by Rapcampo*

# Contents
- [Description](#description)
  - [Services Provided](#services-provided)
- [Usage](#usage)
  - [Basic Controls](#basic-controls)
  - [Website Access & Administrator Panel](#website-access-&-administrator-panel)
  - [Locating and Managing Credentials](#locating-and-managing-credentials)
  - [How to Check Service Status](#how-to-check-service-status)
- [Resources](#resources)

## Description

> **Note**: For installation and overview of the project, refer to the [Readme](README.md) in this reposoritory.

This is a regular user facing documentation aimed to provide a high level explanation about the following contents:
- Understand what services are provided bythe stack
- Start and stop the project
- Access the website and administration panel
- Locate a manage credentials
- Check the services are running correctly

### Services Provided

---

Effectively speaking this project is a LEMP stack, which is a acronym for:
> **L**inux
> **E**engineX (NGINX)
> **M**ariaDB
> **P**HP-FPM

Therefore, using a linux (in this case debian) base, three services are provided, with one container per service. Which are the following:

- NGINX: the only public entrypoint. It terminates TLS and serves the website over HTTPS using TLSv1.2/TLSv1.3. Effectively running as a reverse proxy
- Wordpress + PHP-FPM: the application layer. It runs Wordpress using PHP-FPM only
- MariaDB: the backend, namely database layer of this project, which stores the wordpress data

As an overview, the traffic flow can be visualized this way:

`User Browser -> HTTPS -> NGINX -> (internal network) -> Wordpress (PHP-FPM) -> (internal network) -> MariaDB`

## Usage

Here are the main controls and useful high level information regarding this project.

### Basic Controls

---

On the root of the repository, where lies a Makefile named archive you can control the entire infrastructure through simple commands such as:

| Rule | Description |
| --- | --- |
| `make up` | Builds the containers, network and volumes and runs the infrastructure |
| `make down` | stops containers and network, **keeps data intact** |
| `make re` | Forces rebuild of networks and containers, **keeps data intact** |
| `make clean` | Stops containers and network, **removes named volumes attached to containers** |
| `make fclean` | Stops and eliminates containers, networks and does a docker system prune, **effectively a full wipe** |
| `make log_nginx` | To be used after building, shows real time log of the NGINX container |
| `make log_mariadb` | To be used after building, shows real time log of the MariaDB container |
| `make log_wordpress` | To be used after building, shows real time log of the Wordpress container |
| `make database` | To be used after building, shows present databases at the mariadb container, **may require database root password** |
| `make tables` | To be used after building, shows tables of the wordpress database at the mariadb container, **may require database root password** |

### Website Access & Administrator Panel

---


### Locating and Managing Credentials

---

### How to Check Service Status

---

## Resources

> **Note**: For all the resources pertaining the general documentation and information regarding the technical aspects of this project, please refer to the README file in the [resources](README.md#resources) section.

- [Developer Documentation](DEV_DOC.md)
