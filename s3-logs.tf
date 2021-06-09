resource "aws_s3_bucket" "logs" {
  bucket        = "${var.domain_name}-logs"
  acl           = "log-delivery-write"
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id = "${var.domain_name}-log-archiving"
    enabled = true

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
