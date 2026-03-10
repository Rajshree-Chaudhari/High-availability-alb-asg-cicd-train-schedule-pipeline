# Train Schedule Application – High Availability CI/CD Architecture

This project demonstrates a production-style High Availability deployment architecture on AWS using:

- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Launch Templates
- Jenkins CI/CD Pipeline
- Docker-based container deployment

The system supports rolling, zero-downtime deployments across multiple Availability Zones.

---

## 🚀 Architecture Overview
            Internet
                ↓
    Application Load Balancer (ALB)
                ↓
          Target Group (HTTP:80)
                ↓
      Auto Scaling Group (Min: 2)
         ↓                    ↓
    EC2 Instance A        EC2 Instance B
    Docker Container      Docker Container
    (train-app:vX)        (train-app:vX)

    	            ↑
               Jenkins CI Server


---

## ⚙️ CI/CD Pipeline Flow

			 Developer Push
      				↓
			     GitHub
			       	↓ (Webhook)	
			Jenkins Pipeline
			        ↓
		 Docker Build (v${BUILD_NUMBER})
	        	        ↓
			Push to DockerHub
			        ↓
		Create New Launch Template Version
			        ↓
		   Trigger ASG Instance Refresh
			        ↓
		  Rolling Deployment (Multi-AZ)
	       	                ↓
	      ALB Routes Traffic to Healthy Instances





Deployment is fully automated. No manual SSH or container restarts are required.

---

## 🐳 Application Runtime

- Node.js application
- Docker containerized
- Exposed on port 80 via container runtime
- Deployed using EC2 user-data script

---

## 🔁 Deployment Strategy

Each code push triggers:

1. Docker image build with version tag `v${BUILD_NUMBER}`
2. Image pushed to DockerHub
3. New Launch Template version created
4. Auto Scaling Group instance refresh started
5. New instances launched with updated image
6. ALB routes traffic only after health checks pass

This ensures:

- Immutable deployments
- Zero downtime
- High availability across AZs

---

## 🏗 Infrastructure Architecture

-Internet-facing Application Load Balancer (ALB)
 Serves as the public entry point and distributes incoming HTTP traffic.

-Target Group with HTTP health checks
 Ensures traffic is routed only to healthy application instances.

-Auto Scaling Group (Minimum: 2 instances, Multi-AZ)
 Maintains application availability and replaces unhealthy instances automatically.

-Launch Template with versioned user-data
 Defines EC2 configuration and deployment logic for Docker container startup.

-Security Group referencing (least-privilege model)
 Ensures application instances only accept traffic from the ALB.

-Jenkins CI server with IAM role
 Jenkins securely interacts with AWS APIs to trigger infrastructure updates during deployments.

Detailed infrastructure documentation is available in:

infra/architecture.md

infra/security-groups.md

infra/asg-config.md


---

## 🔐 Security Considerations

- Application instances are not publicly exposed
- ALB is the only public entry point
- Security groups use reference-based rules
- IAM role attached to Jenkins for controlled AWS operations

---

## 🎯 Key Engineering Principles Demonstrated

- High Availability (Multi-AZ)
- Immutable infrastructure
- Rolling deployments using ASG Instance Refresh
- Health-based traffic routing via ALB
- Fully automated CI/CD using Jenkins + GitHub Webhook
- Version-controlled Docker image strategy

---

## 📌 Repository Structure
```
.
├── app.js
├── Dockerfile
├── Jenkinsfile
├── package.json
├── package-lock.json
└── infra/
    ├── provider.tf
    ├── variables.tf
    ├── data.tf
    ├── security.tf
    ├── alb.tf
    ├── launch_template.tf
    ├── autoscaling.tf
    ├── outputs.tf
    │
    ├── architecture.md
    ├── security-groups.md
    └── asg-config.md
```
---

## 📖 Purpose

This repository is part of a hands-on DevOps learning journey focused on building production-aligned infrastructure patterns on AWS.

It demonstrates how CI/CD integrates with infrastructure to enable reliable, repeatable, and zero-downtime deployments.
