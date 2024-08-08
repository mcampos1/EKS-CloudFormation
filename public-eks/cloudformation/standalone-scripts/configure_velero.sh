#!/bin/bash

export PRIMARY_CLUSTER=nested-cluster-mark
export RECOVERY_CLUSTER=nested-cluster-mark-2
export ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
export BUCKET=nested-cluster-mark-bucket
export REGION=us-gov-west-1
export AWS_REGION=us-gov-west-1
export VELERO_USER=velero-$PRIMARY_CLUSTER

# Create S3 bucket if it doesn't exist
if ! aws s3 ls "s3://$BUCKET" > /dev/null 2>&1; then
    aws s3 mb s3://$BUCKET --region $REGION
else
    echo "Bucket $BUCKET already exists."
fi

cat > velero_policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws-us-gov:s3:::${BUCKET}/*",
                "arn:aws-us-gov:s3:::${BUCKET}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
    ]
}
EOF

if ! aws iam get-policy --policy-arn arn:aws-us-gov:iam::$ACCOUNT:policy/VeleroAccessPolicy > /dev/null 2>&1; then
    aws iam create-policy \
        --policy-name VeleroAccessPolicy \
        --policy-document file://velero_policy.json
else
    echo "Policy VeleroAccessPolicy already exists."
    aws iam create-policy-version \
        --policy-arn arn:aws-us-gov:iam::$ACCOUNT:policy/VeleroAccessPolicy \
        --policy-document file://velero_policy.json \
        --set-as-default
fi

# Create IAM user for Velero and attach policy
if ! aws iam get-user --user-name $VELERO_USER > /dev/null 2>&1; then
    aws iam create-user --user-name $VELERO_USER
    aws iam attach-user-policy --user-name $VELERO_USER --policy-arn arn:aws-us-gov:iam::$ACCOUNT:policy/VeleroAccessPolicy
else
    echo "User $VELERO_USER already exists."
fi

# Check if the user already has access keys and delete them
existing_keys=$(aws iam list-access-keys --user-name $VELERO_USER)
key_count=$(echo $existing_keys | jq '.AccessKeyMetadata | length')

if [ "$key_count" -gt 0 ]; then
    for key in $(echo $existing_keys | jq -r '.AccessKeyMetadata[].AccessKeyId'); do
        aws iam delete-access-key --user-name $VELERO_USER --access-key-id $key
    done
fi

# Create a new access key
access_key_output=$(aws iam create-access-key --user-name $VELERO_USER)
AWS_ACCESS_KEY_ID=$(echo $access_key_output | jq -r .AccessKey.AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo $access_key_output | jq -r .AccessKey.SecretAccessKey)

# Create the credentials-velero file
cat > credentials-velero <<EOF
[default]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
EOF

# Associate IAM OIDC provider with EKS clusters if not already associated
for CLUSTER in $PRIMARY_CLUSTER $RECOVERY_CLUSTER; do
    eksctl utils associate-iam-oidc-provider --region=$REGION --cluster=$CLUSTER --approve
done

# Install Velero CLI
VELERO_VERSION=v1.14.0
curl -LO https://github.com/vmware-tanzu/velero/releases/download/${VELERO_VERSION}/velero-${VELERO_VERSION}-linux-amd64.tar.gz
tar -zxvf velero-${VELERO_VERSION}-linux-amd64.tar.gz
sudo mv velero-${VELERO_VERSION}-linux-amd64/velero /usr/local/bin/velero
rm -rf velero-${VELERO_VERSION}-linux-amd64*

# Create namespace for Velero if it doesn't exist
if ! kubectl get ns velero &> /dev/null; then
    kubectl create ns velero
fi

# Configure Velero on Primary Cluster
velero install \
    --provider aws \
    --bucket $BUCKET \
    --secret-file ./credentials-velero \
    --backup-location-config region=$REGION \
    --snapshot-location-config region=$REGION \
    --plugins velero/velero-plugin-for-aws:v1.10.0 \
    --wait

# Patch backup storage location
kubectl patch backupstoragelocation default -n velero --type merge -p '{"spec":{"provider":"aws","objectStorage":{"bucket":"'$BUCKET'"},"config":{"region":"'$REGION'","s3ForcePathStyle":"true"}}}'

# Verify Velero Installation
velero version
kubectl get deployments -n velero
kubectl get pods -n velero