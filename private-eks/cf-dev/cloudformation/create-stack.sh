#!/bin/bash

set -e

source cf-vars.sh

STACK_NAME=${CLUSTER_NAME}-stack

aws cloudformation create-stack \
  --profile default \
  --region us-gov-west-1 \
  --stack-name test-cluster-stack \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://cluster-stack.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=$KEY_PAIR \
  ParameterKey=NodeInstanceType,ParameterValue=$INSTANCE_TYPE \
  ParameterKey=ClusterName,ParameterValue=$CLUSTER_NAME \
  ParameterKey=ClusterRoleArn,ParameterValue=$CLUSTER_ROLE \
  ParameterKey=NodeGroupName,ParameterValue=$NODE_GROUP_NAME \
  ParameterKey=NGRole,ParameterValue=$CLUSTER_ROLE