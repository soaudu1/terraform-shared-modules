resource "aws_codebuild_project" "this" {
  name          = var.name
  description   = var.description
  service_role  = var.service_role_arn

  source {
    type      = "BITBUCKET"
    location  = var.source_repo_url
    buildspec = var.buildspec_path
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.environment_image
    type                        = "LINUX_CONTAINER"
    privileged_mode             = var.privileged_mode
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }

  }

  tags = var.tags
}