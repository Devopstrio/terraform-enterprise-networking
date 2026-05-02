output "hub_vpc_id" {
  value = module.vpc_hub.vpc_id
}

output "hub_public_subnets" {
  value = module.subnets_hub.public_subnet_ids
}

output "hub_private_subnets" {
  value = module.subnets_hub.private_subnet_ids
}

output "hub_firewall_sg" {
  value = module.hub_firewall.security_group_id
}
