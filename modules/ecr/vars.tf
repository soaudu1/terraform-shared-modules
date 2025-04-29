# variable "aws_region" {}
# variable "name" {}
# variable "image_tag_mutability" { default = "MUTABLE" }
# variable "scan_on_push" { default = true }
# variable "tags" {
#   type    = map(string)
#   default = {}
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

