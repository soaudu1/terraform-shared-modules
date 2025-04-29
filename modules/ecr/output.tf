# output "repository_url" {
#   value = aws_ecr_repository.this.repository_url
# }

# output "repository_arn" {
#   value = aws_ecr_repository.this.arn
# }

# output "repository_name" {
#   value = aws_ecr_repository.this.name
# }
output "repository_urls" {
  description = "Repository URLs"
  value = { for k, repo in aws_ecr_repository.this : k => repo.repository_url }
}

output "repository_arns" {
  description = "Repository ARNs"
  value = { for k, repo in aws_ecr_repository.this : k => repo.arn }
}
