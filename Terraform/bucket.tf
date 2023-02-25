resource "aws_s3_bucket" "s3_bucket" {
  bucket            = "${var.bucket_name}"   
}

# making the s3 bucket private 
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket            = aws_s3_bucket.s3_bucket.id
  acl               = "public-read"
  # acl             = "private"
}

# # make the objects public
# resource "aws_s3_bucket_public_access_block" "access_block" {
#   bucket            = aws_s3_bucket.s3_bucket.id
#   block_public_acls = false 
# }

# to provision files into the bucket
module "template_files" {
  source        = "hashicorp/dir/template"
  base_dir      = "../src"
}

resource "aws_s3_object" "objects" {
  for_each      = module.template_files.files
  bucket        = aws_s3_bucket.s3_bucket.id
  key           = each.key
  content_type  = each.value.content_type
  source        = each.value.source_path
  content       = each.value.content
  etag          = each.value.digests.md5
}

resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  bucket                = aws_s3_bucket.s3_bucket.id
  cors_rule {
    allowed_headers     = ["*"]
    allowed_methods     = ["GET", "POST"]
    allowed_origins     = ["*"]
    expose_headers      = []
    max_age_seconds     = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket                = aws_s3_bucket.s3_bucket.bucket
  index_document {
    suffix              = "index.html"
  }
}