variable "aws_region" {
	default = "ap-south-1"
}

variable "component_prefix" {
  default = "boringsite"
}

variable "component_name" {
  default = "website"
}

variable "bucket_name" {
  default     = ""
  description = "store files in this bucket"
}

variable "cloudfront_cdn" {
  
}

variable "cloudfront_price_class" {
  
}
