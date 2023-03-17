resource "aws_s3_bucket" "public_assets" {
  bucket        = "${var.domain_name}-public-assets"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "public_assets" {
  bucket = aws_s3_bucket.public_assets.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "public_assets" {
  bucket = "${var.domain_name}-public-assets"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_logging" "public_assets" {
  bucket        = "${var.domain_name}-public-assets"
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "s3-www/"
}

resource "aws_s3_bucket_policy" "public_assets" {
  bucket = aws_s3_bucket.public_assets.id
  policy = data.aws_iam_policy_document.public_assets.json
}

data "aws_iam_policy_document" "public_assets" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.public_assets.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn]
    }
  }
}

