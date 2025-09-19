##################################################################################
# Network Module Outputs
#
# Exposes key resource attributes for use by other modules or the root module:
#   - vpc_id:                ID of the VPC
#   - cluster_subnet_id:     ID of the cluster subnet
#   - bastion_subnet_id:     ID of the bastion subnet
#   - dmz_subnet_id:         ID of the DMZ subnet
#   - cluster_subnet_cidr:   CIDR block of the cluster subnet
#   - bastion_subnet_cidr:   CIDR block of the bastion subnet
#   - dmz_subnet_cidr:       CIDR block of the DMZ subnet
##################################################################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = linode_vpc.vpc.id
}

output "cluster_subnet_id" {
  description = "ID of the cluster subnet"
  value       = linode_vpc_subnet.cluster_subnet.id
}

output "bastion_subnet_id" {
  description = "ID of the bastion subnet"
  value       = linode_vpc_subnet.bastion_subnet.id
}

output "dmz_subnet_id" {
  description = "ID of the DMZ subnet"
  value       = linode_vpc_subnet.dmz_subnet.id
}

output "cluster_subnet_cidr" {
  description = "CIDR block of the cluster subnet"
  value       = linode_vpc_subnet.cluster_subnet.ipv4
}

output "bastion_subnet_cidr" {
  description = "CIDR block of the bastion subnet"
  value       = linode_vpc_subnet.bastion_subnet.ipv4
}

output "dmz_subnet_cidr" {
  description = "CIDR block of the DMZ subnet"
  value       = linode_vpc_subnet.dmz_subnet.ipv4
}
