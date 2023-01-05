# Infrastructure

## AWS Zones

- Region : `us-east-2`
  - Availability Zones : `us-east-2a`, `us-east-2b`, `us-east-2c`
- Region : `us-west-1`
  - Availability Zones : `us-west-1a`, `us-west-1c`

## Servers and Clusters

### Table 1.1 Summary

| Asset                   | Purpose                                                | Size        | Qty | DR                                    |
| ----------------------- | ------------------------------------------------------ | ----------- | --- | ------------------------------------- |
| EC2 Instance            | Ubuntu OS - Flask App                                  | t3.micro    | 6   | 3 in `us-east-2` and 3 in `us-west-1` |
| VPC                     | Provide private cloud in Multi-AZs with IP, Subnet etc | -           | 2   | 1 in `us-east-2` and `us-west-1` each |
| Kubernetes Cluster      | Host monitoring environment                            | -           | 2   | 1 in `us-east-2` and `us-west-1` each |
| Kubernetes Cluster Node | Run monitoring app stack                               | t3.medium   | 4   | 2 in `us-east-2` and 2 in `us-west-1` |
| ALB                     | Traffic redirection                                    | -           | 2   | 1 in `us-east-2` and `us-west-1` each |
| RDS Cluster             | Managed MySQL DB clusters                              | -           | 2   | 1 in `us-east-2` and `us-west-1` each |
| RDS Aurora Instances    | Store application data                                 | db.t2.small | 4   | 2 in `us-east-2` and 2 in `us-west-1` |
| Application Source Code | Contains business logic                                | -           | -   | Stored in VCS                         |
| Key Pairs               | Used to connect to instances                           | -           | -   | Replicated in DR Region               |
| S3 Bucket               | Terraform backend configuration                        | -           | -   | Replicated in DR Region               |

### Descriptions

- EC2 Instances
  - Has Ubuntu OS and runs the flask app with prometheus exporter.
- Kubernetes Cluster
  - Has nodes which hosts prometheus, grafana monitoring environment.
- VPC (Virtual Private Cloud)
  - This provides a private cloud with IPs, Availability Zones, Subnets as a
    foundation for other services.
- Application Load Balancer
  - Provides traffic redirection amongst individual instances.
- RDS Cluster
  - RDS Aurora DB (MySQL) Cluster with 2 instances (reader & writer) to store
    application data.
- Application Soure code
  - Contains the business logic for the application
- Key pairs
  - Used to connect to EC2 instances via SSH
- S3 Buckets
  - For storing terraform backend state

## DR Plan

### Pre-Steps:

- Use IaC (Terraform) to deploy infra to another region with same configuration.
- Make sure deployments are successful across regions.

## Steps:

- Fail-over Application
  - Use an Aplication Load balancer (ALB) with EC2 instances.
  - Connect the ALB with Route-53 DNS system with health checks enabled.
  - In the event of a failover Route-53 will use the health checks to check
    health/status of ALBs. And will switch the DNS hostname to resolve to the
    secondary region or zone.
- Fail-over DB
  - Make sure there are multiple RDS clusters in different regions.
  - Failing-over a DB instance in a cluster will flip the reader and writer
    instances.
  - Failing-over a primary RDS Cluster can be done manually by deleting it, and
    then the secondary replica cluster will become the primary regional cluster.
