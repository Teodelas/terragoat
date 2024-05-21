provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  user_data = <<-EOT
    #!/bin/bash
    echo "Hello Terraform!"
  EOT

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  }
}

################################################################################
# EC2 Module
################################################################################

module "ec2_complete" {
  source = "../../"

  name = local.name

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "c5.xlarge" # used to set core count below
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  placement_group             = aws_placement_group.web.id
  associate_public_ip_address = true
  disable_api_stop            = false

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  # only one of these can be enabled at a time
  hibernation = true
  # enclave_options_enabled = true

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  cpu_core_count       = 2 # default 4
  cpu_threads_per_core = 1 # default 2

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 5
      throughput  = 200
      encrypted   = true
      kms_key_id  = aws_kms_key.this.arn
      tags = {
        MountPoint = "/mnt/data"
      }
    }
  ]

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_complete"
    yor_trace            = "afa0e189-9dd3-48a4-957b-efdf86cacf0e"
  })
}

module "ec2_network_interface" {
  source = "../../"

  name = "${local.name}-network-interface"

  network_interface = [
    {
      device_index          = 0
      network_interface_id  = aws_network_interface.this.id
      delete_on_termination = false
    }
  ]

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_network_interface"
    yor_trace            = "5cd3f556-2933-44a4-97d7-9ab2c6c69485"
  })
}

module "ec2_metadata_options" {
  source = "../../"

  name = "${local.name}-metadata-options"

  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security_group.security_group_id]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
    instance_metadata_tags      = "enabled"
  }

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_metadata_options"
    yor_trace            = "5be52e12-9171-412d-aef4-5cbf07cce00f"
  })
}

module "ec2_t2_unlimited" {
  source = "../../"

  name = "${local.name}-t2-unlimited"

  instance_type               = "t2.micro"
  cpu_credits                 = "unlimited"
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true

  maintenance_options = {
    auto_recovery = "default"
  }

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_t2_unlimited"
    yor_trace            = "dd42bf17-b795-4db8-8656-8e60e024c4f5"
  })
}

module "ec2_t3_unlimited" {
  source = "../../"

  name = "${local.name}-t3-unlimited"

  instance_type               = "t3.micro"
  cpu_credits                 = "unlimited"
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_t3_unlimited"
    yor_trace            = "feaac01c-6c89-4fb4-8d1c-7aa688b2a8f4"
  })
}


module "ec2_disabled" {
  source = "../../"

  create = false
}

################################################################################
# EC2 Module - multiple instances with `for_each`
################################################################################

locals {
  multiple_instances = {
    one = {
      instance_type     = "t3.micro"
      availability_zone = element(module.vpc.azs, 0)
      subnet_id         = element(module.vpc.private_subnets, 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 50
          tags = {
            Name = "my-root-block"
          }
        }
      ]
    }
    two = {
      instance_type     = "t3.small"
      availability_zone = element(module.vpc.azs, 1)
      subnet_id         = element(module.vpc.private_subnets, 1)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp2"
          volume_size = 50
        }
      ]
    }
    three = {
      instance_type     = "t3.medium"
      availability_zone = element(module.vpc.azs, 2)
      subnet_id         = element(module.vpc.private_subnets, 2)
    }
  }
}

module "ec2_multiple" {
  source = "../../"

  for_each = local.multiple_instances

  name = "${local.name}-multi-${each.key}"

  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [module.security_group.security_group_id]

  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_multiple"
    yor_trace            = "c148e18f-6cab-453a-b5f0-2e5ca098279e"
  })
}

################################################################################
# EC2 Module - spot instance request
################################################################################

module "ec2_spot_instance" {
  source = "../../"

  name                 = "${local.name}-spot-instance"
  create_spot_instance = true

  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true

  # Spot request specific attributes
  spot_price                          = "0.1"
  spot_wait_for_fulfillment           = true
  spot_type                           = "persistent"
  spot_instance_interruption_behavior = "terminate"
  # End spot request specific attributes

  user_data_base64 = base64encode(local.user_data)

  cpu_core_count       = 2 # default 4
  cpu_threads_per_core = 1 # default 2

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 5
      throughput  = 200
      encrypted   = true
      # kms_key_id  = aws_kms_key.this.arn # you must grant the AWSServiceRoleForEC2Spot service-linked role access to any custom KMS keys
    }
  ]

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_spot_instance"
    yor_trace            = "2b3911c5-f932-49d6-8ddc-db977f770146"
  })
}

################################################################################
# EC2 Module - Capacity Reservation
################################################################################

module "ec2_open_capacity_reservation" {
  source = "../../"

  name = "${local.name}-open-capacity-reservation"

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = false

  capacity_reservation_specification = {
    capacity_reservation_target = {
      capacity_reservation_id = aws_ec2_capacity_reservation.open.id
    }
  }

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_open_capacity_reservation"
    yor_trace            = "02e73c42-4aaa-49fa-8cd8-36b649ee47ef"
  })
}

module "ec2_targeted_capacity_reservation" {
  source = "../../"

  name = "${local.name}-targeted-capacity-reservation"

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = false

  capacity_reservation_specification = {
    capacity_reservation_target = {
      capacity_reservation_id = aws_ec2_capacity_reservation.targeted.id
    }
  }

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "ec2_targeted_capacity_reservation"
    yor_trace            = "939bbf0c-4407-40e1-a2ca-790b15a2f739"
  })
}

resource "aws_ec2_capacity_reservation" "open" {
  instance_type           = "t3.micro"
  instance_platform       = "Linux/UNIX"
  availability_zone       = "${local.region}a"
  instance_count          = 1
  instance_match_criteria = "open"
  tags = {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "open"
    yor_trace            = "b685d43f-8acb-4f5b-8129-3eef2042adcb"
  }
}

resource "aws_ec2_capacity_reservation" "targeted" {
  instance_type           = "t3.micro"
  instance_platform       = "Linux/UNIX"
  availability_zone       = "${local.region}a"
  instance_count          = 1
  instance_match_criteria = "targeted"
  tags = {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "targeted"
    yor_trace            = "f2233fad-1da3-4e7a-977c-afc60c1ad32a"
  }
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "vpc"
    yor_trace            = "b2e46bff-9aa3-48f0-8aa5-30783a4e7453"
  })
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = merge(local.tags, {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "security_group"
    yor_trace            = "56f5c070-628f-4761-9eba-cbaca64e9afa"
  })
}

resource "aws_placement_group" "web" {
  name     = local.name
  strategy = "cluster"
  tags = {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "web"
    yor_trace            = "5ead7d3d-895b-4437-8c85-49046ebe858d"
  }
}

resource "aws_kms_key" "this" {
  tags = {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "this"
    yor_trace            = "8a3b204e-8705-44f5-bc92-1a6c221ea8bb"
  }
}

resource "aws_network_interface" "this" {
  subnet_id = element(module.vpc.private_subnets, 0)
  tags = {
    git_commit           = "0962ba780180b500539b87067cbeb032716f9a3b"
    git_file             = "tag_test/main.tf"
    git_last_modified_at = "2023-05-09 08:01:25"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "this"
    yor_trace            = "d55964ed-5c5f-47b9-923a-d00b5e7e3d08"
  }
}
