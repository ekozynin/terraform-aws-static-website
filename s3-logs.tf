resource "aws_s3_bucket" "logs" {
  bucket        = "${var.domain_name}-logs"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "public_assets_encryption" {
  bucket = "${var.domain_name}-logs"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "public_assets_acl" {
  bucket = "${var.domain_name}-logs"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_lifecycle_configuration" "public_assets_lifecycle" {
  bucket = "${var.domain_name}-logs"

  rule {
    id = "${var.domain_name}-log-archiving"
    status = "Enabled"

    transition {
      days = var.logs_transition_ia
      storage_class = "STANDARD_IA"
    }

    transition {
      days = var.logs_transition_glacier
      storage_class = "GLACIER"
    }

    expiration {
      days = var.logs_expiration
    }
  }
}
