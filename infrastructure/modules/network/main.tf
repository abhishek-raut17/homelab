################################################################################
# Project: SigDep
# Network Module
#
# Provisions core networking resources on Linode:
#   - VPC for project isolation
#   - Three subnets: cluster (private), bastion, and DMZ
#
# Inputs:
#   - project_name:         Project name
#   - region:               Linode region
#   - cluster_subnet_cidr:  CIDR for cluster subnet
#   - dmz_subnet_cidr:      CIDR for DMZ subnet
#
# Outputs:
#   - VPC and subnet IDs
#   - Subnet CIDRs (after creation for references)
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

# ------------------------------------------------------------------------------
# VPC: Virtual Private Cloud for project isolation
# ------------------------------------------------------------------------------
resource "linode_vpc" "vpc" {
  label       = "${var.project_name}-vpc"
  description = "VPC for ${var.project_name}"
  region      = var.region
}

# ------------------------------------------------------------------------------
# Subnet: Cluster Subnet for internal/cluster resources
# ------------------------------------------------------------------------------
resource "linode_vpc_subnet" "cluster_subnet" {
  label  = "${var.project_name}-cluster-subnet"
  vpc_id = linode_vpc.vpc.id
  ipv4   = var.cluster_subnet_cidr
}

# ------------------------------------------------------------------------------
# Subnet: DMZ Subnet for public facing (jump proxy) resources
# ------------------------------------------------------------------------------
resource "linode_vpc_subnet" "dmz_subnet" {
  label  = "${var.project_name}-dmz-subnet"
  vpc_id = linode_vpc.vpc.id
  ipv4   = var.dmz_subnet_cidr
}
# ------------------------------------------------------------------------------