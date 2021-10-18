Terraform module to create a static website, backed by Cloudfront and S3 bucket.

Example usage:

```hcl
module "static-site" {
  source = "ekozynin/static-website/aws"
  version = "~> 1.0.3"
  providers = {
    aws = aws,
    aws.cloudfront = aws.cloudfront
  }

  domain_name = "www.example.com"
  hosted_zone_id = data.aws_route53_zone.zone.id

  logs_transition_ia      = 30
  logs_transition_glacier = 60
  logs_expiration         = 90
}
```

To upload additional assets to the website, you can use the following approach:

```hcl
resource "aws_s3_bucket_object" "my_file_upload" {
  bucket = module.static_website.assets_bucket
  key    = "my_file.html"
  source = "path-to-file/my_file.html"
  content_type = "text/html"
}
```
