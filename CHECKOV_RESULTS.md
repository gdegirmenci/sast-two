# Checkov SAST Scan Results

This document summarizes the security issues intentionally created in this repository for Checkov detection.

## Summary Statistics

| Framework | Passed | Failed | Total |
|-----------|--------|--------|-------|
| Terraform | 20 | 50 | 70 |
| CloudFormation | 16 | 43 | 59 |
| Kubernetes | 135 | 50 | 185 |
| Dockerfile | 31 | 5 | 36 |
| Secrets | 0 | 5+ | 5+ |
| **TOTAL** | **202** | **153+** | **355+** |

## Detailed Findings by File

### 1. main.tf (Terraform)
**50 Failed Checks**

#### Critical Issues:
- **CKV_AWS_145**: S3 buckets not encrypted with KMS
- **CKV_AWS_18**: S3 bucket access logging disabled
- **CKV_AWS_53-56**: S3 public access controls disabled
- **CKV_AWS_16**: RDS not encrypted at rest
- **CKV_AWS_17**: RDS publicly accessible
- **CKV_AWS_129**: RDS logs not enabled
- **CKV_AWS_62**: IAM policies with full `*:*` permissions
- **CKV_AWS_63**: IAM policies allowing `*` as actions
- **CKV_AWS_3**: EBS volumes not encrypted
- **CKV_AWS_36**: CloudTrail log validation disabled
- **CKV_AWS_35**: CloudTrail logs not encrypted with KMS
- **CKV_AWS_24**: Security group allowing SSH from 0.0.0.0/0
- **CKV_AWS_25**: Security group allowing RDP from 0.0.0.0/0
- **CKV_AWS_260**: Security group allowing port 80 from 0.0.0.0/0

### 2. cloudformation.yaml (CloudFormation)
**43 Failed Checks**

#### Critical Issues:
- **CKV_AWS_55-56**: S3 bucket public access enabled
- **CKV_AWS_21**: S3 versioning disabled
- **CKV_AWS_16**: RDS encryption disabled
- **CKV_AWS_17**: RDS publicly accessible
- **CKV_AWS_157**: RDS Multi-AZ disabled
- **CKV_AWS_62-63**: IAM policies with wildcard permissions
- **CKV_AWS_3**: EBS volumes unencrypted
- **CKV_AWS_36**: CloudTrail validation disabled
- **CKV_AWS_131**: ALB not dropping HTTP headers
- **CKV_AWS_91**: ELB access logging disabled

### 3. kubernetes.yaml (Kubernetes)
**50 Failed Checks**

#### Critical Issues:
- **CKV_K8S_16**: Privileged containers
- **CKV_K8S_20**: allowPrivilegeEscalation enabled
- **CKV_K8S_23**: Containers running as root (UID 0)
- **CKV_K8S_10-13**: No CPU/memory limits/requests
- **CKV_K8S_14**: Using `latest` image tag
- **CKV_K8S_22**: Root filesystem not read-only
- **CKV_K8S_17-19**: hostNetwork, hostPID, hostIPC enabled
- **CKV_K8S_25**: Containers with added capabilities
- **CKV_K8S_37**: Dangerous capabilities (SYS_ADMIN, NET_ADMIN)
- **CKV_K8S_8-9**: Missing liveness/readiness probes
- **CKV_K8S_49**: ClusterRole with wildcard permissions
- **CKV_K8S_21**: Using default namespace

### 4. Dockerfile
**5 Failed Checks**

#### Critical Issues:
- **CKV_DOCKER_7**: Using `latest` tag
- **CKV_DOCKER_3**: No USER directive (running as root)
- **CKV_DOCKER_1**: Exposing port 22 (SSH)
- **CKV_DOCKER_4**: Using ADD instead of COPY
- **CKV_DOCKER_2**: No HEALTHCHECK defined

### 5. Secrets Detection
**Multiple Secrets Found**

#### Types of Secrets Detected:
- **CKV_SECRET_2**: AWS Access Keys
- **CKV_SECRET_4**: Basic Auth Credentials
- **CKV_SECRET_6**: High Entropy Base64 Strings
- **CKV_SECRET_9**: JSON Web Tokens (JWT)
- **CKV_SECRET_13**: Private Keys
- **CKV_SECRET_14**: Slack Tokens

#### Files with Secrets:
- `Dockerfile`: API keys, database passwords
- `app.py`: AWS credentials, API keys, JWT secrets, private keys
- `deploy.sh`: AWS keys, GitHub tokens, Docker passwords, Slack webhooks
- `kubernetes.yaml`: Hardcoded credentials in ConfigMaps
- `main.tf`: Hardcoded database passwords

## Security Issue Categories

### 1. Encryption Issues (Most Common)
- Resources not encrypted at rest
- Resources not encrypted in transit
- Missing KMS encryption
- No encryption for sensitive data

### 2. Access Control Issues
- Overly permissive IAM/RBAC policies
- Wildcard permissions (*:*)
- Public access enabled
- Unrestricted network access (0.0.0.0/0)

### 3. Secrets Management Issues
- Hardcoded credentials
- Secrets in environment variables
- Credentials in URLs
- API keys in code

### 4. Container Security Issues
- Running as root
- Privileged containers
- No resource limits
- Using latest tags
- Missing health checks

### 5. Logging & Monitoring Issues
- Access logging disabled
- Log validation disabled
- No CloudWatch integration
- Missing audit trails

### 6. Network Security Issues
- Security groups allowing all traffic
- Public database access
- Missing network policies
- Host network enabled

## How to Reproduce

Run Checkov on this repository:

```bash
# Full scan
checkov -d .

# Scan specific framework
checkov -d . --framework terraform
checkov -d . --framework cloudformation
checkov -d . --framework kubernetes
checkov -d . --framework dockerfile
checkov -d . --framework secrets

# Output as JSON
checkov -d . -o json -o cli

# Compact output
checkov -d . --compact
```

## Remediation Guide

For each type of issue found, refer to the Checkov documentation:
- https://www.checkov.io/
- https://docs.bridgecrew.io/docs

Each check ID (CKV_*) has detailed remediation steps in the Checkov documentation.

---

**Note**: This repository is intentionally insecure for testing purposes. Never use this code in production!
