Terraform module to create a static website, backed by Cloudfront and S3 bucket.

Example usage:

```hcl
module "static-site" {
  source = "ekozynin/static-website/aws"
  version = "~> 2.0"
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

To upload assets to the website, use the following approach:

- in your project create folder `content`
- use the following snippet to upload all html files from the folder to s3 bucket

```hcl
resource "aws_s3_object" "content" {
  for_each = fileset("./content", "**/*.html")

  bucket       = module.static-site.assets_bucket
  key          = each.key
  source       = "./content/${each.value}"
  content_type = "text/html"
  etag         = filemd5("./content/${each.value}")
}
```
