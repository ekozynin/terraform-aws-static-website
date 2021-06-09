variable "domain_name" {
  type = string
  description = "domain name for the website (no naked domains allowed), ex. www.example.com"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route 53 hosted zone id for the domain to redirect"
}

variable "logs_transition_ia" {
  description = "How long to wait before transitioning log files into S3-IA."
  default = 30
}

variable "logs_transition_glacier" {
  description = "How long to wait before transitioning log files into Glacier."
  default = 60
}

variable "logs_expiration" {
  description = "How long to wait before deleting old log files."
  default = 365
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = "false"
}

variable "index_document" {
  description = "Default index document for directories and website root."
  default     = "index.html"
}

variable "cache_ttl" {
  description = "Default TTL to give objects requested from S3 in CloudFront for caching."
  default     = 3600
}

// 100: Limit to only Europe, USA, and Canada endpoints.
// 200: + Hong Kong, Philippines, South Korea, Singapore, & Taiwan.
// All: + South America, and Australa.
variable "price_class" {
  description = "Which price_class to enable in CloudFront."
  default     = "PriceClass_All"
}
