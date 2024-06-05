# Velero Automated backups

<!-- Velero Installation

export environment variables

    export BUCKET=eks-velero-bucket
    export REGION=us-gov-west-1
    PRIMARY_CLUSTER=sample
    ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
    export PRIMARY_CONTEXT=PRIMARY
    aws eks --region $REGION update-kubeconfig --name $PRIMARY_CLUSTER --alias $PRIMARY_CONTEXT -->

### Prerequisites
 
1. **Velero CLI Installed**: Ensure you have the Velero CLI installed on your local machine.
2. **AWS CLI Configured**: Ensure the AWS CLI is installed and configured with the appropriate IAM permissions to access your EKS cluster and the S3 bucket for backups.
3. **S3 Bucket**: Create an S3 bucket to store your backups.
4. **IAM Role for Velero**: Create an IAM role with permissions for Velero to access your S3 bucket and EKS resources.
 
### Step-by-Step Guide
 
#### Step 1: Create an S3 Bucket
 
Create an S3 bucket to store Velero backups. You can do this via the AWS Management Console or using the AWS CLI:
 
```sh
aws s3 mb s3://<your-velero-backup-bucket> --region <your-region>
```
 
#### Step 2: Create an IAM Role for Velero
 
Create an IAM policy with the necessary permissions for Velero:
 
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateSnapshots",
                "ec2:DeleteSnapshot",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "ec2:DescribeVolumeAttribute",
                "ec2:DescribeVolumeStatus",
                "ec2:DescribeInstanceStatus"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::<your-velero-backup-bucket>",
                "arn:aws:s3:::<your-velero-backup-bucket>/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:CreateRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:PutRolePolicy",
                "iam:GetRole",
                "iam:PassRole",
                "iam:TagRole"
            ],
            "Resource": "arn:aws:iam::<your-account-id>:role/<your-velero-role>"
        }
    ]
}
```
 
Create the IAM role and attach the policy. You can use the AWS Management Console or the AWS CLI:
 
```sh
aws iam create-role --role-name <your-velero-role> --assume-role-policy-document file://trust-policy.json
aws iam put-role-policy --role-name <your-velero-role> --policy-name VeleroS3Access --policy-document file://velero-policy.json
```
 
#### Step 3: Install Velero
 
Install Velero using the Velero CLI:
 
```sh
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.2.1 \
    --bucket <your-velero-backup-bucket> \
    --backup-location-config region=<your-region> \
    --snapshot-location-config region=<your-region> \
    --secret-file ./credentials-velero \
    --use-restic
```
 
The `credentials-velero` file should contain your AWS credentials in the following format:
 
```ini
[default]
aws_access_key_id=<YOUR_ACCESS_KEY_ID>
aws_secret_access_key=<YOUR_SECRET_ACCESS_KEY>
```
 
#### Step 4: Create a Backup
 
Create a backup of your entire EKS cluster, including all namespaces and persistent volumes:
 
```sh
velero backup create full-cluster-backup --include-namespaces '*' --default-volumes-to-restic
```
 
This command backs up all namespaces and uses Restic to back up persistent volumes.
 
#### Step 5: Verify the Backup
 
Check the status of your backup:
 
```sh
velero backup describe full-cluster-backup --details
velero backup logs full-cluster-backup
```
 
#### Step 6: Restore the Backup
 
To restore the backup, use the following command:
 
```sh
velero restore create --from-backup full-cluster-backup
```
 
### Summary
 
This setup configures Velero to back up an entire EKS cluster, including all namespaces and persistent volumes. It leverages AWS S3 for storage and Restic for persistent volume backups. Ensure you adjust the IAM policies, S3 bucket name, and other configurations to fit your specific environment.
 
Refer to the [Velero documentation](https://velero.io/docs/latest/) for more advanced configurations and options.