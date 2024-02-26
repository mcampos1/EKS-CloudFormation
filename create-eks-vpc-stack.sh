aws cloudformation create-stack \
  --region us-gov-west-1 \
  --stack-name my-eks-vpc \
  --template-body file://eks-vpc-stack.yaml