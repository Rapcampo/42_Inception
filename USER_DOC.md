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

> :bulb: **Note**: For installation and overview of the project, refer to the [Readme](README.md) in this repository.

This is a regular user facing documentation aimed to provide a high level explanation about the following contents:
- Understand what services are provided bythe stack
- Start and stop the project
- Access the website and administration panel
- Locate a manage credentials
- Check the services are running correctly

### Services Provided

---

Effectively speaking this project is a LEMP stack, which is a acronym for:

- **L**inux
- **E**ngineX (NGINX)
- **M**ariaDB
- **P**HP-FPM

Therefore, using a linux (in this case debian) base, three services are provided, with one container per service. Which are the following:

- NGINX: the only public entrypoint. It terminates TLS and serves the website over HTTPS using TLSv1.2/TLSv1.3. Effectively running as a reverse proxy
- Wordpress + PHP-FPM: the application layer. It runs Wordpress using PHP-FPM only
- MariaDB: the backend, namely database layer of this project, which stores the wordpress data

As an overview, the traffic flow can be visualized this way:

`User Browser → HTTPS → NGINX → (internal network) → Wordpress(PHP-FPM) → (internal network) → MariaDB`

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

#### Website access

To access the website, in your browser, one should access `https://[username].42.fr` (e.g. `https://rapcampo.42.fr`). This will take you to the Wordpress page, which should be already preconfigured from the get go.

> :bulb: **Note**: You can confirm the domain name is set up in `/etc/hosts` or, alternatively, running `grep [username].42.fr /etc/hosts/` in the terminal, which should return `127.0.0.1 [username].42.fr` in the standard output.

#### Worpress Admin Panel

The Administrator Panel can be accessed in `https://[username].42.fr/wp-admin/` through your browser of choice. It will take you to a login page, in which you can log in to access the panel itself. For checking and managing credentials, see bellow.

### Locating and Managing Credentials

---

1. Non-sensitive Credentials

For changing the domain name, wordpress title, database name and other non-sensitive information, please refer to `./srcs/.env` where you can change these settings according to your needs.

> :bulb: **Note**: If you want to change your domain name, make sure the domain name in `/etc/hosts` on the host machine matches the one from the `./srcs/.env` file to avoid potential issues.

2. Sensitive Credentials

For passwords such as MariaDB and Wordpress passwords, these can be found inside `./secrets/` folder, which can be changed to suit your needs.

**At run time**: When the containers are running, credentials are stored in `/run/secrets/` and are not directly accessible through environment variables, as such, they need to be read when necessary from that directory. **Obs**.: Not all secrets are available for all containers, only the strictly necessary ones for each, keep that in mind.

> :exclamation: **Important**: This step assumes you have already populated the `./secrets/` directory. If you have not, it will be empty only containing a .gitignore file to avoid leaking important files. If you need help populating your secrets folder, please refer to the [README](README.md#build) build section.

### How to Check Service Status

---

There are many ways to check if the services are running properly, as such I will list a few simple ways that you can verify everything is running as expected.

1. Quick container status check

By running `docker ps` you should see a listing of the current running containers and their uptime. It should look something like this:

```
CONTAINER ID   IMAGE       COMMAND                  CREATED        STATUS          PORTS                                     NAMES
d69dfc26bdb8   nginx       "nginx -g 'daemon of…"   17 hours ago   Up 43 minutes   0.0.0.0:443->443/tcp, [::]:443->443/tcp   nginx
edd8bacf747c   wordpress   "script.sh"              17 hours ago   Up 43 minutes   9000                                      wordpress
7095154a82b3   mariadb     "script.sh"              17 hours ago   Up 43 minutes   3306                                      mariadb
```

If there is an issue with the container, it will be restarting frequently.

2. Verify the HTTPS and the web entrypoint

Open `https://[username].42.fr` in your browser and see if everything seems normal.

You can also check that NGINX is reachable by using the command `curl -kI https://[username].42.fr/` which should return a 200, 301 or 302 code depending on setup. it should similar to this:

```
HTTP/1.1 200 OK
Server: nginx/1.22.1
Date: Sat, 31 Jan 2026 19:10:23 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
Link: <https://rapcampo.42.fr/index.php?rest_route=/>; rel="https://api.w.org/"
```

3. Use the Makefile

[These](#basic-controls) rules are helpful for debugging and making sure everything is running smoothly.

## Resources

> :bulb: **Note**: For all the resources pertaining the general documentation and information regarding the technical aspects of this project, please refer to the README file in the [resources](README.md#resources) section.

- [Developer Documentation](DEV_DOC.md)
