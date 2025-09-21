##################################################################################
# Security Module Outputs
#
# Exposes key resource attributes for use by other modules or the root module:
#   - cluster_fw_id:         ID of the cluster subnet firewall
#   - dmz_fw_id:             ID of the dmz subnet firewall
#   - lb_fw_id:              ID of the entrypoint loadbalancer firewall
##################################################################################

output "cluster_fw_id" {
  description = "The ID of the cluster subnet firewall"
  value       = linode_firewall.cluster_fw.id
}

output "dmz_fw_id" {
  description = "The ID of the DMZ subnet firewall"
  value       = linode_firewall.dmz_fw.id
}

output "lb_fw_id" {
  description = "The ID of the entrypoint loadbalancer firewall"
  value       = linode_firewall.lb_fw.id
}