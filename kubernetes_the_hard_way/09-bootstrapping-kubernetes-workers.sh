#!/bin/bash

for instance in worker-0 worker-1 worker-2; do
  gcloud compute scp worker-all-9.sh kube-proxy.kubeconfig ${instance}:~/
done

for instance in worker-0 worker-1 worker-2; do
  gcloud compute ssh ${instance} -- './worker-all-9.sh'
done

# Verification

# Login to one of the controller nodes & List the registered Kubernetes nodes:

gcloud compute ssh controller-0 -- 'kubectl get nodes'

