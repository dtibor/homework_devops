output "service_url" {
  description = "URL to access the deployed Node.js application"
  value       = aws_apprunner_service.nodejs_service.service_url
}
