################################################################################
# Project: SigDep
# Compute Module
#
# Resources provisioned:
#   - control_plane: Provisions the Kubernetes control plane node(s)
#     within the private subnet for cluster management.
#   - worker_nodes: Provisions the Kubernetes worker node(s) within 
#     the private subnet for running workloads.
#
# Input variables:
#   - project_name:            Name of the project for resource labeling.
#   - region:                  Linode region for resource deployment.
#   - k8s_node_type_id:        Linode instance type for Kubernetes nodes.
#   - os_image_id:             OS image to use for all instances.
#   - cluster_subnet_id:       Subnet ID for cluster (Kubernetes) nodes.
#   - worker_node_count:       Number of Kubernetes worker nodes to provision.
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
  worker_node_ids      = [for instance in linode_instance.worker_nodes : instance.id]
  worker_boot_disk_ids = [for disk in linode_instance_disk.worker_boot_disk : disk.id]
  worker_swap_disk_ids = [for disk in linode_instance_disk.worker_swap_disk : disk.id]
  worker_raw_disk_ids  = [for disk in linode_instance_disk.worker_raw_disk : disk.id]
}

# ------------------------------------------------------------------------------
# Control Plane: Provisions the Kubernetes control plane node.
# ------------------------------------------------------------------------------
resource "linode_instance" "control_plane" {
  label     = "${var.project_name}-control-plane"
  region    = var.region
  type      = var.k8s_node_type_id

  tags = ["k8s", "control-plane", "private"]
}

# ------------------------------------------------------------------------------
# Worker Nodes: Provisions the Kubernetes worker nodes.
# ------------------------------------------------------------------------------
resource "linode_instance" "worker_nodes" {
  for_each = toset([for i in range(var.worker_node_count) : tostring(i)])

  label     = "${var.project_name}-worker-${tonumber(each.key) + 1}"
  region    = var.region
  type      = var.k8s_node_type_id

  tags = ["k8s", "worker", "node_counter-${tonumber(each.key + 1)}"]

}

# ------------------------------------------------------------------------------
# Disk Manager Module: Provisions boot and raw disks for cluster nodes.
# ------------------------------------------------------------------------------

module "disk_manager" {
  source = "./disk_manager"

  project_name = var.project_name
  control_plane_id = linode_instance.control_plane.id
  worker_node_ids = toset([for i in range(var.worker_node_count) : linode_instance.worker_nodes[i].id])

  providers = {
    linode = linode
  }
  depends_on = [ 
    linode_instance.control_plane,
    linode_instance.worker_nodes
  ]
}
# ------------------------------------------------------------------------------