#!/usr/bin/env bash

CLUSTER_NAME='private-eks'
REGION=us-gov-west-1
HTTP_PROXY_ENDPOINT_SERVICE_NAME="" # leave blank for no proxy, or populate with a VPC endpoint ID to create a PrivateLink powered connection to a proxy server
KEY_PAIR="martin-test"
VERSION='1.27' # K8s version to deploy
AMI_ID=ami-04306748291e2183c # AWS managed AMI for EKS worker nodes
INSTANCE_TYPE=t3.large # instance type for EKS worker nodes
S3_STAGING_LOCATION=eks-staging # S3 location to be created to store Cloudformation templates and a copy of the kubectl binary
ENABLE_PUBLIC_ACCESS=false
# ENABLE_FARGATE=false
# FARGATE_PROFILE_NAME=PrivateFargateProfile
# FARGATE_NAMESPACE=fargate
