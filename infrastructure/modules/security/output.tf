##################################################################################
# Security Module Outputs
#
# Exposes key resource attributes for use by other modules or the root module:
#   - cluster_fw_id:         ID of the cluster subnet firewall
#   - bastion_fw_id:         ID of the bastion subnet firewall
#   - dmz_fw_id:             ID of the dmz subnet firewall
##################################################################################

output "cluster_fw_id" {
  description = "The ID of the cluster subnet firewall"
  value       = linode_firewall.cluster_fw.id
}

output "bastion_fw_id" {
  description = "The ID of the bastion subnet firewall"
  value       = linode_firewall.bastion_fw.id
}

output "dmz_fw_id" {
  description = "The ID of the dmz subnet firewall"
  value       = linode_firewall.dmz_fw.id
}