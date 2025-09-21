################################################################################
# Project: SigDep
# Description: Homelab Infrastructure on Linode
#
# Infrastructure Root Module
# Orchestrates the provisioning of the entire homelab stack on Linode.
#
# Modules:
#   - network:      Core networking (VPC, subnets)
#   - bastion:      Secure access bastion host
#   - compute:      Kubernetes nodes and compute resources
#   - loadbalancer: NodeBalancer in DMZ
#   - security:     Firewalls, security groups, etc.
#
# Outputs:
#   - Module outputs for downstream use
################################################################################

terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 3.2.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
  required_version = ">= 1.0.0"
}

# ------------------------------------------------------------------------------
# Providers: Linode and Talos
# ------------------------------------------------------------------------------
provider "linode" {
  token = var.linode_token
}

provider "talos" {}

# ------------------------------------------------------------------------------
# Admin SSH Key: Import admin's SSH public key for secure access to bastion host
# ------------------------------------------------------------------------------
resource "linode_sshkey" "admin_access_sshkey" {
  label   = "${var.project_name}-admin-access-sshkey"
  ssh_key = trimspace(chomp(file("${var.admin_access_sshkey_path}")))
}

# ------------------------------------------------------------------------------
# Network Module: Core networking setup (VPC, subnets)
# ------------------------------------------------------------------------------
module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  region       = var.region

  cluster_subnet_cidr = var.cluster_subnet_cidr
  dmz_subnet_cidr     = var.dmz_subnet_cidr

  providers = { linode = linode }
}

# ------------------------------------------------------------------------------
# Bastion Module: Provision bastion nodes for secured access to cluster
# ------------------------------------------------------------------------------
# module "bastion" {
#   source       = "./modules/bastion"
#   project_name = var.project_name
#   region       = var.region

#   bastion_node_type_id = var.bastion_node_type_id
#   bastion_node_img     = var.bastion_node_img
#   dmz_subnet_id = module.network.dmz_subnet_id
#   admin_access_sshkey = linode_sshkey.admin_access_sshkey.ssh_key

#   providers = { linode = linode }
#   depends_on = [
#     linode_sshkey.admin_access_sshkey,
#     module.network
#   ]
# }

# ------------------------------------------------------------------------------
# Compute Module: Provision compute nodes to host k8s cluster
# ------------------------------------------------------------------------------
# module "compute" {
#   source       = "./modules/compute"
#   project_name = var.project_name
#   region       = var.region

#   k8s_node_type_id = var.k8s_node_type_id
#   cluster_node_img = var.cluster_node_img
#   cluster_subnet_id = module.network.cluster_subnet_id

#   providers = { linode = linode }
#   depends_on = [
#     module.network
#   ]
# }

# ------------------------------------------------------------------------------
# Security Module: Security configurations (firewalls, security groups)
# ------------------------------------------------------------------------------
# module "security" {
#   source       = "./modules/security"
#   project_name = var.project_name

#   cluster_subnet_cidr = module.network.cluster_subnet_cidr
#   dmz_subnet_cidr     = module.network.dmz_subnet_cidr

#   providers  = { linode = linode }
#   depends_on = [module.network]
# }
# ------------------------------------------------------------------------------