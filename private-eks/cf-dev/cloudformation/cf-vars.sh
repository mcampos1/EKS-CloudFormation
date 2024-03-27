#!/bin/bash

## VPC Variables ##
VPC_STACK_NAME="vpc-stack"
REGION="us-gov-west-1"
VPC_ID="vpc-00801b292be62f3d9	"
WORKER_SUBNETS=("subnet-0653b88ded9a8f917 subnet-0d84899f36fcb303a")

## EKS Cluster Variables ##
CLUSTER_STACK_NAME='cluster-stack'
CLUSTER_NAME="cluster-mark"
CLUSTER_ROLE="arn:aws-us-gov:iam::713211132808:role/eksClusterRole"
KEY_PAIR="martin-test"
VERSION="1.29"
ENABLE_PRIVATE_ACCESS=true
ENABLE_PUBLIC_ACCESS=false
# CONTROLPLANE_SG=`aws cloudformation describe-stacks --stack-name ${CLUSTER_STACK_NAME} --region ${REGION} --query "Stacks[0].Parameters[?ParameterKey=='SG'].ParameterValue" --output text`


## NodeGroup Variables ##
NODEGROUP_STACK_NAME="nodegroup-stack"
NODEGROUP_NAME="nodegroup-mark"
NODEGROUP_ROLE="arn:aws-us-gov:iam::713211132808:role/eks-nodegroup-role"
VOLUME_SIZE=100
AMI_ID="ami-068d2becc83de8e98"
INSTANCE_TYPE="t3.medium"

## Bastion Host Variables ##
BASTION_STACK_NAME="bastion-stack"
BASTION_INSTANCE_TYPE="t2.micro"
BASTION_SUBNET="subnet-0c3395486e306ca6e"
BASTION_ROLE=""
BASTION_AMI_ID="ami-04306748291e2183c"
BASTION_SG_NAME="bastion-mark-sg"
# BASTION_SG_ID=`aws cloudformation describe-stacks --stack-name ${BASTION_STACK_NAME} --region ${REGION} --query "Stacks[0].Parameters[?ParameterKey=='SG'].ParameterValue" --output text`
