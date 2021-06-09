output "assets_bucket" {
  description = "S3 bucket that contains website public assets"
  value       = aws_s3_bucket.public_assets.bucket
}
