#!/bin/bash

## Stack Variables
STACK_NAME="foundation-stack"

## VPC Variables ##
REGION="us-gov-west-1"

## EKS Cluster Variables ##
# CLUSTER_NAME="nested-cluster-mark"
CLUSTER_NAME="nested-cluster-jaziz"
CLUSTER_ROLE="arn:aws-us-gov:iam::713211132808:role/eksClusterRole"
KEY_PAIR="martin-test"

## NodeGroup Variables ##
NODEGROUP_NAME="$CLUSTER_NAME-nodegroup"
NODEGROUP_ROLE="arn:aws-us-gov:iam::713211132808:role/eks-nodegroup-role"
NODEGROUP_INSTANCE_TYPE="t3.medium"
NODEGROUP_AMI_ID="ami-068d2becc83de8e98"
NODEGROUP_VOLUME_SIZE=100

## Bastion Host Variables ##
# BASTION_NAME="bastion-mark"
BASTION_NAME="bastion-jaziz"
# BASTION_ROLE="arn:aws-us-gov:iam::713211132808:role/eks-bastion-role"
BASTION_INSTANCE_TYPE="t2.micro"
# BASTION_AMI_ID="ami-04306748291e2183c"
BASTION_AMI_ID="ami-0b09154de2f794b35"
BASTION_SG_NAME="bastion-mark-sg"
