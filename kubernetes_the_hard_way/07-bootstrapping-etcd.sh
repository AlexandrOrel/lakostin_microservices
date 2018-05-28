#!/bin/bash

for instance in controller-0 controller-1 controller-2; do
  gcloud compute scp controller-all-7.sh kube-proxy.kubeconfig ${instance}:~/
done

for instance in controller-0 controller-1 controller-2; do
  gcloud compute ssh ${instance} -- './controller-all-7.sh'
done
