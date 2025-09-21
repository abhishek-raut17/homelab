################################################################################
# Project: SigDep
# Bastion Module
#
# Provisions bastion resources on Linode for secure access to the cluster:
#   - Bastion host for maintenance and secure access.
#   - Assigns public and VPC network interfaces.
#   - Configures disks and boot settings.
#   - Set firewall ID for bastion nodes
#
# Inputs:
#   - project_name:               Project name
#   - region:                     Linode region
#   - bastion_node_type_id:       The type (category) of compute node instance for bastion host
#   - bastion_node_img:           Linux Image label for bastion host
#   - dmz_subnet_id:              Subnet ID for the Bastion subnet
#   - admin_access_sshkey:        Admin's SSH public key
#
# Outputs:
#   - Bastion host ID and IP addresses
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
  image_id = length(data.linode_images.linux_image.images) > 0 ? data.linode_images.linux_image.images[0].id : "linode/debian12"
}

# ------------------------------------------------------------------------------
# Bastion Host: Provision a bastion host for maintenance and secure access.
# ------------------------------------------------------------------------------
resource "linode_instance" "bastion_node" {
  label  = "${var.project_name}-bastion-node"
  region = var.region
  type   = var.bastion_node_type_id

  image           = local.image_id
  authorized_keys = [var.admin_access_sshkey]
  root_pass       = null # Disable password login for security

  swap_size = 512
  booted    = true

  ## Network interfaces: one public, one VPC
  interface {
    purpose = "public"
    primary = true
  }

  interface {
    purpose   = "vpc"
    subnet_id = var.dmz_subnet_id
  }

  tags = ["bastion", "proxyhost", var.project_name]
}
# ------------------------------------------------------------------------------