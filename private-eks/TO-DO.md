Create service account and any other IAM resources needed for automatic creation of resources (does that include keys too?)
Determine whether CFN outputs are sufficient for retrieving certain things like ControlPlaneSecurityGroup
    If not, can use aws eks describe-cluster commands
Create bash script to configure bastion host