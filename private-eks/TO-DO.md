# To-Do
* Create service account and any other IAM resources needed for automatic creation of resources (does that include keys too?)
* ~~Determine whether CFN outputs are sufficient for retrieving certain things like ControlPlaneSecurityGroup~~
* ~~Create bash script to configure bastion host ~~
    * ~~bash script to automate configuring cluster config maps~~
* automate creation of VPC endpoints for different services 
    * test using afrl artifactory
    ~~* develop CF template to add rules to control plane security group~~
* test connection to private eks using private link, aws vpn or aws workspaces
* Improve parameterization of base automation (vpc | cluster | bastion | nodegroup) stacks
* improve stack architecture with nesting
* Add SSH key pair creation to automation and store it in s3 to be retrieved by us to access bastion
* Address security controls in cluster design
    * Audit logs are forwarded to Splunk (install Splunk forwarder on nodes)
    * Tennants will not have Priv accts
    * Forward ECMS and container STDOUT logs to Splunk
    * Need CONOP and SSP for cluster: Access, usage, tennant onboarding, etc
    * Harden Nodes via Automated method (watchmaker)
    * Use HAProxy as bastion  (iptables enabled with AWS ACL for boundary protection)
    * Leverage kibana
    * Enable ntpq on nodes
    * Servers/services external to the cluster will be documented in the Architectural diagrams (HBSS, etc)
    * Leverage gitlab, artifactory, jenkins, etc
    * Backup and DR plans: elasticSearch, etcd, postgresdb, etc
    * Authentication to EKS management via openID auth
    * FIPS enabled 
    * Leverage Twistlock for containers
    * Vul and Virus scanning (include in SSP/CONOPS)
    * Enabled SELinux
* Bastion? Dev Desktops/Workspaces?
* Kubernetes RBAC for integration with external keycloak
* Automation of deployment of k8s manifests files 
* Internal ingress controller nginx vs HAproxy?
* Kubernetes dashboard for observability
* Add whitepapers/security documents to CONOPS references section
* Add external services/ports/protocols to CONOPS 

* Helped Mark with dodiis access 

* Develop draft of Software List
* etcd backup to S3 documentation

* openshift data foundations for tenent applications 
* EKS tie in OCM
