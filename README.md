# sast-two

This repository contains intentional security misconfigurations for testing SAST (Static Application Security Testing) tools like Checkov.

## Overview

This repository includes Infrastructure as Code (IaC) files with various security issues that can be detected by Checkov and similar SAST tools. The files are designed to help test and demonstrate security scanning capabilities.

## Files Included

### 1. `main.tf` - Terraform Configuration
Contains AWS infrastructure with security misconfigurations including:
- S3 buckets without encryption
- S3 buckets with public access enabled
- Security groups with unrestricted ingress (0.0.0.0/0)
- RDS instances without encryption
- Hardcoded passwords
- Publicly accessible databases
- IAM policies with wildcard permissions
- EBS volumes without encryption
- CloudTrail without log validation
- ELB with insecure SSL policy
- Missing access logs and deletion protection

### 2. `Dockerfile` - Docker Container
Contains container security issues including:
- Using `latest` tag instead of specific versions
- Running as root user (no USER directive)
- Hardcoded secrets in environment variables
- Exposing sensitive ports (SSH, RDP, Telnet)
- Using ADD instead of COPY for local files
- Missing HEALTHCHECK directive

### 3. `kubernetes.yaml` - Kubernetes Manifests
Contains Kubernetes security issues including:
- Containers running as root
- Privileged containers
- No resource limits defined
- Hardcoded secrets in environment variables
- Using `latest` image tags
- Missing readiness/liveness probes
- hostNetwork, hostPID, and hostIPC enabled
- Dangerous capabilities added (SYS_ADMIN, NET_ADMIN)
- Mounting host root directory
- Wildcard RBAC permissions
- Secrets stored in ConfigMaps

### 4. `cloudformation.yaml` - CloudFormation Template
Contains AWS CloudFormation security issues including:
- S3 buckets without encryption
- RDS instances without encryption
- Hardcoded passwords
- Security groups with unrestricted access
- IAM policies with wildcard permissions
- EBS volumes without encryption
- CloudTrail without log validation
- ELB without access logs
- Lambda functions with overly permissive roles
- ElastiCache without encryption
- Kinesis streams without encryption
- SNS topics without encryption
- SQS queues without encryption
- DynamoDB tables without encryption
- ECR repositories without image scanning

## Running Checkov

To scan this repository with Checkov:

```bash
# Install Checkov
pip install checkov

# Scan all files in the directory
checkov -d .

# Scan specific file
checkov -f main.tf
checkov -f Dockerfile
checkov -f kubernetes.yaml
checkov -f cloudformation.yaml

# Output results in JSON format
checkov -d . -o json

# Show only failed checks
checkov -d . --compact
```

## Expected Results

When running Checkov on this repository, you should see:
- **Terraform**: ~50 failed checks
- **CloudFormation**: ~43 failed checks
- **Kubernetes**: ~50 failed checks
- **Dockerfile**: ~5 failed checks
- **Secrets**: ~5 detected secrets

## Purpose

⚠️ **Warning**: This repository contains intentionally insecure code for educational and testing purposes only. Do NOT use any of this code in production environments.

These files are intended to:
- Test SAST tool capabilities
- Demonstrate common security misconfigurations
- Train security teams on identifying vulnerabilities
- Validate security scanning pipelines

## License

This is a test repository for educational purposes.