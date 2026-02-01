*This project has been created as part of the 42 curriculum by Rapcampo*

# Contents
- [Description](#description)
- [Setup](#usage)
  - [Prerequisites](#prerequisites)
  - [Virtual Machine Setup](#virtual-machine-setup)
  - [Configuration Files](#configuration-files)
    - [How Dockerfiles Work](#how-dockerfiles-work)
    - [NGINX](#nginx)
    - [Wordpress](#Wordpress)
    - [MariaDB](#mariadb)
  - [Setting up Secrets](#setting-up-secrets)
  - [Makefile and Docker Compose](#makefile-and-docker-compose)
  - [Docker Volumes](#docker-volumes)
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
│       └── Wordpress
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

When it comes to configuration files, it is important to understand how Dockerfiles work, and how to run your Docker container without Docker Compose first. Configurations will be separated by container services, with other relevant information in between.

#### How Dockerfile Works

It is important to understand how Dockerfile works. In general, it is fairly simple if you visualize the keywords from it as a Macro for a command that interacts with the base image. The base image in this case will be Debian (oldstable, as it is required to be the penultimate version), but it can also be Alpine, which would differ slightly in folder location, commands and package names.

It is important to understand that there is a concept of layering in images, with each command running an independent shell. This can lead to artifacts if there are too many small commands, when you can just logically chain them with `&&`, which is important for image size.

Another important good practice, it is to always do a cleanup after installing packages with `apt-get clean && rm -rf /var/lib/apt/lists/*` in order to eliminate unnecessary files in order to redute image size.

Here is a brief table with important Dockerfile keywords:

| Keyword | Description |
| --- | --- |
| CMD | Specify default commands (Can be used on container startup) |
| COPY | Copy files and directories (effectively can be used from host to container) |
| ENTRYPOINT | Specify default executable (Fairly similar to CMD) |
| ENV | Set environment variables |
| EXPOSE | Describe which Ports your machine are listning on (metadata only) | 
| FROM | Creates a new build stage from an image |
| RUN | Execute build commands (much like in a shell) |

> :spiral_notepad: **NOTE**: For a complete table of commands, refer to the official [Dockerfile Reference Guide](https://docs.docker.com/reference/dockerfile/)

You can build all the Dockerfiles necessary for this project with these commands. Moreover, here is an example of what a Dockerfile for this project would look like:

```dockerfile
FROM debian:bookworm
#choose a base image for you container

RUN apt-get update \
#always update before installations
    && apt-get install [packages to be installed] \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
#for the sake of size and having less artifacts, always clean up after installations
    && mkdir -p /folder/neccessary/for/package/ \
#sometimes when installing packages the necessary folders are not automatically created, very important
    && chown -R packagegroup:packagegroup /folder/necessary/for/package
#sometimes if ownership of the folder is not given to the package group, the container may constantly restart

COPY tools/script.sh /usr/local/bin/script.sh
#effectively copying from host machine to container, in case you want to run a setup script on container startup

RUN chmod +x /usr/local/bin/script.sh
#script needs permission to be executed inside the container

EXPOSE 4242
#metadata to that will show the port this container is working with in commands such as docker ps

WORKDIR /folder/necessary/for/package/
#sometimes it is important to change to a specific folder, in case you want to execute the script from this folder path

ENTRYPOINT ["script.sh"]
#the first command/executable that will run on container startup

```

This should give a pretty good idea of how these Dockerfiles work, as a generic example and as you will see later on, we do not need to use the ENV keyword here, because we will be using it in Docker Compose, however, if you would like to test a service by itself with environment variables you can use it here also.

#### NGINX

For NGINX, you need to generate an SSL certificate (self-signed is ok) which requires the installation of OpenSSL to create the certificate. 

So for NGINX, we need the following components to make it work in this project:

- On Dockerfile:
  - nginx package
  - openssl package
  - create ssl folder inside NGINX `/etc/nginx/ssl`
  - create runtime NGINX folder `/run/nginx/`
  - create NGINX log folder `/var/log/nginx/`
  - create the certificate with openssl having the key output and certificate inside `/etc/nginx/ssl`
  - during the certificate creation fill the subject information
- On tools:
  - Create nginx.conf file for the NGINX configuration
  - Configure it to listen only to port 443 ssl
  - and the server_name to be `[username].42.fr`
  - Point to ssl_certificate and ssl_certificate_key locations pointed during creation on Dockerfile
  - Choose ssl_protocols to only `TLSv1.2 TLSv1.3`
  - Setup fastCGI proxying to work with PHP-FPM 
  - Make sure fastcgi_pass points to Wordpress on port 9000

This is pretty much it for NGINX, we can create the certificate with the following command:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=PT/ST=Porto/L=Porto/O=42inception/OU=Dev/CN=rapcampo.42.fr"
```

the OpenSSL creates a X.509 certificate signing request, which we then tell with `-x509` that we want to self-sign it, instead of generating a request. We proceed to tell OpenSSL `-nodes` to skip certificate passphrase security, in order to NGINX to be able to read the file without user intervention. We set the days of validity for the request and generate a certificate and key with `-newkey rsa:2048` using a 2048 bits long RSA key. `-keyout` and `-out` are the locations for the outputs of the request, whilist `-subj` is the information present in the certificate.

> :spiral_notepad: **Note**: for a more in depth deep dive in how to create the certificate works, check [this](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04) wonderful guide!

> :spiral_notepad: **Note**: for a more in depth guide on how to setup FastCGI proxying on NGINX read [this](https://www.digitalocean.com/community/tutorials/understanding-and-implementing-fastcgi-proxying-in-nginx#why-use-fastcgi-proxying)!

It is also very important to note that NGINX should be run in the foreground with daemon off, for Docker to be able to correctly assess the health of the container. This is quite important as Docker monitors PID 1 as the main process to be checked for health and stability of the container, which with the daemon being on, would fork off to a different PID.

##### Debugging

If everything worked correct, trying to access `https://[username].42.fr` should show a warning sign of self signed certificate, proceed should let you verify in the lock :lock: icon and clicking `connection not secure` should show a see more information button and an option `View Certificate` should be present. Otherwise, they certificate has not been generated correctly.

On the same security page info should also show in the technical details the TLS version being used. Make sure it is 1.2 or 1.3.

The certificate can also be seen in the terminal without using a browser by connecting to it with openssl on your virtual machinewith the following command:

```bash
openssl s_client -connect [username].42.fr:443 -servername [username].42.fr -showcerts </dev/null
```

Which should output the complete certificate information in great detail.

Of course, in case of errors, one should always check the logs with:

```bash
docker logs -f nginx
#can also be run with -n or --tail to print a certain number of lines

#or if Docker Compose file is ready
docker compose -f ./srcs/docker-compose.yml logs -f nginx
#this assumes you are at the root of your folder, for ease of making a remaking the project after changes
```

#### Wordpress

For the Wordpress container, you need to properly install and configure PHP-FPM, as the php language processor, since NGINX itself, cannot process php files. It is also necessary to install the wp-cli package.

Here is a breakdown of what is necessary for the Wordpress container to work properly:

- On Dockerfile:
  - Install php-fpm php-mysql curl unzip default-mysql-client packages
  - Create runtime php folder `/run/php` and the html folder default for Wordpress installations `/var/www/html`
  - Change the www.conf file to listen to port 9000 on this network (0.0.0.0)
  - Also advisable to increase the memory limit in www.conf file to avoid 502 errors
  - Give ownership of `www-data` user to the `/var/www/html` folder
  - Create a `configgroup` and add `www-data` to this group
  - Curl wp-cli and move it to $PATH
  - Run a page configuration script
- On tools:
  - Create a script for downloading, configurating and installing Wordpress core
  - On core installation, creating the Wordpress Admin credentials
  - Create a Wordpress user with the credentials
  - Finally execute php-fpm (Obs.: executing php-fpm requires the correct version to be called e.g. php-fpm8.2, otherwise the container will keep restarting)

For editing the www.conf file, there are 2 main ways to go about it. You can create a www.conf file inside your tools folder and point it in your Docker Compose as a configuration file for the container, or, simply edit the file directly upon installation with sed command like so:

```bash
sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf \
&& sed -i 's|^;php_admin_value[memory_limit]= .*|php_admin_value[memory_limit] = 512M|'\
	/etc/php/*/fpm/pool.d/www.conf
```

That way we can replace the corresponding excerpts to substitute with the information we want.

On the script we will for the first time interact with Docker Secrets, since you will need the Wordpress user password,  and Wordpress admin password. You can do so by creating a temporary variable in the script and reading from memory the secrets folder like so:

```bash
WP_ADMIN_PASSWORD="$(< /run/secrets/wp_admin_password)"
WP_DB_PASSWORD="$(< /run/secrets/wp_admin_password)"
WP_USER_PASSWORD="$(< /run/secrets/wp_admin_password)"
```

This way, you avoid leaking the secrets by avoiding having them in your environment variables.

Here is also important to have your environment variables set, preferably in the `.env` file, with the following relevant information:

```bash
DOMAIN_NAME="[username].42.fr"

WP_TITLE="INCEPTION"
WP_DB_HOST=mariadb
WP_DB_NAME=Wordpress
WP_DB_USER=dbuser

WP_ADMIN_USER=superuser
WP_ADMIN_EMAIL=superuser@example.com

WP_USER=wpuser
WP_EMAIL=wpuser@example.com

WP_URL="https://$DOMAIN_NAME"
```

It is also important to note, for the script, before installing Wordpress, that MariaDB database is running by pinging and waiting for a response. This guarantees that the database files and database user has been created in order to store the Wordpress tables.

##### Debugging

Upon accessing `https://[username].42.fr` you should never see a Wordpress installation page, if you see one, something along the lines of installation or user creation has not been working correctly.

Of course, in case of errors, one should always check the logs with:

```bash
docker logs -f wordpress
#can also be run with -n or --tail to print a certain number of lines

#or if Docker Compose file is ready
docker compose -f ./srcs/docker-compose.yml logs -f wordpress
#this assumes you are at the root of your folder, for ease of making a remaking the project after changes
```

#### MariaDB 

For the MariaDB container, to work, you need to install only a few packages, however, the complex part is in having your script run with SQL parameters for chaging root password and creating the Wordpress user.

Here is a breakdown of what is necessary for the Wordpress container to work properly:

- On Dockerfile:
  - Install gosu mariadb-server packages
  - Create runtime mysql folder `/run/mysqld` and mysql main data folder `/var/lib/mysql`
  - Grant ownership of of these directories to mysql:mysql user
- On tools:
  - The script should verify the need for database installation
  - In case there is need, `mariadb-install-db --user=mysql --datadir=/var/lib/mysql` should be run
  - After installation, a first run of `mysql mariadbd` in socket listening mode only to avoid triggering the Wordpress container installation.
  - Connect to MariaDB via socket to set root password, create Wordpress database, database user and grant all privileges on Wordpress database to that user.
  - Execute `mysql mariadbd --datadir=/var/lib/mysql --bind-address=0.0.0.0` so the database listens to this network on tcp mode.

Much like Wordpress script, here we need to read Docker Secrets from memory and create a temporary variable like so:

```bash
DB_ROOT_PASSWORD="$(< /run/secrets/db_root_pass)"
WP_DB_PASSWORD="$(< /run/secrets/db_pass)"
```

As well as use the environment variables passed to this container for the SQL part of the script. For the database and user they can be create this way:

```bash
mariadb --protocol=socket --socket="/tmp/mysql.sock" -uroot -p"$DB_ROOT_PASSWORD" <<EOSQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS \`$WP_DB_NAME\`;
CREATE USER IF NOT EXISTS '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$WP_DB_NAME\`.* TO '$WP_DB_USER'@'%';
FLUSH PRIVILEGES;
EOSQL
```

If everything went correctly, your database and user list should look like this:
```bash
docker exec -it mariadb sh -lc 'mariadb -uroot -p"$(cat /run/secrets/db_root_pass)" -e "SHOW DATABASES; SELECT user,host FROM mysql.user;"'
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| wordpress          |
+--------------------+
+-------------+-----------+
| User        | Host      |
+-------------+-----------+
| dbuser      | %         |
| mariadb.sys | localhost |
| mysql       | localhost |
| root        | localhost |
+-------------+-----------+
```

At this point, if the Wordpress installation went correctly, you should see all Wordpress tables like so:

```bash
docker exec -it mariadb sh -lc 'mariadb -uroot -p"$(cat /run/secrets/db_root_pass)" -e "USE wordpress; SHOW TABLES;"'
+-----------------------+
| Tables_in_wordpress   |
+-----------------------+
| wp_commentmeta        |
| wp_comments           |
| wp_links              |
| wp_options            |
| wp_postmeta           |
| wp_posts              |
| wp_term_relationships |
| wp_term_taxonomy      |
| wp_termmeta           |
| wp_terms              |
| wp_usermeta           |
| wp_users              |
+-----------------------+
```

#### Debugging

Particularly for MariaDB, it is very important to run logs, as it will be a clear tell if everything went correctly, the startup is very verbose and should be clear on errors.
If you setup in your Wordpress script to try and ping the MariaDB database, it should also be clear in the logs if something is wrong as there will be constant messages of connection refused from an unknown user, if proper database and user creation failed.

```bash
docker logs -f mariadb 
#can also be run with -n or --tail to print a certain number of lines

#or if Docker Compose file is ready
docker compose -f ./srcs/docker-compose.yml logs -f mariadb
#this assumes you are at the root of your folder, for ease of making a remaking the project after changes
```

The previous commands for checking the database are also very useful:

```bash
docker exec -it mariadb sh -lc 'mariadb -uroot -p"$(cat /run/secrets/db_root_pass)" -e "SHOW DATABASES; SELECT user,host FROM mysql.user;"'
docker exec -it mariadb sh -lc 'mariadb -uroot -p"$(cat /run/secrets/db_root_pass)" -e "USE wordpress; SHOW TABLES;"'
```

If you just want to access the MariaDB database and do manual checks with it, you can always log with:

```bash
docker exec -it mariadb sh -lc 'mariadb -uroot -p"$(cat /run/secrets/db_root_pass)"
```
Which will take you to the Database shell.

### Setting up Secrets

---

For setting up secrets, it is a fairly simple process with a few things to notice. First, when setting up a secret in Docker Compose, the name you give to it in the Secrets section of your script, will be the name of the file inside the container, not the name you give the file on your virtual machine. As an example:

```yml
secrets:
  wp_user_pass:
    file: ../secrets/wp_user_password.txt
  wp_admin_pass:
    file: ../secrets/wp_admin_password.txt
  db_root_pass:
    file: ../secrets/db_root_password.txt
  db_pass:
    file: ../secrets/db_password.txt
```

This mean, that the name of the secret pertaning wp_user_password.txt, will be a file named wp_user_pass inside the container. This is relevant if you want to give the files shorter names and find yourself having problems with authentication.

Another thing to notice is that the name of the secret inside container service paramenter in your Docker Compose must also followthis name, as an example:

```yaml
services:
   mariadb:
    build: ./requirements/mariadb
    image: mariadb
    pull_policy: never
    restart: unless-stopped
    container_name: mariadb
    secrets:
      - wp_admin_pass
      - db_pass
      - db_root_pass
    volumes:
      - db-data:/var/lib/mysql
    networks:
      - inception
    env_file:
      - .env
```

You can notice the names must follow the secret name and not the file name itself, unless they are the same. You can also see that the rule env_file is where you pass your `.env` file as an argument to be read by the containers, this is very important for proper credentials also.

Last important thing about Secrets is that they must never be present on a Git repository, so a `.gitignore` rule for this is very important, which will also keep your folder structure intact even without the files itself there. As such it is important to create the credentials when running the project for the first time, which can be done this way:

```bash
echo "[your_database_user_password]" > secrets/db_password.txt
echo "[your_database_root_password]" > secrets/db_root_password.txt
echo "[your_wordpress_user_password]" > secrets/wp_user_password.txt
echo "[your_wordpress_admin_password]" > secrets/wp_admin_password.txt
```

You can always check if the Secrets have been properly passed to the containers by running `docker exec -it [a service] ls -la /run/secrets/` which should output files it they exist.

### Makefile and Docker Compose

---

For the Makefile you can create a simple one with a few rules that will help you quickly setup and debug the project, my recommendation is making something like this:

```makefile
all: up

up:
	mkdir -p /home/[username]/data/mariadb
	mkdir -p /home/[username]/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down

re: 
	docker compose -f ./srcs/docker-compose.yml up -d --build --force-recreate

clean:
	docker compose -f ./srcs/docker-compose.yml down -v 

fclean:
	docker stop $$(docker ps -qa)
	docker rm $$(docker ps -qa)
	docker rmi -f $$(docker images -qa)
	docker volume rm $$(docker volume ls -q)
	docker system prune -a
	sudo rm -rf /home/[username]/data
```

It is **VERY IMPORTANT** that you create the mariadb and wordpress directories on the host machine before doing anything else, as they are necessary for the Docker Volumes to work properly in the next section.

It is also important to note that `down -v` dessociates and eliminates the volume inside the container, which can be a good telltale if something is not properly setup on the persistence, more on this next section.

For Docker Compose, as it uses YAML syntax, it is fairly simple and straight forward to make configuration files, the one thing to notice is that since there are no brackets to separate categories and logical divisions, it is indentation dependant which can be hard to visualize.

A simple example of a Docker Compose file, can be seen in this NGINX setup service:
```yaml
services:
  nginx:
    build: ./requirements/nginx
    image: nginx
    pull_policy: never
    container_name: nginx
    restart: unless-stopped
    volumes:
      - wp-data:/var/www/html
    ports:
      - 443:443
    networks:
      - inception
    configs:
      - source: nginx-nginx.conf
        target: /etc/nginx/nginx.conf
    env_file:
      - .env
    depends_on:
      - wordpress

configs:
  nginx-nginx.conf:
    file: ./requirements/nginx/tools/nginx.conf 

networks:
  inception:
    name: inception
      driver: bridge
```

In this example we can see most of the parameters needed for this project.

| Keyword | Description |
| --- | --- |
| `build` | Finds the Dockerfile target folder |
| `image` | Gives the image name |
| `pull_policy: never` | Tell Docker Compose not to try pulling the image from Dockerhub instead to use the build parameter. |
| `restart: unless_stopped` | Defines restart policy of the container |
| `volumes` | Creates a volume inside the container with the name `wp-data` |
| `ports` | Opens the port to the host machine |
| `networks` | Tells which network the container belongs to |
| `configs` | Takes a config file pointed in configs section and applies to target location |
| `env_file` | Take in the environment variables file in this paramenter, in this case, .env is in the same folder |
| `depends_on` | Tells build order for the Docker Compose file |
| `networks` | Section tells the name of the network and the driver used for it |

This is pretty much all you need to make a proper Docker Compose file for this project, it is very straight forward and simple and with the proper Makefile rules makes the workflow very simple and repeatable.

> :bulb: **Note**: You can see more relevant information about Docker Compose in the documentation [here](https://docs.docker.com/reference/cli/docker/compose/)

### Docker Volumes

---

Creating Docker Volumes to create persistance with the host machine can be a little bit tricky, one must understand why bind mounts are a bad choice for this project.
A named volume makes so that even if 

## Resources

> :bulb: **Note**: For all the resources pertaining the general documentation and information regarding the technical aspects of this project, please refer to the README file in the [resources](README.md#resources) section.

- [User Guide Documentation](USER_DOC.md)
