aws cloudformation create-stack \
  --profile default \
  --region us-gov-west-1 \
  --stack-name test-cluster-stack \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://cluster-stack.yaml 
