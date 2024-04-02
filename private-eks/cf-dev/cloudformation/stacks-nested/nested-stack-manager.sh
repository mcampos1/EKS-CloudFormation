#!/bin/bash

set -e

source cf-vars.sh

case "$1" in
  deploy)
    aws cloudformation deploy \
      --profile default \
      --region $REGION \
      --stack-name foundation-stack \
      --capabilities CAPABILITY_NAMED_IAM \
      --template-file foundation-stack.yaml \
      --disable-rollback \
      --parameter-overrides \
        KeyName=$KEY_PAIR \
        ClusterName=$CLUSTER_NAME \
        ClusterRoleArn=$CLUSTER_ROLE \
        BastionInstanceType=$BASTION_INSTANCE_TYPE \
        AMI=$BASTION_AMI_ID \
        BastionName=$BASTION_NAME \
        BastionSecurityGroupName=$BASTION_SG_NAME \
        NodeVolumeSize=$NODEGROUP_VOLUME_SIZE \
        NodeInstanceType=$NODEGROUP_INSTANCE_TYPE \
        NodeGroupRole=$NODEGROUP_ROLE \
    ;;
  delete)
    aws cloudformation delete-stack \
      --region $REGION \
      --stack-name foundation-stack 
    ;;
  *)
    echo "Usage: $0 {deploy|delete} {vpc|cluster|bastion|nodegroup}"
    exit 1
    ;;
esac