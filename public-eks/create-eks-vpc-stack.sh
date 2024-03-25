aws cloudformation create-stack \
  --region us-gov-west-1 \
  --stack-name ec2-test \
  --template-body file://ec2-stack.yaml
  #--template-body file://eks-vpc-stack.yaml
  #--template-body file://private-vpc-stack.yaml