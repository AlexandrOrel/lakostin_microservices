#!/bin/bash

gcloud compute firewall-rules create prometheus-default --allow tcp:9090

gcloud compute firewall-rules create puma-default --allow tcp:9292

export GOOGLE_PROJECT=docker-194911

#create docker host
docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
  --google-machine-type n1-standard-1 \
    vm1

# configure local env
eval $(docker-machine env vm1)

docker run --rm -p 9090:9090 -d --name prometheus  prom/prometheus

docker-machine ip vm1

docker stop prometheus

#35.192.5.205