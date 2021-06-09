module "www_certificate" {
  source = "orinta-com/ssl-certificate/aws"
  version = "0.0.4"
  providers = {
    // Cloudfront only supports ACM certs issues in us-east-1
    aws = aws.cloudfront
  }

  domain_name = var.domain_name
  hosted_zone_id = var.hosted_zone_id
}
