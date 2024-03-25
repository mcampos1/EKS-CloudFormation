aws cloudformation create-stack \
  --region us-gov-west-1 \
  --stack-name bastion-stack \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://ec2-stack.yaml 
