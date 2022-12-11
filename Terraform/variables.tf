variable "aws_region" {
	default = "ap-south-1"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "region" {
  
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
