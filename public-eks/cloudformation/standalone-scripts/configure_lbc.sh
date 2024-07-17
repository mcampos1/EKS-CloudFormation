#!/bin/bash

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.8.1/docs/install/iam_policy_us-gov.json

eksctl utils associate-iam-oidc-provider --region=us-gov-west-1 --cluster=nested-cluster-mark-3 --approve

eksctl create iamserviceaccount --cluster=nested-cluster-mark-3 --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::713211132808:policy/AWSLoadBalancerControllerIAMPolicy --override-existing-serviceaccounts --region us-gov-west-1 --approve

wget https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml

kubectl apply -f crds.yaml

helm repo add eks https://aws.github.io/eks-charts

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=nested-cluster-mark-3 --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller