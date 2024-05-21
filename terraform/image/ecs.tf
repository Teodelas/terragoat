resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "nginx"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "second"
      image     = "python:3.9-alpine"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])
  tags = {
    git_commit           = "c3ee16cc6009f4b2589ec9f02d3bd8db6ba9e88e"
    git_file             = "terraform/image/ecs.tf"
    git_last_modified_at = "2022-10-02 15:14:16"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_trace            = "d2f8ae8f-3419-414c-84da-d72250e8dbe6"
    yor_name             = "service"
  }
}
