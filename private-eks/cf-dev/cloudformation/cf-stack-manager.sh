#!/bin/bash

set -e

source cf-vars.sh

case "$1" in
  create)
    case "$2" in
      vpc)
        STACK_NAME="vpc-stack"
        TEMPLATE_FILE="stacks/vpc-stack.yaml"
        aws cloudformation create-stack \
          --profile default \
          --region $REGION \
          --stack-name $STACK_NAME \
          --capabilities CAPABILITY_NAMED_IAM \
          --template-body "file://$TEMPLATE_FILE"
        ;;
      bastion)
        STACK_NAME="bastion-stack-mark"
        TEMPLATE_FILE="stacks/bastion-stack.yaml"
        aws cloudformation create-stack \
          --profile default \
          --region $REGION \
          --stack-name $STACK_NAME \
          --capabilities CAPABILITY_NAMED_IAM \
          --template-body "file://$TEMPLATE_FILE" \
          --parameters ParameterKey=VpcId,ParameterValue=$VPC_ID \
          ParameterKey=BastionInstanceType,ParameterValue=$BASTION_INSTANCE_TYPE \
          ParameterKey=KeyName,ParameterValue=$KEY_PAIR \
          ParameterKey=AMI,ParameterValue=$BASTION_AMI_ID \
          ParameterKey=Subnet,ParameterValue=$BASTION_SUBNET \
          ParameterKey=BastionSecurityGroupName,ParameterValue=$BASTION_SG_NAME
        ;;
      cluster)
        STACK_NAME="cluster-stack"
        TEMPLATE_FILE="stacks/cluster-stack.yaml"
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
      nodegroup)
        STACK_NAME="nodegroup-stack"
        TEMPLATE_FILE="stacks/nodegroup-stack.yaml"
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
      *)
        echo "Invalid stack type. Options: vpc, bastion, cluster"
        exit 1
        ;;
    esac

    # aws cloudformation create-stack \
    #   --profile default \
    #   --region $REGION \
    #   --stack-name $STACK_NAME \
    #   --capabilities CAPABILITY_NAMED_IAM \
    #   --template-body "file://$TEMPLATE_FILE" 
      # --parameters ParameterKey=KeyName,ParameterValue=$KEY_PAIR \
      # ParameterKey=NodeInstanceType,ParameterValue=$INSTANCE_TYPE \
      # ParameterKey=ClusterName,ParameterValue=$CLUSTER_NAME \
      # ParameterKey=ClusterRoleArn,ParameterValue=$CLUSTER_ROLE \
      # ParameterKey=NodeGroupName,ParameterValue=$NODE_GROUP_NAME \
      # ParameterKey=NGRole,ParameterValue=$CLUSTER_ROLE
    ;;
  delete)
    case "$2" in
      vpc)
        STACK_NAME="vpc-stack"
        ;;
      bastion)
        STACK_NAME="bastion-stack"
        ;;
      cluster)
        STACK_NAME="cluster-stack"
        ;;
      *)
        echo "Invalid stack type. Options: vpc, bastion, cluster"
        exit 1
        ;;
    esac

    aws cloudformation delete-stack \
      --region "$REGION" \
      --stack-name "$STACK_NAME"
    ;;
  *)
    echo "Usage: $0 {create|delete} {vpc|bastion|cluster}"
    exit 1
    ;;
esac