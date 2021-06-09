resource "aws_s3_bucket" "public_assets" {
  bucket        = "${var.domain_name}-public-assets"
  acl           = "private"
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.logs.id
    target_prefix = "s3-www/"
  }
}

resource "aws_s3_bucket_policy" "public_assets" {
  bucket = aws_s3_bucket.public_assets.id
  policy = data.aws_iam_policy_document.public_assets.json
}

data "aws_iam_policy_document" "public_assets" {
  statement {
    effect = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.public_assets.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn]
    }
  }
}

// upload default index.html & 404.html files to the s3 bucket
resource "aws_s3_bucket_object" "index_file_upload" {
  bucket = aws_s3_bucket.public_assets.bucket
  key    = "index.html"
  source = "${path.module}/html/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error_file_upload" {
  bucket = aws_s3_bucket.public_assets.bucket
  key    = "404.html"
  source = "${path.module}/html/404.html"
  content_type = "text/html"
}
