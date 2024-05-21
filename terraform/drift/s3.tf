provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "docking_bay" {
  bucket_prefix = "docking-bay-storage-"

  tags = {
    Name                 = "Docking Bay"
    Environment          = "Dev"
    git_commit           = "6078188b4f20b97eb7b8b5625c6feba5a9838040"
    git_file             = "terraform/drift/s3.tf"
    git_last_modified_at = "2022-06-07 16:02:00"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_trace            = "d23faa0f-b532-4c9b-89fc-40ae91253634"
    yor_name             = "docking_bay"
  }
}
