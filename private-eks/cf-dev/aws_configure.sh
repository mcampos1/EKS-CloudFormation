#!/bin/bash
CLUSTER_NAME="private-eks"
INSTANCE_ID=i-048eaacbf7e9823aa
INSTANCE_PROFILE=arn:aws-us-gov:iam::713211132808:instance-profile/eks-bastion-role

# aws configure set aws_access_key_id $ACCESS_KEY
# aws configure set aws_secret_access_key $SECRET_KEY
aws ec2 associate-iam-instance-profile --instance-id $INSTANCE_ID --iam-instance-profile Arn=$INSTANCE_PROFILE
#set kubeconfig to point to cluster
aws eks update-kubeconfig --region us-gov-west-1 --name $CLUSTER_NAME
#create back up of config map
kubectl get cm aws-auth -n kube-system -o yaml > aws-auth.yaml
##
cat <<EOF> auth2.yaml
apiVersion: v1
  kind: ConfigMap
  metadata:
  name: aws-auth
  namespace: kube-system
  data:
  #update mapRoles
  mapRoles: | 
    - rolearn: '${NodeInstanceRole.Arn}'
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - groups:
        - system:masters
        rolearn: arn:aws-us-gov:iam::713211132808:role/eks-bastion-role #same role that is attached to ec2-instance
        username: eks-bastion-role
EOF
kubectl apply -f auth2.yaml