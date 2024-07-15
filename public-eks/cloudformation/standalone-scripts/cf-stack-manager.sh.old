#!/bin/bash

set -e

source cf-vars.sh

case "$1" in
  deploy)
    case "$2" in
      foundation)
        STACK_NAME="foundation-stack"
        TEMPLATE_FILE="foundation-stack.yaml"
        aws cloudformation create-stack \
          --profile default \
          --region $REGION \
          --stack-name $STACK_NAME \
          --capabilities CAPABILITY_NAMED_IAM \
          --template-body "file://$TEMPLATE_FILE"
        ;;
      vpc)
        STACK_NAME="vpc-stack"
        TEMPLATE_FILE="vpc-stack.yaml"
        aws cloudformation create-stack \
          --profile default \
          --region $REGION \
          --stack-name $STACK_NAME \
          --capabilities CAPABILITY_NAMED_IAM \
          --template-body "file://$TEMPLATE_FILE"
        ;;
      cluster)
        STACK_NAME="cluster-stack"
        TEMPLATE_FILE="cluster-stack.yaml"
        aws cloudformation create-stack \
          --profile default \
          --region $REGION \
          --stack-name $STACK_NAME \
          --capabilities CAPABILITY_NAMED_IAM \
          --template-body "file://$TEMPLATE_FILE" \
          --parameters ParameterKey=VpcId,ParameterValue=$VPC_ID \
          ParameterKey=Subs,ParameterValue="${WORKER_SUBNETS[*]}" \
          ParameterKey=KeyName,ParameterValue=$KEY_PAIR \
          ParameterKey=ClusterRoleArn,ParameterValue=$CLUSTER_ROLE \
          ParameterKey=ClusterName,ParameterValue=$CLUSTER_NAME
        ;;
      bastion)
        STACK_NAME=$BASTION_STACK_NAME
        TEMPLATE_FILE="bastion-stack.yaml"
        BASTION_SG_ID=$(aws cloudformation describe-stacks --stack-name ${VPC_STACK_NAME} --region ${REGION} --query "Stacks[0].Outputs[?OutputKey=='BastionSubnetId'].OutputValue" --output text)
        CONTROLPLANE_SG=$(aws cloudformation describe-stacks --stack-name ${CLUSTER_STACK_NAME} --region ${REGION} --query "Stacks[0].Outputs[?OutputKey=='ControlPlaneSecurityGroup'].OutputValue" --output text)
        aws cloudformation deploy \
          --profile default \
          --region $REGION \
          --stack-name $STACK_NAME \
          --capabilities CAPABILITY_NAMED_IAM \
          --template-file $TEMPLATE_FILE \
          --parameter-overrides \
              VpcId=$VPC_ID \
              BastionInstanceType=$BASTION_INSTANCE_TYPE \
              BastionName=$BASTION_NAME \
              KeyName=$KEY_PAIR \
              AMI=$BASTION_AMI_ID \
              Subnet=$BASTION_SUBNET \
              BastionSecurityGroupName=$BASTION_SG_NAME \
              ClusterControlPlaneSecurityGroup=$CONTROLPLANE_SG
        ;;
      nodegroup)
        STACK_NAME="nodegroup-stack"
        TEMPLATE_FILE="nodegroup-stack.yaml"
        BASTION_SG=`aws cloudformation describe-stacks --stack-name ${BASTION_STACK_NAME} --region ${REGION} --query "Stacks[0].Outputs[?OutputKey=='BastionSecurityGroupId'].OutputValue" --output text`
        CONTROLPLANE_SG=`aws cloudformation describe-stacks --stack-name ${CLUSTER_STACK_NAME} --region ${REGION} --query "Stacks[0].Outputs[?OutputKey=='ControlPlaneSecurityGroup'].OutputValue" --output text`
        aws cloudformation create-stack \
          --profile default \
          --region $REGION \
          --stack-name $STACK_NAME \
          --capabilities CAPABILITY_NAMED_IAM \
          --template-body "file://$TEMPLATE_FILE" \
          --parameters ParameterKey=BastionSecurityGroup,ParameterValue=$BASTION_SG \
          ParameterKey=Subs,ParameterValue="${WORKER_SUBNETS[*]}" \
          ParameterKey=KeyName,ParameterValue=$KEY_PAIR \
          ParameterKey=ClusterName,ParameterValue=$CLUSTER_NAME \
          ParameterKey=NodeGroupRole,ParameterValue=$NODEGROUP_ROLE \
          ParameterKey=NodeInstanceType,ParameterValue=$NODEGROUP_INSTANCE_TYPE \
          ParameterKey=NodeVolumeSize,ParameterValue=$NODEGROUP_VOLUME_SIZE \
        ;;
      *)
        echo "Invalid stack type. Options: vpc, bastion, cluster"
        exit 1
        ;;
    esac
    ;;
  delete)
    case "$2" in
      vpc)
        STACK_NAME=$VPC_STACK_NAME
        ;;
      cluster)
        STACK_NAME=$CLUSTER_STACK_NAME
        ;;
      bastion)
        STACK_NAME=$BASTION_STACK_NAME
        ;;
      nodegroup)
        STACK_NAME=$NODEGROUP_STACK_NAME
        ;;
      *)
        echo "Invalid stack type. Options: vpc, cluster, bastion, nodegroup"
        exit 1
        ;;
    esac

    aws cloudformation delete-stack \
      --region "$REGION" \
      --stack-name "$STACK_NAME"
    ;;
  *)
    echo "Usage: $0 {deploy|delete} {vpc|cluster|bastion|nodegroup}"
    exit 1
    ;;
esac