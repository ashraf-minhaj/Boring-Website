# create a bucket data source notification for lambda to be invoked by
data "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"   
  # policy = data.aws_iam_policy_document.website_policy.json
  # website {
  #   index_document = "index.html"
  #   error_document = "index.html"
  #   }
}

# making the s3 bucket private 
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = data.aws_s3_bucket.s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "objects" {
  for_each = fileset("../src/", "*")
  bucket = data.aws_s3_bucket.s3_bucket.id
  key = each.value
  source = "../src/${each.value}"
  etag = filemd5("../src/${each.value}")
}