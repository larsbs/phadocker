# Phadocker

**Phadocker** is phabricator docker image in combination with mysql. It
consists of two containers linked together. In one container is running a
phabricator instance and in the other container is running a mysql instance.


## Installation

Simple clone the repository:

```bash
$ git clone https://github.com/larsbs/phadocker.git
```

Then, initialize the submodules

```bash
$ git submodule init && git submodule update
```


## Configuration

All variables used in the image are in a `.env` file. A template `.env` file
called `env.sample` is provided. To configure the instance to your liking
simply rename `env.sample` to `env` and modify the values.

It's also necessary to modify the `ServerName` in
[phabricator.conf](server/phabricator.conf).


### Variables

The majority of environment variables are optional. The available variables are:


#### DB_HOST

The host of the database, by default is the name of the linked container.


#### DB_PORT

The port in which the database server is listening


#### DB_USER

The user of the database other than root. Optional.


#### DB_PASS

The password of `DB_USER`. Mandatory if `DB_USER` is specified.


#### DB_DATADIR

Datadir of mysql, by default `/var/lib/mysq`.


#### DB_LOCAL_DATADIR

In the host machine, where to mount the volume `DB_DATADIR`.


#### CONTAINER_PREFIX

The prefix of the containers.


#### CONTAINER_PHABRICATOR_NAME

The name of the phabricator container.


#### CONTAINER_DB_NAME

The name of the database container.


#### EXTERNAL_HTTP_PORT

The external port to bind the 80 port inside the phabricator container.


#### BASE_URI

The base uri in which phabricator is going to run.


#### PHABRICATOR_REPODIR

The path that phabricator is going to use to store repo files.


#### PHABRICATOR_LOCAL_REPODIR

In the host machine, where to mount the volume `PHABRICATOR_REPODIR`.


#### PHABRICATOR_LOCALDISK_PATH

The path that phabricator is going to use to store upload files.


#### PHABRICATOR_LOCAL_LOCALDISK_PATH

In the host machine, where to mount the volume `PHABRICATOR_LOCALDISK_PATH`.


#### MAILGUN_DOMAIN

The domain used in mailgun. If not specified, then mailgun is not set automatically.


#### MAILGUN_API_KEY

The API key of mailgun.


## How to run

Simply run the `run.sh` script:

```bash
$ ./run.sh  # You may need to use sudo if you don't have permissions to run docker
```


## How to clean everything

Simply run the `clean.sh` script:

```bash
$ ./clean.sh
```

By default, the script only removes the containers. In order to perform a more detailed
cleaning, you can specify two additional parameters:

 - If `-i` is specified, will also clean the images
 - If `-d` is specified, will also clean the volumes in the host machine


## LICENSE

See [LICENSE](LICENSE) for details.
