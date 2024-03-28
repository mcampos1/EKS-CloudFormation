# To-Do
* Create service account and any other IAM resources needed for automatic creation of resources (does that include keys too?)
* --Determine whether CFN outputs are sufficient for retrieving certain things like ControlPlaneSecurityGroup--
* Create bash script to configure bastion host
    * bash script to automate configuring cluster config maps
* automate creation of VPC endpoints for different services (connection to artifactory to pull images?)
    * develop CF template to add rules to control plane security group
* test connection to private eks using private link, aws vpn or aws workspaces
* Address security controls in cluster design
    * Backup/disaster Recovery: ElasticSearch with Kibana
    * integrate splunk for logging
    * Velero to backup k8s resources
