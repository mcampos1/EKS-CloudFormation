#!/bin/bash

## VPC Variables ##
VPC_STACK_NAME="vpc-stack"
REGION="us-gov-west-1"

## EKS Cluster Variables ##
CLUSTER_STACK_NAME="nested-cluster-stack"
CLUSTER_NAME="nested-cluster-mark"
CLUSTER_ROLE="arn:aws-us-gov:iam::713211132808:role/eksClusterRole"
KEY_PAIR="martin-test"
VERSION="1.29"

## NodeGroup Variables ##
NODEGROUP_STACK_NAME="nodegroup-stack"
NODEGROUP_NAME="$CLUSTER_NAME-nodegroup"
NODEGROUP_ROLE="arn:aws-us-gov:iam::713211132808:role/eks-nodegroup-role"
NODEGROUP_INSTANCE_TYPE="t3.medium"
NODEGROUP_AMI_ID="ami-068d2becc83de8e98"
NODEGROUP_VOLUME_SIZE=100

## Bastion Host Variables ##
BASTION_STACK_NAME="bastion-stack-mark"
BASTION_NAME="bastion-mark"
BASTION_ROLE="arn:aws-us-gov:iam::713211132808:role/eks-bastion-role"
BASTION_INSTANCE_TYPE="t2.micro"
BASTION_AMI_ID="ami-04306748291e2183c"
BASTION_SG_NAME="bastion-mark-sg"
