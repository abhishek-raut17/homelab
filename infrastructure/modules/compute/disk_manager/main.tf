################################################################################
# Project: SigDep
# Compute/Disk-Manager Module
#
# Resources provisioned:
#   - boot disks: Boot disk for control plane and worker nodes 
#     with the required Talos Linux OS booted
#   - raw disks: Raw disk space (unallocated) which is mounted on each 
#     worker node to be used by longhorn (CSI) later
#   - swap disks: Swap disk for swap space (default: 1024)
#
# Input variables:
#   - project_name:             Project name
#   - region:                   Linode region
#   - k8s_node_type_id:         Cluster node type ID
#   - cluster_node_img:         Cluster node image ID
#   - control_plane_id:         Control Plane ID provisioned in compute
#   - worker_node_ids:          Worker node IDs provisioned in compute
#   - worker_node_count:        # of worker nodes for the cluster (default: 3)
#   - cluster_subnet_id:        Cluster Subnet ID
#
# Outputs:
#   - Instance IDs and IP addresses for the control plane, worker nodes, 
#     and bastion host for use by other modules.
################################################################################

terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 3.2.0"
    }
  }
  required_version = ">= 1.0.0"
}

locals {
  worker_node_ids      = [for instance in var.worker_node_ids : instance.id]
}

# ------------------------------------------------------------------------------
# Boot Disks: Disk instances with Talos Linux image
# ------------------------------------------------------------------------------
# Control Plane
resource "linode_instance_disk" "control_plane_boot_disk" {
  label = "${var.project_name}-control-plane-boot-disk"
  linode_id = var.control_plane_id
  size = 20480
}
# ------------------------------------------------------------------------------ 