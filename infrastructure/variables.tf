##################################################################################
#
# Root Module Variables
#
# Variables:
#   - project_name:             Project name
#   - region:                   Linode region
#   - linode_token:             Linode API token
#   - admin_access_sshkey_path: Path to admin's SSH public key
#   - cluster_subnet_cidr:      CIDR for cluster subnet
#   - bastion_subnet_cidr:      CIDR for bastion subnet
#   - dmz_subnet_cidr:          CIDR for DMZ subnet
#   - k8s_node_type_id:         Compute instance type for cluster nodes
#   - bastion_node_type_id:     Compute instance type for bastion host
#   - cluster_node_img:         Talos image label for cluster nodes
#   - bastion_node_img:         Linux image label for bastion host
##################################################################################

## Project name
variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "sigdep"
}

## Cloud provider (linode) access token
variable "linode_token" {
  description = "Linode API Token"
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = length(var.linode_token) > 0
    error_message = "Linode API Token must be provided."
  }
}

## Cluster nodes image provider (talos) label
variable "cluster_node_img" {
  description = "Talos Image label"
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = length(var.cluster_node_img) > 0
    error_message = "Talos Image label must be provided."
  }
}

## Bastion nodes image provider (debian12) label
variable "bastion_node_img" {
  description = "Linux Image label"
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = length(var.bastion_node_img) > 0
    error_message = "Linux Image label must be provided."
  }
}

## Admin SSH Key Path
variable "admin_access_sshkey_path" {
  description = "Path to the admin's SSH public key"
  type        = string
  default     = "./keys/sigdep_rsa.pub"

  validation {
    condition     = length(var.admin_access_sshkey_path) > 0
    error_message = "Path to the admin's SSH public key must be provided."
  }
}

## Linode Region
variable "region" {
  description = "Linode Region"
  type        = string
  default     = ""

  validation {
    condition     = length(var.region) > 0
    error_message = "Linode region must be provided."
  }
}

## Cluster Subnet CIDR
variable "cluster_subnet_cidr" {
  description = "CIDR block for the Cluster subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.cluster_subnet_cidr) > 0
    error_message = "Cluster subnet CIDR must be provided."
  }
}

## Bastion Subnet CIDR
variable "bastion_subnet_cidr" {
  description = "CIDR block for the Bastion subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.bastion_subnet_cidr) > 0
    error_message = "Bastion subnet CIDR must be provided."
  }
}

## DMZ Subnet CIDR
variable "dmz_subnet_cidr" {
  description = "CIDR block for the DMZ subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.dmz_subnet_cidr) > 0
    error_message = "DMZ subnet CIDR must be provided."
  }
}

## Compute Instance Types
variable "k8s_node_type_id" {
  description = "The type (category) of compute node instance for cluster nodes"
  type        = string
  default     = ""

  validation {
    condition     = length(var.k8s_node_type_id) > 0
    error_message = "Node type must be provided."
  }
}

## Bastion Instance Type
variable "bastion_node_type_id" {
  description = "The type (category) of compute node instance for bastion host"
  type        = string
  default     = ""

  validation {
    condition     = length(var.bastion_node_type_id) > 0
    error_message = "Node type must be provided."
  }
}