# lakostin_microservices

## HW14

https://docs.docker.com/install/linux/docker-ce/fedora/#install-docker-ce-1

https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user

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

https://docs.docker.com/machine/install-machine/

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

Install Dockerfile Linter https://github.com/hadolint/hadolint

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

https://docs.docker.com/machine/reference/scp/#specifying-file-paths-for-remote-deployments

https://docs.docker.com/storage/volumes/

```docker-machine ssh docker-host```

```mkdir apps/ && mkdir apps/comment/ && mkdir apps/ui && mkdir apps/post-py```

```docker-machine scp -r comment/ docker-host:~/apps/comment/ && \```
```docker-machine scp -r post-py/ docker-host:~/apps/post-py/ && \```
```docker-machine scp -r ui/ docker-host:~/apps/ui/ ```


## HW19

Gitlab CI

https://docs.gitlab.com/omnibus/README.html

https://docs.gitlab.com/omnibus/docker/README.html

https://docs.gitlab.com/omnibus/docker/README.html#install-gitlab-using-docker-compose

https://docs.gitlab.com/ce/install/requirements.html

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

https://gitlab.com/help/user/project/integrations/slack.md


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

https://hub.docker.com/r/mrkostin/


## HW23

Create VM

```./monitoring/gcloud.sh```

# configure local env
```eval $(docker-machine env vm1)```

```docker-compose up -d

```docker-compose -f docker-compose-monitoring.yml up -d```

```export USER_NAME=mrkostin```

```docker build -t $USER_NAME/prometheus:v2.1.0 .```

```docker-compose -f docker-compose-monitoring.yml up -d grafana```

```docker build -t $USER_NAME/alertmanager .```

Test alerting

```docker-compose stop post```

```for i in mrkostin/prometheus:v2.1.0 mrkostin/comment:latest \```
```mrkostin/post:latest mrkostin/ui:latest mrkostin/alertmanager:latest; do docker push $i; done;```

```docker-machine rm vm1```

## HW25

Updated /src

```./monitoring/gcloud.sh```

```export USER_NAME=mrkostin```

```for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done```

```eval $(docker-machine env vm1)```

```docker-compose logs -f post```

```docker-compose -f docker-compose-logging.yml up -d```

```docker-compose -f docker-compose-logging.yml up -d --build```

```docker-compose stop ui```

```docker-compose rm ui```

```docker-compose up -d```

Пример с rexexp:

<filter service.ui>
  @type parser
  format /\[(?<time>[^\]]*)\]  (?<level>\S+) (?<user>\S+)[\W]*service=(?<service>\S+)[\W]*event=(?<event>\S+)[\W]*(?:path=(?<path>\S+)[\W]*)?request_id=(?<request_id>\S+)[\W]*(?:remote_addr=(?<remote_addr>\S+)[\W]*)?(?:method= (?<method>\S+)[\W]*)?(?:response_status=(?<response_status>\S+)[\W]*)?(?:message='(?<message>[^\']*)[\W]*)?/
  key_name log
</filter>

## HW 27

```./gcloud_swarm.sh```

```eval $(docker-machine env master-1)```

or

```docker-machine ssh master-1```

```docker swarm init```

additional flag --advertise-addr

Generate token:

```# docker swarm join-token manager/worker```

```eval $(docker-machine env worker-1)```

```docker swarm join --token SWMTKN-1-0qmuelk0usdzu8mt3h20vn6c6e3mh112j1feplqj1q1bt0d9hn-1kvq5wxr78lblrsu21gyxann8 10.132.0.2:2377```

```eval $(docker-machine env worker-2```

```docker swarm join --token SWMTKN-1-0qmuelk0usdzu8mt3h20vn6c6e3mh112j1feplqj1q1bt0d9hn-1kvq5wxr78lblrsu21gyxann8 10.132.0.2:2377```

```eval $(docker-machine env master-1)```

```docker node ls```


```docker stack deploy --compose-file docker-compose.yml DEV```

Docker stack doesn't support ENV vars and .env files. Workaround:

```docker stack deploy --compose-file=<(docker-compose -f docker-compose.yml config 2>/dev/null) DEV```

```docker stack services DEV```

```docker node update --label-add reliability=high master-1```

```docker node ls --filter "label=reliability"```

```docker node ls -q | xargs docker node inspect  -f '{{ .ID }} [{{ .Description.Hostname }}]: {{ .Spec.Labels }}'```

```docker stack ps DEV```

```docker stack services DEV```

Scale:

```docker service scale DEV_ui=3```

or

```docker service update --replicas 3 DEV_ui```

Turn off:

```docker service update --replicas 0 DEV_ui```


```docker service ps DEV_ui```

```docker-machine ip $(docker-machine ls -q)```

