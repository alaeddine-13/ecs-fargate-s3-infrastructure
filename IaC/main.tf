module "network" {
  source       = "./modules/network"
  aws_region   = var.aws_region
  app_port     = var.app_port
  route53_zone = var.route53_zone
  project_name = var.project_name
}

module "task" {
  source                       = "./modules/task"
  aws_region                   = var.aws_region
  app_port                     = var.app_port
  ecs_task_execution_role_name = var.ecs_task_execution_role_name
  registry_name                = var.registry_name
  app_image                    = var.app_image
  fargate_cpu                  = var.fargate_cpu
  fargate_memory               = var.fargate_memory
  project_name                 = var.project_name
}


module "ecs" {
  source                               = "./modules/ecs"
  aws_region                           = var.aws_region
  app_count                            = var.app_count
  app_port                             = var.app_port
  autoscaling_policy_name              = var.autoscaling_policy_name
  autoscaling_request_per_target_value = var.autoscaling_request_per_target_value
  health_check_path                    = var.health_check_path
  task_definition_arn                  = module.task.task_definition_arn
  acm_certificate_arn                  = module.certificate_route53.acm_certificate_arn
  subnet1_id                           = module.network.subnet1_id
  subnet2_id                           = module.network.subnet2_id
  alb_sg_id                            = module.network.alb_sg_id
  sg_id                                = module.network.sg_id
  vpc_id                               = module.network.vpc_id
  project_name                         = var.project_name
  healthy_threshold                    = var.healthy_threshold
  unhealthy_threshold                  = var.unhealthy_threshold
  health_check_timeout                 = var.health_check_timeout
  health_check_interval                = var.health_check_interval
  ecs_max_capacity                     = var.ecs_max_capacity
  ecs_min_capacity                     = var.ecs_min_capacity
}


module "certificate_route53" {
  source             = "./modules/certificate_route53"
  aws_region         = var.aws_region
  certificate_domain = var.certificate_domain
  alb_endpoint       = module.ecs.alb_endpoint
  alb_zone_id        = module.ecs.alb_zone_id
  zone_id            = module.network.zone_id
}

module "website" {
  source              = "./modules/website"
  aws_region          = var.aws_region
  website_bucket_name = var.website_bucket_name
  website_domain_name = var.website_domain_name
  zone_id             = module.network.zone_id
}
