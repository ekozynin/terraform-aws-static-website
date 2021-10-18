module "www_certificate" {
  source = "ekozynin/ssl-certificate/aws"
  version = "~> 1.0.2"
  providers = {
    // Cloudfront only supports ACM certs issues in us-east-1
    aws = aws.cloudfront
  }

  domain_name = var.domain_name
  hosted_zone_id = var.hosted_zone_id
}
