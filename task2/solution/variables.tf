variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "docker_image" {
  description = "Docker image URL for the Node.js app"
  type        = string
}
