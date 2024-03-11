aws cloudformation create-stack \
  --region us-gov-west-1 \
  --stack-name martin-eks-cluster \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://eks-stack.yaml 
