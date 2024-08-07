#!/bin/bash

set -e

source cf-vars.sh

case "$1" in
  deploy)
    files=(
      "./vpc-stack.yaml"
      "./cluster-stack.yaml"
      "./nodegroup-stack.yaml"
      "./bastion-stack.yaml"
      "../standalone-scripts/configure_bastion.sh"
      "../standalone-scripts/configure_lbc.sh"
      "../standalone-scripts/configure_velero.sh"
      "../../../k8s-manifests/test-app-service.yml"
      "../../../k8s-manifests/test-ingress.yml"
    )

    bucket="s3://cloudformation-bucket-04022024"

    for file in "${files[@]}"; do
      aws s3 cp "$file" "$bucket"
    done

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