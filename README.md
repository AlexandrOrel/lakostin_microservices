# lakostin_microservices

## HW14

[https://docs.docker.com/install/linux/docker-ce/fedora/#install-docker-ce-1]

[https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user]

docker client & server version

```docker version```

docker daemon state info

```docker info```

```docker run -it ubuntu:16.04 /bin/bash```

```docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Names}}"```

```docker start frosty_curran```

```docker attach frosty_curran```

Ctrl + p, Ctrl + q to close terminal

docker run = docker create + docker start + docker attach (only if -i option is used)

docker create - create container, do not start it

Parameteres:
-i - starts container in foreground mode (docker attach)
-d - starts container in background mode
-t - creates TTY

```docker run -it ubuntu:16.04 bash```

```docker run -dt nginx:latest```

Docker exec - runs new process inside container

kill sends SIGKILL (end of the process)
stop sends SIGTERM (stop signal), then after 10 sec sends SIGKILL

```docker kill $(docker ps -q)```

```docker system df```

delete all stopped containers

```docker rm $(docker ps -a -q)```

delete all images (only if running containers don't depend on them)

```docker rmi $(docker images -q)```

## HW15

Install docker-machine

[https://docs.docker.com/machine/install-machine/]

Create new project docker-194911 in GCP

Create new configuraion

```gcloud init```

```gcloud auth application-default login```

Check if google docker-machine is running

```docker-machine ls```

Set up the environment for the Docker client

```eval $(docker-machine env docker-host)```

Check environment

```env | grep DOCKER```

```docker run --rm -ti tehbilly/htop```

```docker run --rm --pid host -ti tehbilly/htop```

Prepare Dockerfile

```docker build -t reddit:latest .```

Show all images (with intermediate ones)

```docker images -a```

```docker run --name reddit -d --network=host reddit:latest```

Register at Docker Hub

```docker login```

```docker tag reddit:latest mrkostin/otus-reddit:1.0```

```docker push mrkostin/otus-reddit:1.0```

## HW16

Download zip archive

Install Dockerfile Linter [https://github.com/hadolint/hadolint]

Usage:

```hadolint-Linux-x86_64 ui/Dockerfile```

Create 3 Dockerfiles

```docker pull mongo:latest```

```docker build -t mrkostin/post:1.0 ./post-py```

```docker build -t mrkostin/comment:1.0 ./comment```

```docker build -t mrkostin/ui:1.0 ./ui```

```docker network create reddit```

```docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest```

```docker run -d --network=reddit --network-alias=post mrkostin/post:1.0```

```docker run -d --network=reddit --network-alias=comment mrkostin/comment:1.0```

```docker run -d --network=reddit -p 9292:9292 mrkostin/ui:1.0```

```docker kill $(docker ps -q)```

----------
Start App with rewriting ENV variables

```docker run -d --network=reddit --network-alias=db mongo:latest```

```docker run -d --env POST_DATABASE_HOST=db --network=reddit --network-alias=po mrkostin/post:1.0```

```docker run -d --env COMMENT_DATABASE_HOST=db --network=reddit --network-alias=comm mrkostin/comment:1.0```

```docker run -d --env POST_SERVICE_HOST=po --env COMMENT_SERVICE_HOST=comm --network=reddit -p 9292:9292 mrkostin/ui:1.0```

----------

Rebuild UI:

```docker build -t mrkostin/ui:2.0 ./ui```

Alpine UI:

```docker build -t mrkostin/ui:2.1 ./ui```


```docker volume create reddit_db```

```docker run -d --network=reddit --network-alias=post_db \
--network-alias=comment_db -v reddit_db:/data/db mongo:latest```


## HW17

```docker run --network none --rm -d --name net_test \
 joffotron/docker-net-tools -c "sleep 100"```

loopback only:

```docker exec -ti net_test ifconfig```

```docker run --network host --rm -d --name net_test \
 joffotron/docker-net-tools -c "sleep 100"```


```docker exec -ti net_test ifconfig```

```docker-machine ssh docker-host ifconfig```

Run

```sudo ln -s /var/run/docker/netns /var/run/netns```

...to see existing net-namespaces:

```sudo ip netns```

Run commands in chosen namespace:

```ip netns exec <namespace> <command>```


```docker network create reddit --driver bridge```

```docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest```

```docker run -d --network=reddit --network-alias=post mrkostin/post:1.0```

```docker run -d --network=reddit --network-alias=comment mrkostin/comment:1.0```

```docker run -d --network=reddit -p 9292:9292 mrkostin/ui:1.0```


Run containers within two different networks:

```docker network create back_net --subnet=10.0.2.0/24```

```docker network create front_net --subnet=10.0.1.0/24```

```docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest```

```docker run -d --network=back_net --name post mrkostin/post:1.0```

```docker run -d --network=back_net --name comment mrkostin/comment:1.0```

```docker run -d --network=front_net -p 9292:9292 --name ui mrkostin/ui:1.0```

```docker network connect front_net post```

```docker network connect front_net comment```

-----

Docker networks:

```docker-machine ssh docker-host```

```sudo apt-get update && sudo apt-get install bridge-utils```

```sudo docker network ls```

```ifconfig | grep br```

```brctl show <interface>```

```sudo iptables -nL -t nat```

```ps ax | grep docker-proxy```

-----
Docker-compose:

https://docs.docker.com/compose/install/#install-compose)
or

```pip install docker-compose```

```export USERNAME=mrkostin```

```docker-compose up -d```


Docker-compose.override.yml

[https://docs.docker.com/machine/reference/scp/#specifying-file-paths-for-remote-deployments]

[https://docs.docker.com/storage/volumes/]

```docker-machine ssh docker-host```

```mkdir apps/ && mkdir apps/comment/ && mkdir apps/ui && mkdir apps/post-py```

```docker-machine scp -r comment/ docker-host:~/apps/comment/ && \```
```docker-machine scp -r post-py/ docker-host:~/apps/post-py/ && \```
```docker-machine scp -r ui/ docker-host:~/apps/ui/ ```
