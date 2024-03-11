aws cloudformation create-stack \
  --region us-gov-west-1 \
  --stack-name martin-eks-vpc \
  --template-body file://eks-vpc-stack.yaml
  #--template-body file://private-vpc-stack.yaml