```docker inspect $(docker stack ps DEV -q --filter "Name=DEV_ui.1") --format "{{.Status.ContainerStatus.ContainerID}}"```

```docker stack deploy --compose-file=<(docker-compose -f docker-compose.monitoring.yml -f docker-compose.yml config 2>/dev/null)  DEV```

## HW 29

```curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.24.1/minikube-linux-amd64 \```
```&& chmod +x minikube && sudo mv minikube /usr/local/bin/```

```minikube start```

```kubectl get nodes```

```kubectl config current-context```

```kubectl config get-contexts```

```kubectl apply -f ui-deployment.yml```

```kubectl get deployment```

```kubectl get pods --selector component=ui```

```kubectl port-forward <pod-name> 8080:9292```

```kubectapply -f post-deployment.yml```

```kubectl get pods --selector component=post```

```kubectl port-forward <pod-name> 5000:5000```

http://localhost:5000/healthcheck

```kubectapply -f comment-deployment.yml```

```kubectl get pods --selector component=comment```

```kubectl describe service post | grep Endpoints```

```kubectl exec -ti <pod-name> nslookup post```

```kubectl port-forward <pod-name> 8080:9292```

```kubectl logs kubectl logs comment-74b6bcb855-5zqwz```

```kubectl apply -f ./```


```kubectl delete -f mongodb-service.yml```

or

```kubectl delete service mongodb```



```minikube service ui```

```minikube service list```

```minikube addons list```

```minikube addons enable dashboard```

```kubectl get pods```


```kubectl get all -n kube-system --selector app=kubernetes-dashboard```

```minikube service kubernetes-dashboard -n kube-system```

```kubectl apply -f dev-namespace.yml```

```kubectl apply -n dev -f ./```

```minikube service ui -n dev```

```kubectl apply -f  ui-deployment.yml -n dev```

# GKE

```gcloud beta container --project "docker-194911" clusters create "cluster-1" \```
```  --zone "europe-west1-d" --no-enable-basic-auth --cluster-version "1.8.8-gke.0" \```
```  --machine-type "g1-small" --image-type "COS" --disk-size "20" \```
```  --scopes "https://www.googleapis.com/auth/compute",\```
```"https://www.googleapis.com/auth/devstorage.read_only",\```
```"https://www.googleapis.com/auth/logging.write",\```
```"https://www.googleapis.com/auth/monitoring",\```
```"https://www.googleapis.com/auth/servicecontrol",\```
```"https://www.googleapis.com/auth/service.management.readonly",\```
```"https://www.googleapis.com/auth/trace.append" --num-nodes "2"\```
```  --network "default" --enable-cloud-logging --enable-cloud-monitoring\```
```  --subnetwork "default" --addons HorizontalPodAutoscaling,HttpLoadBalancing,\```
```KubernetesDashboard```

```gcloud container clusters get-credentials cluster-1 --zone europe-west1-d --project docker-194911```

```kubectl config current-context```

```kubectl apply -f ../Kube/development-namespace.yml```

```kubectl get nodes -o wide```

```kubectl describe service ui  -n dev  | grep NodePort```

```kubectl proxy```

Create Service Account for dashboard in namespace kube-system

`````````

```kubectl create clusterrolebinding kubernetes-dashboard  \```
```--clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard```

minikube stop

## HW30

```kubectl scale deployment --replicas 0 -n kube-system kube-dns-autoscaler```

```kubectl scale deployment --replicas 0 -n kube-system kube-dns```

```kubectl exec -ti -n dev post-798d89c5bb-2qcdz ping comment```

```kubectl scale deployment --replicas 1 -n kube-system kube-dns-autoscaler```


Set LoadBalancer type for UI service

```kubectl apply -f ui-service.yml -n dev```

```kubectl get service  -n dev --selector component=ui```

```kubectl apply -f ui-ingress.yml -n dev```

```kubectl get ingress -n dev```

```openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=35.190.68.7"```

```kubectl create secret tls ui-ingress --key tls.key --cert tls.crt -n dev```

```kubectl describe secret ui-ingress -n dev```

```kubectl delete ingress ui -n dev```

```kubectl apply -f ui-ingress.yml -n dev```

Network Policy

```gcloud beta container clusters list```

