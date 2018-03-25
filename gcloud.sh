#!/bin/bash

gcloud compute firewall-rules create prometheus-default --allow tcp:9090

gcloud compute firewall-rules create puma-default --allow tcp:9292

export GOOGLE_PROJECT=docker-194911

#create docker host
docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
  --google-machine-type n1-standard-1 \
    vm1

docker-machine ip vm1

gcloud compute firewall-rules create cadvisor-default --allow tcp:8080

gcloud compute firewall-rules create grafana-default --allow tcp:3000

gcloud compute firewall-rules create alertmanager-default --allow tcp:9093

gcloud compute firewall-rules create fluentd-tcp-default --allow tcp:24224

gcloud compute firewall-rules create fluentd-udp-default --allow udp:24224

gcloud compute firewall-rules create elasticsearch-default --allow tcp:9200

gcloud compute firewall-rules create kibana-default --allow tcp:5601

gcloud compute firewall-rules create zipkin-default --allow tcp:9411

