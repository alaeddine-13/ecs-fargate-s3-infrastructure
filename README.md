# ecs-fargate-s3-infrastructure
Infrastructure to deploy a containerized web application using ECS Fargate with service autoscaling and an Application Load Balancer. Frontend deployment uses S3 static web hosting setup with a cloudfront distribution.

## Architecture:
The infrastructure is composed of the following ressources:
* Backend infrastructure: Contains an ECR registry, a task definition, an ECS cluster, an ECS service associated with a target group and an Application Load Balancer, an SSL certificate and a backend A record pointing to the load balancer. The ECS service is configured with a service autoscaling (Target Tracking Autoscaling which scales based on the ALB's requests per target).
*  Frontend infrastructure: Contains an S3 bucket configured with static web hosting, alongside a cloudfront distribution, an SSL certificate and awebsite A record.


![alt text](https://github.com/alaeddine-13/ecs-fargate-s3-infrastructure/blob/master/diagrams/CI%20pipeline.png?raw=true)
