resource "aws_codepipeline" "this" {
  name     = var.name
  role_arn = var.role_arn

  artifact_store {
    location = var.artifact_store_s3
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "Bitbucket"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner      = var.bitbucket_owner
        Repo       = var.bitbucket_repo
        Branch     = var.bitbucket_branch
        OAuthToken = var.bitbucket_oauth_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
}
