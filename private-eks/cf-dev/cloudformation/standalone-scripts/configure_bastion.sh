#!/bin/bash

sudo yum update -y
sudo yum install nano unzip iptables-services -y #will have to manually curl and unzip awscli on non aws linux distros

# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

# Install aws cli
source ~/.bash_profile
if ! command -v aws &> /dev/null
then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install --update
fi

# # Update kubeconfig
aws eks update-kubeconfig --name nested-cluster-mark --region us-gov-west-1

# # Install eksctl
# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
# mv /tmp/eksctl /usr/local/bin

# # Install helm
# curl https://github.com/helm/helm/releases/helm-v3.14.4-linux-amd64.tar.gz
# tar -zxvf helm-v3.0.0-linux-amd64.tar.gz
# mv linux-amd64/helm /usr/local/bin/helm

# sudo systemctl enable firewalld
# sudo systemctl start firewalld
# sudo firewall-cmd --permanent --add-port=22/tcp
# sudo firewall-cmd --permanent --add-port=80/tcp
# sudo firewall-cmd --permanent --add-port=443/tcp
# sudo firewall-cmd --permanent --add-port=8850/tcp
# sudo firewall-cmd --reload