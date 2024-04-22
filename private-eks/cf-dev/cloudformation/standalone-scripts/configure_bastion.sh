#!/bin/bash

sudo yum update -y
sudo yum install nano unzip iptables-services -y #will have to manually curl and unzip awscli on non aws linux distros

# Install kubectl
curl -LOos https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

# # Update kubeconfig
aws eks update-kubeconfig --name nested-cluster-mark --region us-gov-west-1

# # Install helm
wget https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz
tar -zxvf helm-v3.10.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version