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
