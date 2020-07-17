output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}
