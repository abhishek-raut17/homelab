##################################################################################
# Bastion Module Outputs
#
# Exposes key resource attributes for use by other modules or the root module:
#   - bastion_node_id:                ID of the VPC
#   - bastion_ip_address:     ID of the cluster subnet
#   - bastion_private_ipv4:     ID of the bastion subnet
##################################################################################

output "bastion_node_id" {
  description = "ID of the bastion host instance"
  value       = linode_instance.bastion_node.id
}

output "bastion_ip_address" {
  description = "Public IPv4 address of the bastion host"
  value       = linode_instance.bastion_node.ipv4
}

output "bastion_private_ipv4" {
  description = "Private IPv4 address of the bastion host on the VPC"
  value       = linode_instance.bastion_node.private_ip_address
}