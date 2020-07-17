data "aws_iam_policy_document" "this" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecr_repository" "this" {
  name                 = var.registry_name
  image_tag_mutability = "MUTABLE"
}

data "template_file" "container_definitions" {
  template = file("./templates/ecs/container_definitions.json.tpl")

  vars = {
    app_image      = "${aws_ecr_repository.this.repository_url}:${var.app_image}"
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    project_name   = var.project_name
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.project_name
  execution_role_arn       = aws_iam_role.this.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.container_definitions.rendered
  task_role_arn            = aws_iam_role.this.arn
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30
}
