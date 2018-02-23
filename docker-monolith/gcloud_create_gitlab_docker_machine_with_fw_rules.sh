#!/bin/bash

docker-machine create --driver google \
--google-project docker-194911 \
--google-zone europe-west1-b \
--google-machine-type n1-standard-1 \
--google-disk-size 80 \
--google-machine-image $(gcloud compute images list --filter ubuntu-1604-lts --uri) \
  gitlab-ci;

gcloud compute --project=docker-194911 firewall-rules create default-allow-http \
--network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 \
--target-tags=docker-machine;

gcloud compute --project=docker-194911 firewall-rules create default-allow-https \
--network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 \
--target-tags=docker-machine;
