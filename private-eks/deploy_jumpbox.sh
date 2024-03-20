#!/usr/bin/env bash
set -e 

aws cloudformation create-stack \
    --region us-gov-west-1 \
    --stack-name jumpbox \
    --template-body file://cf-dev/jumpbox.yaml

sleep 10
aws ec2 describe-key-pairs --key-names jumpbox-keypair --query 'KeyPairs[0].KeyFingerprint'