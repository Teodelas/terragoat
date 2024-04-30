data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name                 = "Drift Instance"
    git_commit           = "04c57364d3b10465d886d072f619d4dd10e1812a"
    git_file             = "terraform/drift2/ec2.tf"
    git_last_modified_at = "2022-08-19 05:53:43"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "try-panwiac"
    git_repo             = "terragoat"
    yor_trace            = "1ba9208e-8a3e-4143-8fea-1aa7d4fa67fb"
    demo-key             = "demo-value"
  }
}
