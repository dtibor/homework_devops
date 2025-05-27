terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_apprunner_auto_scaling_configuration_version" "default" {
  auto_scaling_configuration_name = "nodejs-app-scaling"

  max_concurrency = 100
  min_size        = 1
  max_size        = 5
}

resource "aws_apprunner_service" "nodejs_service" {
  service_name = "nodejs-app-runner-service"

  source_configuration {
    image_repository {
      image_configuration {
        port = "8080"
      }

      image_identifier      = var.docker_image
      image_repository_type = "ECR_PUBLIC"
    }

    auto_deployments_enabled = false 
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.default.arn
}

