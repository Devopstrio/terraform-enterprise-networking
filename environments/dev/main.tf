terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc_hub" {
  source = "../../modules/vpc"

  name       = "hub-vpc-dev"
  cidr_block = "10.0.0.0/16"
  tags = {
    Environment = "dev"
    Project     = "Networking-Platform"
  }
}

module "subnets_hub" {
  source = "../../modules/subnet"

  vpc_id = module.vpc_hub.vpc_id

  public_subnets = {
    "pub-1a" = { cidr_block = "10.0.1.0/24", az = "${var.region}a" }
    "pub-1b" = { cidr_block = "10.0.2.0/24", az = "${var.region}b" }
  }

  private_subnets = {
    "priv-1a" = { cidr_block = "10.0.10.0/24", az = "${var.region}a" }
    "priv-1b" = { cidr_block = "10.0.11.0/24", az = "${var.region}b" }
  }
}

module "hub_firewall" {
  source = "../../modules/firewall"

  vpc_id = module.vpc_hub.vpc_id

  rules = [
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP"
    },
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS"
    }
  ]
}
