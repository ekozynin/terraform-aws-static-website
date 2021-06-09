Terraform module to create a static website, backed by Cloudfront and S3 bucket.

To add additional assets to the website, upload them to the S3 bucket
``` hcl
resource "aws_s3_bucket_object" "my_file_upload" {
  bucket = module.static_website.assets_bucket
  key    = "my_file.html"
  source = "path-to-file/my_file.html"
  content_type = "text/html"
}
```