#!/bin/bash

## EKS Cluster Variables ##
CLUSTER_STACK_NAME='private-eks-stack'
CLUSTER_NAME='private-eks'
CLUSTER_ROLE="arn:aws-us-gov:iam::713211132808:role/eksClusterRole"
REGION=us-gov-west-1
KEY_PAIR="martin-test"
VERSION='1.29'
ENABLE_PRIVATE_ACCESS=true
ENABLE_PUBLIC_ACCESS=false
VPC_ID="vpc-038c835f86cbfbe84"
SUBNETS=("subnet-0ebf94524e98889ad" "subnet-0386ab4d6a18d1c58")

## Node Group Variables ##
NODE_GROUP_STACK_NAME="nodegroup-stack"
NODE_GROUP_NAME="nodegroup"
NODE_GROUP_ROLE="arn:aws-us-gov:iam::713211132808:role/eks-nodegroup-role"
AMI_ID=ami-068d2becc83de8e98
INSTANCE_TYPE=t3.medium

## Bastion Host Variables
BASTION_STACK_NAME="bastion-stack"
BASTION_SG=`aws cloudformation describe-stacks --stack-name ${BASTION_STACK_NAME} --region ${REGION} --query "Stacks[0].Parameters[?ParameterKey=='SG'].ParameterValue" --output text`
