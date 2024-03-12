# Steps to deploy EKS as a private cluster 
1. Create VPC resources, nodes and databases are hosted in private subnets 
2. Provision endpoints to resources you need:
    * S3,EC2, ECR, STS (permissions for service accounts), 
3. Create EKS cluster service role: to allow control plane to manage resources
    * IAM > EKS use case
4. EKS Network Configuration, select private VPC and private subnets, select private cluster endpoint access (only accessible within VPC)
    * EKS automatically creates a security group for ENI that are created for the worker node subnets
5. Create Node Group IAM role, IAM > EC2 use cases > EKSWorkerNodePolicy & EC2ContainerRegistryReadnly (pull images from ECR)
    * Select private subnets for NodeGroup and the private VPC
    * Configure remote access to nodes (Not for production)
    * Create Secuirty group to access Worker Nodes and attach key pair
6. Create Jumpbox/Bastion, Launch Instance, has to be hosted in the same VPC as the cluster
    * If using public subnet, auto assign public IP
    * Create Security Group to allow access into JumpBox

        chmod 400 jumpbox.pem
        ssh -i path-to-key ec2-user@ipaddress

7. Install Kubectl on Jumpbox 

[Kubectl Installation](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

Install kubectl 

    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl 

Verify downloaded binary with SHa-256 checksum

    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl.sha256 

Check SHA-256 checksum for downloaded binary, should return OK

    sha256sum -c kubectl.sha256

Apply Execute permissions to the binary

    chmod +x ./kubectl

Copy the binary to a folder in your PATH

    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

Add the $HOME/bin path to your shell initialization

    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc 

Verify kubectl version

    kubectl version --client

8. Configure IAM role in jumpbox so that others may access the cluster
    * by default only the IAM principal that created the cluster is the only principal that has access to the cluster. 

[Add IAM principals to your Amazon EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html)

Install AWS CLI and configure credentials

    sudo yum install aws-cli -y
    aws configure #add aws credentials
    aws configure list
    aws sts get-caller-identity #identify user executing aws commands

configure .kube to communicate with a cluster

    aws eks update-kubeconfig --region region-code --name my-cluster

Add port 443 to cluster security group, source=jumpbox security group

    alias k=kubectl
    k cluster-info
    k get nodes

Create IAM Role for jumpbox, no specific policy is required, attach role to jumpbox instance

View which other principals have access to the cluster

    kubectl describe -n kube-system configmap/aws-auth

Make a back up of config map before making changes to it

    kubectl get cm aws-auth -n kube-system -o yaml > aws-auth.yaml

Edit config map

    kubectl edit cm aws-auth -n kube-system

add new group under mapRoles: 

    - groups:
        - system:masters
        rolearn: arn:aws:iam::111122223333:role/my-console-viewer-role #same role that is attached to ec2-instance
        username: eks-