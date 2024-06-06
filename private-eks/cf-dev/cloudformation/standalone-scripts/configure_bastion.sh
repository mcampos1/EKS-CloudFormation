#!/bin/bash

sudo yum update -y
sudo yum install nano unzip iptables-services -y #will have to manually curl and unzip awscli on non aws linux distros

### Install kubectl & update kubeconfig
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.12/2024-04-19/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
aws eks update-kubeconfig --name nested-cluster-mark --region us-gov-west-1

### Install & configure helm
wget https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz
tar -zxvf helm-v3.10.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

### Install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

### Configure .bashrc
echo "alias k='kubectl'" >> ~/.bashrc
echo "alias ll='ls -la'" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc
echo ". <(eksctl completion bash)" >> ~/.bashrc
echo 'if [ -f /etc/bash_completion ]; then' >> ~/.bashrc
echo '  . /etc/bash_completion' >> ~/.bashrc
echo 'fi' >> ~/.bashrc
echo ". <(kubectl completion bash)" >> ~/.bashrc

source ~/.bashrc

