variable "aws_region" {
  description = "The AWS region things are created in"
}

variable "registry_name" {
  description = "The name of the ECR container registry"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
}

variable "app_count" {
  description = "Number of docker containers to run"
}

variable "health_check_path" {
  description = "The backend path for health checks"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
}

variable "certificate_domain" {
  description = "The domain name of the backend associated with ACM certificate"
}

variable "route53_zone" {
  description = "Route53 zone"
}

variable "autoscaling_policy_name" {
  description = "Name of the service autoscaling policy"
}

variable "autoscaling_request_per_target_value" {
  description = "The service autoscaling target requests per container"
}

variable "website_bucket_name" {
  description = "The bucket name of the frontend static website"
}

variable "website_domain_name" {
  description = "The domain name of the website"
}

variable "project_name" {
  description = "Name of the project"
}

variable "healthy_threshold" {
  description = "Healthy Threshold"
}

variable "unhealthy_threshold" {
  description = "Unhealthy Threshold"
}

variable "health_check_interval" {
  description = "Health check interval"
}

variable "health_check_timeout" {
  description = "Health check timeout"
}

variable "ecs_max_capacity" {
  description = "ECS maximum capacity"
}
variable "ecs_min_capacity" {
  description = "ECS minimum capacity"
}
