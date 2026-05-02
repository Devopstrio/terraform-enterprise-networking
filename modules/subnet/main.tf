variable "vpc_id" {
  description = "VPC ID where subnets will be created"
  type        = string
}

variable "public_subnets" {
  description = "Map of public subnets with CIDR and AZ"
  type        = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnets with CIDR and AZ"
  type        = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "tags" {
  description = "Tags to apply to the subnets"
  type        = map(string)
  default     = {}
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "public-${each.key}"
      Type = "public"
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(
    {
      Name = "private-${each.key}"
      Type = "private"
    },
    var.tags
  )
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}
