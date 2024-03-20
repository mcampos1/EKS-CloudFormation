aws cloudformation create-stack \
  --region us-gov-west-1 \
  --stack-name mimic-client \
  --template-body file://cf-dev/private-vpc-stack.yaml

aws ec2 describe-key-pairs --key-names jumpbox-keypair --query 'KeyPairs[0].KeyFingerprint'