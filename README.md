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

```docker run -d --network=reddit --network-alias=post_db \ ```
```--network-alias=comment_db -v reddit_db:/data/db mongo:latest```


## HW17

```docker run --network none --rm -d --name net_test \```
``` joffotron/docker-net-tools -c "sleep 100"```

loopback only:

```docker exec -ti net_test ifconfig```

```docker run --network host --rm -d --name net_test \```
``` joffotron/docker-net-tools -c "sleep 100"```


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


## HW19

Gitlab CI

[https://docs.gitlab.com/omnibus/README.html]

[https://docs.gitlab.com/omnibus/docker/README.html]

[https://docs.gitlab.com/omnibus/docker/README.html#install-gitlab-using-docker-compose]

[https://docs.gitlab.com/ce/install/requirements.html]

```gcloud_create_gitlab_docker_machine_with_fw_rules.sh```

```eval $(docker-machine env gitlab-ci)```

-----
Install docker on Ubuntu:

```curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -```

```add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"```

```apt-get update```

```apt-get install docker-ce docker-compose```

-----

```docker-machine ssh gitlab-ci```

```mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs```

```docker-compose up -d```

Add remote to remote lakostin_microservices:

```git remote add gitlab http://35.205.90.172/homework/example.git```

```git push gitlab docker-6```


```git add .gitlab-ci.yml```

```git commit -m 'add pipeline definition'```

```git push gitlab docker-6```

```docker run -d --name gitlab-runner --restart always \ ```
```-v /srv/gitlab-runner/config:/etc/gitlab-runner \ ```
```-v /var/run/docker.sock:/var/run/docker.sock \ ```
```gitlab/gitlab-runner:latest ```

```docker exec -it gitlab-runner gitlab-runner register```

Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
http://<YOUR-VM-IP>/
Please enter the gitlab-ci token for this runner:
<TOKEN>
Please enter the gitlab-ci description for this runner:
[38689f5588fe]: my-runner
Please enter the gitlab-ci tags for this runner (comma separated):
linux,xenial,ubuntu,docker
Whether to run untagged builds [true/false]:
[false]: true
Whether to lock the Runner to current project [true/false]:
[true]: false
Please enter the executor:
docker
Please enter the default Docker image (e.g. ruby:2.1):
alpine:latest
Runner registered successfully.


```git clone https://github.com/express42/reddit.git && rm -rf ./reddit/.git```

```git add reddit/```

```git commit -m "Add reddit app"```

```git push gitlab docker-6```

```git commit -m "update gitlab-ci & add simpletest.rb and add Gem"```

Integration with Slack:

[https://gitlab.com/help/user/project/integrations/slack.md]


## HW20

```git remote add gitlab2 http://35.205.90.172/homework/example2.git```

```git push gitlab2 docker-7```

```git commit -m "test pipeline with tags"```

```git tag 2.4.10```

```git push gitlab2 docker-7 --tags```

## HW21

Create file monitoring/gcloud.sh

```docker run --rm -p 9090:9090 -d --name prometheus prom/prometheus:v2.1.0```

Build custom Prometheus image

```export USER_NAME=mrkostin```

```docker build -t $USER_NAME/prometheus:v2.1.0 .```

```for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done```


```docker-compose stop post```

```docker-compose start post```

Rebuild prometheus, then

```docker-compose down && docker-compose up -d```

Load docker-host:

```docker-machine ssh vm1```

```yes > /dev/null```

Push images

```docker login```

```for i in mrkostin/prometheus:v2.1.0 mrkostin/comment:latest \```
```mrkostin/post:latest mrkostin/ui:latest; do docker push $i; done;```


```docker-machine rm vm1```

[https://hub.docker.com/r/mrkostin/]
