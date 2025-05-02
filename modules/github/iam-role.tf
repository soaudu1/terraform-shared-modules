# GitHub Actions IAM Role for OIDC AssumeRole

provider "aws" {
  region = var.aws_region
}
resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}



resource "aws_iam_role" "github_actions_role" {
  name = var.github_actions_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_org_or_user}/*:ref:refs/heads/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "920864529120"
}

variable "github_actions_role_name" {
  description = "Name of the IAM Role for GitHub Actions"
  type        = string
  default     = "github-actions-role"
}

variable "github_org_or_user" {
  description = "GitHub Organization or User"
  type        = string
  default     = "soaudu1"
}

#variable "github_repo" {
#  description = "GitHub Repository Name"
#  type        = string
#  default     = "app-deployment"
#}

#variable "github_branch" {
#  description = "GitHub Branch Name (e.g., main)"
#  type        = string
#  default     = "master"
#}

# IAM Policy for CodeArtifact Publish Access
resource "aws_iam_policy" "codeartifact_publish_policy" {
  name = "GitHubActionsCodeArtifactPublishPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "codeartifact:GetAuthorizationToken",
          "codeartifact:GetRepositoryEndpoint",
          "codeartifact:PublishPackageVersion",
          "codeartifact:ReadFromRepository"
        ],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "sts:GetServiceBearerToken",
        Effect = "Allow",
        Resource = "*",
        Condition = {
          StringEquals = {
            "sts:AWSServiceName" = "codeartifact.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Attach the CodeArtifact policy to the GitHub Actions role
resource "aws_iam_role_policy_attachment" "codeartifact_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.codeartifact_publish_policy.arn
}


resource "aws_iam_role_policy_attachment" "codeartifact_full" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeArtifactAdminAccess"
}

resource "aws_iam_role_policy_attachment" "ecr_full" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "iam_full" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "vpc_full" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}
