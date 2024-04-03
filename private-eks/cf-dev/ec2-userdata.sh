#!/bin/bash
yum update -y
yum install nano firewalld awscli -y
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port={80,443,8850}/tcp
firewall-cmd --reload
firewall-cmd --list-all

