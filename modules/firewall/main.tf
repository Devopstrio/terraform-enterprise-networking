variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "rules" {
  description = "List of security rules"
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

resource "aws_security_group" "this" {
  name        = "enterprise-firewall"
  description = "Standard enterprise network security controls"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [for r in var.rules : r if r.type == "ingress"]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = [for r in var.rules : r if r.type == "egress"]
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = {
    Name = "enterprise-fw"
  }
}

output "security_group_id" {
  value = aws_security_group.this.id
}
