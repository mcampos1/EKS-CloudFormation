#!/bin/bash
yum update -y
yum install nano firewalld awscli -y
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port={80,443,8850}/tcp
firewall-cmd --reload
firewall-cmd --list-all
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
aws eks update-kubeconfig --region region-code --name my-cluster
