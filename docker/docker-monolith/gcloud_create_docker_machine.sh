#!/bin/bash

docker-machine create --driver google \
--google-project docker-194911 \
--google-zone europe-west1-b \
--google-machine-type g1-small \
--google-machine-image $(gcloud compute images list --filter ubuntu-1604-lts --uri) \
  docker-host
