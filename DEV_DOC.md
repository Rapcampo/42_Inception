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

> :bulb: **Note**: For installation and overview of the project, refer to the [Readme](README.md) in this repository.

This is a developer intended documentation aimed to provide detailed explanation about the following contents:

- Set up the environment from scratch (prerequisites, configuration files, secrets)
- Build and launch the project using the Makefile and Docker Compose
- Use relevant commands to manage the containers and volumes
- Identify where the project adata is stored and how it persists.

## Setup

When it comes to setting up this project, it is important to understand the proper repository structure, which should be something like this:

```bash
.
├── DEV_DOC.md
├── Makefile
├── README.md
├── secrets
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
├── srcs
│   ├── docker-compose.yml
│   └── requirements
│       ├── mariadb
│       │   ├── Dockerfile
│       │   └── tools
│       │       └── script.sh
│       ├── nginx
│       │   ├── Dockerfile
│       │   └── tools
│       │       └── nginx.conf
│       └── wordpress
│           ├── Dockerfile
│           └── tools
│               └── script.sh
└── USER_DOC.md
```

You can verify this structure by using the command `tree -I -a .` at the root of the project, if tree is not installed, you can install with the command:

```bash
sudo apt update && sudo apt install tree
```
That being said, there are other prerequisites to be able to build this project. Which are the following.

### Prerequisites

---

While a few things are of mandatory installation, I will also include optional installation for which is helpful for debugging.

- Mandatory Installation
  - Operating system: Linux
  - Docker Engine
  - Docker Compose (plugin or standalone)
  - GNU Make
  - Administrator Rights
- Optional Installation
  - Tree
  - OpenSSL
  - Curl

For the optional installations here are their usefulness for this project:

- Tree: Helpful for checking folder structure and making sure the project is well laid out
- OpenSSL: Helfpul for checking the validity and version of TLS used for the NGINX container
- Curl: Useful for verifying that NGINX is reachable.

### Virtual Machine Setup

---

As is there is nothing being said about the Virtual machine is this project's requirements, I find important to understand the minimal setup required for starting your project.

> I would like to especially thanks Bakr-1 for [this](https://github.com/Bakr-1/inceptionVm-guide) very helpful and detailed guide, which I draw major inspiration from. Check if out if more in depth information is needed.

For staters, one must acquire a linux image ([here](https://www.debian.org/distrib/) is a link for the official debian website), for the purposes of installing your Virtual Machine.

#### VM Manager and Machine requirements

One can use either Virtual Box or Virtual Machine Manager, which I believe both are installed in 42's Campuses. As there is no special installation requirements, using the default size of 20GB for the virtual machine is enough for this project, when it comes to cores and ram, I find the defaults reasonable and they work well.

#### Installation Process

For the installation process, there is no need for graphical install, just a regular install is fine. You will be prompted for choosing a username for you account, which should be your intra login.

Aftewards you will be asked about disk partitioning, which the default `Guided - use entire disk` option is fine, as well as choosing all `all files in one partition (recommended for new users)`, you can of course set it up in a more elaborate way, but it is not the point of this project. Just proceed to `finish partitioning and write changes to disk` and confirm to write the changes.

Proceed as usual with the installation, choosing the region and Debian Archive mirror which suits you best. Now as for the **software selection** part, we should keep things to a minimum for the constraint of space, as such, just selecting SSH server (helpful for doing scp transfer into the virtual machine later on) and Standard system utilities is enough for our purposes here.

Accept installing GRUB boot loader and continue to install in the only drive available, which should be `/dev/sda/` or `/dev/nvme0n1`. Finish the Installation process.

#### Packages to install

After logging in, one should immediately switch to root with `su -` in order to install sudo as it will be necessary later on.

For installing sudo, we should update and upgrade the system as a good practice before installation:

```bash
apt-get update && apt-get install sudo -y
```

Proceed to add your user to the sudo group with:

```bash
usermod -aG sudo [username]
```

Now we need to edit sudoers file with the command:

```bash
sudo visudo
```

Right below the line that says `# User privilege specification` you should edit to make it look like this:

```bash
# User privilee specification
root    ALL=(ALL:ALL) ALL
[your username] ALL=(ALL:ALL) ALL
```

It is helpful to change the default ssh port to port 4242, and then restaring the service, which can be done with:

```bash
sudo sed -i "s|Port 22| Port 4242" /etc/ssh/sshd_config \
&& sudo service ssh restart
```
Now you can remotely access your Virtual Machine through SSH with:

```bash
ssh [username]@[VM ip address] -p 4242 
#the ip can be found with ip address cmd in your VM in inet section on enp1s0 adapter
```

A few packages are necessary before we proceed, namely for a minimal graphical interface and a browser to be able to access our infrastructure.

```bash
sudo apt-get install wget vim make openbox xinit firefox-esr -y
```

Now for setting up our docker installation (as described in the [Docker official installation guide](https://docs.docker.com/engine/install/debian/)):

1. Set up Docker's apt repository

```bash
# Add Docker's official GPG key:
sudo apt-get udpate && sudo apt-get upgrade -y
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

2. Install the Docker Packages (which includes Docker Compose)

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

3. Add your user to the Docker group

```bash
sudo gpasswd -a $USER docker
newgrp docker
```

Now that Docker is correctly setup, you can move to adding your username to the domain name in `/etc/hosts` file.

```bash
echo "127.0.0.1 [username].42.fr" | sudo tee -a /etc/hosts > /dev/null
```

You can confirm that the address has been added by using:

```bash
getent hosts [username].42.fr
```

Which should return `127.0.0.1       [username].42.fr` as an output. 
Now everything needed to start the project itself is done. One can access the xinit server by using the command `startx` which will make a black screen. If you right click with your mouse on this screen there will be a drop down menu with the options `web browser` which is where you can access your firefox browser for later accessing the website at `https://[username].42.fr/`

### Configuration Files

---

### Setting up Secrets

---

### Makefile and Docker Compose

---

When it comes to creating a project like Inception from scratch it is important to break down the services and tackle one by one. Trying to do all services at once will quickly overwhelm you and make debugging very hard.
My suggest path for setting up services is `NGINX -> Wordpress -> MariaDB`, one should familiarize with creating Dockerfiles for the each service and how to run containers without setting up Docker Compose. After setting up Wordpress, it would be the best time to start making your Docker Compose to launch multiple services.

### Docker Volumes

---

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

> :bulb: **Note**: For all the resources pertaining the general documentation and information regarding the technical aspects of this project, please refer to the README file in the [resources](README.md#resources) section.

- [User Guide Documentation](USER_DOC.md)


