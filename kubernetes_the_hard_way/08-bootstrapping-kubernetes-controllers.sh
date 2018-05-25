#!/bin/bash

for instance in controller-0 controller-1 controller-2; do
  gcloud compute scp update_openssl.sh controller-all-8.sh kube-proxy.kubeconfig ${instance}:~/
done

# Update OpenSSl on controller servers

for instance in controller-0 controller-1 controller-2; do
  gcloud compute ssh ${instance} -- './update_openssl.sh && ./controller-all-8.sh'
done

# Create the external load balancer network resources:

gcloud compute target-pools create kubernetes-target-pool

gcloud compute target-pools add-instances kubernetes-target-pool \
  --instances controller-0,controller-1,controller-2

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(name)')

gcloud compute forwarding-rules create kubernetes-forwarding-rule \
  --address ${KUBERNETES_PUBLIC_ADDRESS} \
  --ports 6443 \
  --region $(gcloud config get-value compute/region) \
  --target-pool kubernetes-target-pool


# Verification

# Retrieve the kubernetes-the-hard-way static IP address:

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

# Make a HTTP request for the Kubernetes version info:

curl --cacert ca.pem https://${KUBERNETES_PUBLIC_ADDRESS}:6443/version
