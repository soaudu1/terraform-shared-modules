variable "aws_region" {}
variable "name" {}
variable "description" { default = "" }
variable "service_role_arn" {}
variable "source_repo_url" {}
variable "buildspec_path" { default = "buildspec.yml" }
variable "compute_type" { default = "BUILD_GENERAL1_SMALL" }
variable "environment_image" { default = "aws/codebuild/standard:6.0" }
variable "privileged_mode" { default = true }
variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}

