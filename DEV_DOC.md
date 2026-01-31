*This project has been created as part of the 42 curriculum by Rapcampo*

# Contents
- [Description](#description)
- [Setup](#usage)
  - [Prerequisites](#prerequisites)
  - [Virtual Machine Setup](#virtual-machine-setup)
  - [Configuration Files](#configuration-files)
  - [Setting up Secrets](#setting-up-secrets)
  - [Makefile and Docker Compose](#makefile-and-docker-compose)
  - [Docker Volumes](#docker-volumes)
- [Relevant Commands](#relevant-commands)
- [Resources](#resources)

## Description

> **Note**: For installation and overview of the project, refer to the [Readme](README.md) in this reposoritory.

This is a developer intended documentation aimed to provide detailed explanation about the following contents:

- Set up the environment from scratch (prerequisites, configuration files, secrets)
- Build and launch the project using the Makefile and Docker Compose
- Use relevant commands to manage the containers and volumes
- Identify where the project adata is stored and how it persists.

## Setup

### Prerequisites

### Virtual Machine Setup

### Configuration Files

### Setting up Secrets

### Makefile and Docker Compose

### Docker Volumes

## Relevant Commands

important commands:
`docker exec -it [container name] [command to be used]`
verify ssl certs and version
`openssl s_client -connect [username].42.fr:443 -servername [username].42.fr -showcerts </dev/null`
verify folder struct:
`tree -I -a .`
Verify hostname is correct:
`grep [username].42.fr /etc/hosts`

pid 1 is important for docker to keep track of the health of the container, therefore deamon services should not branch off from this pid as a way to guarantee proper tracking and signals when docker stop is invoked

## Resources

> **Note**: For all the resources pertaining the general documentation and information regarding the technical aspects of this project, please refer to the README file in the [resources](README.md#resources) section.

- [User Guide Documentation](USER_DOC.md)


