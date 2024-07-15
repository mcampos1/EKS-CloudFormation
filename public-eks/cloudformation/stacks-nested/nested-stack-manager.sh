#!/bin/bash

set -e

source cf-vars.sh

case "$1" in
  deploy)
    aws s3 cp ./vpc-stack.yaml s3://cloudformation-bucket-04022024
    aws s3 cp ./cluster-stack.yaml s3://cloudformation-bucket-04022024
    aws s3 cp ./nodegroup-stack.yaml s3://cloudformation-bucket-04022024
    aws s3 cp ./bastion-stack.yaml s3://cloudformation-bucket-04022024
    aws s3 cp ../standalone-scripts/configure_bastion.sh s3://cloudformation-bucket-04022024
    aws cloudformation deploy \
      --profile default \
      --region $REGION \
      --stack-name $STACK_NAME \
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
        NodeGroupStackName=$NODEGROUP_STACK_NAME
    ;;
  delete)
    aws cloudformation delete-stack \
      --region $REGION \
      --stack-name $STACK_NAME
    ;;
  *)
    echo "Usage: $0 {deploy|delete}"
    exit 1
    ;;
esac