```gcloud beta container clusters update cluster-1 --zone=europe-west1-d \```
```  --update-addons=NetworkPolicy=ENABLED```

```gcloud beta container clusters update cluster-1 --zone=europe-west1-d  \```
```  --enable-network-policy```

```kubectl apply -f mongo-network-policy.yml -n dev```

Create Google Cloud disk

```gcloud compute disks create --size=25GB --zone=europe-west1-d reddit-mongo-disk```

```kubectl apply -f mongo-deployment.yml -n dev```


```kubectl delete deploy mongo -n dev```

```kubectl apply -f mongo-deployment.yml -n dev```

```kubectl apply -f mongo-volume.yml -n dev```

```kubectl apply -f mongo-claim.yml -n dev```

```kubectl describe storageclass standard -n dev```

```kubectl apply -f storage-fast.yml -n dev```

```kubectl apply -f mongo-claim-dynamic.yml -n dev```

```kubectl get persistentvolume -n dev```


## HW31

Install helm locally

```kubectl apply -f tiller.yml```

```helm init --service-account tiller```

```kubectl get pods -n kube-system --selector app=helm```

```helm install --name test-ui-1 ui/```

```kubectl get event```

```helm ls```

```helm install ui --name ui-1```

```helm install ui --name ui-2```

```helm install ui --name ui-3```

```kubectl get ingress```

```helm upgrade ui-1 ui/```

Download dependencies for reddit

```helm dep update```

```helm search mongo```

```helm install reddit --name reddit-test```

```helm dep update ./reddit```

```helm upgrade reddit-test ./reddit```


# GitLab +  Kubernetes

```helm repo add gitlab https://charts.gitlab.io```

```helm fetch gitlab/gitlab-omnibus --version 0.1.36 --untar```

```cd gitlab-omnibus```

```helm init --upgrade --tiller-image gcr.io/kubernetes-helm/tiller:v2.7.2```

Downgrade helm locally to 2.7.2

```helm install --name gitlab . -f values.yaml```

```kubectl get service -n nginx-ingress nginx```

```echo "35.233.107.111 gitlab-gitlab staging production" >> /etc/hosts```

```kubectl get pods```

```helm del --purge gitlab```

```helm ls --all gitlab```

Watch the status:

```kubectl get deployment -w gitlab-gitlab --namespace default```

```kubectl get svc -w --namespace nginx-ingress nginx```

```kubectl exec -it elasticsearch-attiy sh```

```kubectl logs elasticsearch-attiy -p```

Persistent volume claim:
```kubectl get pvc```

```kubectl get deployment,svc,pods,pvc,rc,rs```

```kubectl delete pod -n kube-lego kube-lego-75cf85bd4b-k9xz6```

```helm status gitlab```

```helm list```

/home/Anton/Projects/lakostin_microservices/Gitlab_ci/ui/.git/

```git init```

```git remote add origin http://gitlab-gitlab/mrkostin/ui.git```

```git add .```

```git commit -m “init”```

```git push origin master```

ui:

```git checkout -b feature/3```


## HW32

```gcloud beta container --project "docker-204007" clusters create \```
```"cluster-1" --zone "europe-west1-d" --username "admin" \```
```--cluster-version "1.8.10-gke.0" --machine-type "g1-small" \```
```--image-type "COS" --disk-type "pd-standard" --disk-size "100" \```
```--scopes "https://www.googleapis.com/auth/compute",\```
```"https://www.googleapis.com/auth/devstorage.read_only",\```
```"https://www.googleapis.com/auth/logging.write",\```
```"https://www.googleapis.com/auth/monitoring",\```
```"https://www.googleapis.com/auth/servicecontrol",\```
```"https://www.googleapis.com/auth/service.management.readonly",\```
```"https://www.googleapis.com/auth/trace.append" --num-nodes "2" \```
```--no-enable-cloud-logging --no-enable-cloud-monitoring --network \```
```"default" --subnetwork "default" --enable-legacy-authorization \```
```--addons HorizontalPodAutoscaling,HttpLoadBalancing,\```
```KubernetesDashboard --enable-autorepair```


```helm install stable/nginx-ingress --name nginx```

```helm del --purge nginx```

```kubectl get svc```

```git clone https://github.com/kubernetes/charts.git kube-charts```

```cd kube-charts ; git fetch origin pull/2767/head:prom_2.0```

```git checkout prom_2.0 ; cd ..```

```cp -r kube-charts/stable/prometheus ./```

```rm -r kube-charts```

```cd prometheus```

```helm upgrade prom . -f custom_values.yml --install```

Before installing reddit:

```helm dep update```

```helm upgrade reddit-test . --install```

```helm upgrade production --namespace production ./reddit --install```

```helm upgrade staging --namespace staging ./reddit --install```

```helm upgrade prom . -f custom_values.yml --install```

```helm upgrade --install grafana stable/grafana --set "adminPassword=admin" \```
```--set "service.type=NodePort" \```
```--set "ingress.enabled=true" \```
```--set "ingress.hosts={reddit-grafana}"```


```kubectl label node gke-cluster-1-pool-1-256c8968-hbsb elastichost=true```

```kubectl apply -f ./efk```

```helm upgrade --install kibana stable/kibana \```
```--set "ingress.enabled=true" \```
```--set "ingress.hosts={reddit-kibana}" \```
```--set "env.ELASTICSEARCH_URL=http://elasticsearch-logging:9200" \```
```--version 0.1.1```
