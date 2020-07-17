# Infrastructure as Code (using Terraform)
## Overview
Infrastructure as code is the concept of managing and provisioning different ressources using code format. Terraform is an infrastructure as code tool which help provision and describe ressources from different cloud providers like AWS, GCP,...
This directory includes terraform files that manage backend and frontend infrastructure for the LMS project.
After developping the infrastructure as code, terraform can be used to plan and apply changes to provision new ressources in the cloud. To keep track of the existing ressources, terraform allows to store the state of the ressources locally or remotely  to share states between team members. In order to collaborate in this project, we chose `remote state management` using an S3 bucket with `state locking` using dynamodb table. These ressources are also configured through terraform files.

## Setup and usage
* Download and install terraform:
```bash
wget https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
unzip terraform_0.12.28_linux_amd64.zip
mv terraform ~/bin
terraform --version
```
* Init state:
```bash
terraform init
```
This would initialize state and use the remote state in S3.
* Always format code before commiting changes to git:
```bash
terraform fmt
```
* To see changes that would be applied by terraform:
```bash
terraform plan
```
* To apply changes:
```bash
terraform apply
```

##  Architecture
The infrastructure is illustrated by the diagram below:
![alt text](https://think-it-docs.s3.eu-central-1.amazonaws.com/Diagrams/AWS+infrastructure.png) 

The backend is containerized and hosted using AWS ECS in fargate launch type. The built images are hosted in AWS ECR.
Whenever the CI/CD pipeline is triggered, a new backend image is built and pushed to ECR, a new task definition revision is rendered and sent to AWS ECS and then the ECS service is updated with the new revision. The ECS cluster runs on the default VPC. ECS provisions the desired number of tasks and registers them to the lms target group which sits behind an application load balancer. The application load balancer routes users traffic to ECS tasks. The ECS service is also configured with service autoscaling which uses a target tracking scaling policy (the target is the count of ALB's requests per task, which means, ECS tries to keep the configured count of requests per task by scaling up or down the number of tasks). 
For the network configuration, the  ECS cluster is hosted in 2 default subnets in the default VPC. It belongs to a security group which allows only TCP traffic on port 4000.
The load balancer listens to HTTPS traffic and uses an SSL certificate associated with the backend's domain name (all configured and managed by terraform in `certificate.tf`).
The frontend website is deployed using S3 static web hosting. The website files are stored in an S3 bucket, which has the same name as the website's domain name.