aws cloudformation create-stack \
  --region us-gov-west-1 \
  --stack-name my-eks-cluster \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://eks-stack.yaml 

#aws eks update-kubeconfig --region us-gov-west-1 --name my-eks-cluster