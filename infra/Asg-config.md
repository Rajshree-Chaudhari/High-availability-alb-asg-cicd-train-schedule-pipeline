# Auto Scaling Group & Deployment Configuration

## Launch Template

Defines immutable infrastructure blueprint.

Configuration:

- AMI: Ubuntu 22.04
- Instance Type: t3.micro
- Security Group: App-Server-SG
- Instances are not directly exposed to the internet.All external traffic enters through the Application Load Balancer.
- User-data script installs Docker and runs container

A new Launch Template version is created per deployment.

---
## Auto Scaling Group Configuration

Desired Capacity: 2  
Minimum Capacity: 2  
Maximum Capacity: 4  

Multi-AZ: Enabled (2 subnets)  

Health Check Type:
- ELB (ALB-based health evaluation)

---
## Instance Refresh Strategy

Triggered via Jenkins during Deployment.

Deployment flow:

1. Build new Docker image with version tag (v${BUILD_NUMBER})
2. Push image to DockerHub
3. Update Launch Template with new image tag
4. Trigger Auto Scaling Group instance refresh

ASG performs rolling replacement:

- Launch new instance using updated Launch Template
- Wait for ALB health check success
- Gradually terminate old instances

This ensures zero-downtime deployments.
