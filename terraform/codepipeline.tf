resource "template_file" "buildspec" {
  template = file("buildspec.yml")
  vars = {
      DeployBucket = aws_s3_bucket.app_bucket.bucket
  }
}

resource "random_password" "webhook_secret" {
  length  = 50
  special = true
}

resource "aws_codepipeline" "codepipeline" {
  name     = "codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.app_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_username
        Repo       = var.github_project_name
        Branch     = "main"
        OAuthToken = var.github_token
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
        ProjectName = "codebuild"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.app_bucket.bucket
        Extract    = "true"
      }
    }
  }
}

resource "aws_codebuild_project" "codebuild" {
  name          = "codebuild"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type                = "CODEPIPELINE"
    buildspec           = data.template_file.buildspec.rendered
    git_clone_depth     = 1
    insecure_ssl        = false
    report_build_status = false
  }
}

resource "aws_codepipeline_webhook" "codepipeline_github_webhook" {
  name            = "codepipeline-github-webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = random_password.webhook_secret.result
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}
