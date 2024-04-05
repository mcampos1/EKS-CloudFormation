#!/bin/bash
yum update -y
yum install nano firewalld unzip iptables-services -y #will have to manually curl and unzip awscli on non aws linux distros
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port={80,443,8850}/tcp
firewall-cmd --reload
#downloads kubectl v1.29
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
#set aws credentials
#export PATH=/usr/local/bin:$PATH
source ~/.bash_profile
if ! command -v aws &> /dev/null
then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install --update
fi

