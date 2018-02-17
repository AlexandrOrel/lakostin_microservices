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

