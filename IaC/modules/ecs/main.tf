resource "aws_ecs_cluster" "this" {
  name = var.project_name
}

resource "aws_ecs_service" "this" {
  name            = var.project_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = var.task_definition_arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.sg_id]
    subnets          = [var.subnet1_id, var.subnet2_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.this.id
    container_name   = var.project_name
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.this]
}

resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.ecs_min_capacity
  max_capacity       = var.ecs_max_capacity
}

resource "aws_appautoscaling_policy" "this" {
  policy_type        = "TargetTrackingScaling"
  name               = var.autoscaling_policy_name
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  target_tracking_scaling_policy_configuration {
    target_value       = var.autoscaling_request_per_target_value
    scale_in_cooldown  = 300
    scale_out_cooldown = 300

    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_alb.this.arn_suffix}/${aws_alb_target_group.this.arn_suffix}"
    }
  }
}

resource "aws_alb" "this" {
  name            = var.project_name
  subnets         = [var.subnet1_id, var.subnet2_id]
  security_groups = [var.alb_sg_id]
}

resource "aws_alb_target_group" "this" {
  name        = var.project_name
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    port                = var.app_port
    healthy_threshold   = var.healthy_threshold
    interval            = var.health_check_interval
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    unhealthy_threshold = var.unhealthy_threshold
  }
}


resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.id
  port              = var.app_port
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_alb_target_group.this.id
    type             = "forward"
  }
}
