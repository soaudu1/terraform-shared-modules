# resource "aws_ecr_repository" "this" {
#   name                 = var.name
#   image_tag_mutability = var.image_tag_mutability
#   image_scanning_configuration {
#     scan_on_push = var.scan_on_push
#   }
#   tags = var.tags
# }
variable "repositories" {
  description = "Map of ECR repositories to create"
  type = map(object({
    name                  = string
    image_tag_mutability  = optional(string, "MUTABLE")
    scan_on_push          = optional(bool, true)
    tags                  = optional(map(string), {})
  }))
}

# 8 repos should be repeatable for different apps
