# ./main.tf
resource "aws_s3_bucket" "my_bucket" {
  region        = var.region
  bucket        = local.bucket_name
  acl           = var.acl
  force_destroy = true
  tags = {
    git_commit           = "83ef1b6a16427de09f9e7826b9fffc6a0cf48660"
    git_file             = "variable_example/main.tf"
    git_last_modified_at = "2024-01-18 06:28:43"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "my_bucket"
    yor_trace            = "19754895-b3d0-4316-b55f-2003bd35265b"
  }
}
