##################################################################################
#
# Compute Module Variables
#
# Variables:
#   - project_name:             Project name
#   - region:                   Linode region
#   - worker_node_count:        # of worker nodes for the cluster (default: 3)
#   - cluster_subnet_id:        ID for Cluster Subnet
#   - cluster_fw_id:            Firewall ID to attach to Cluster subnet nodes
##################################################################################

## Project name
variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "sigdep"
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

## Worker nodes count
variable "worker_node_count" {
  description = "Number of worker nodes for the cluster"
  type        = number
  default     = 3
}

## Bastion Instance Type
variable "k8s_node_type_id" {
  description = "The type (category) of compute node instance for k8s cluster host"
  type        = string
  default     = ""

  validation {
    condition     = length(var.k8s_node_type_id) > 0
    error_message = "Node type must be provided."
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

## Cluster Subnet CIDR
variable "cluster_subnet_id" {
  description = "Subnet ID for the Cluster subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.cluster_subnet_id) > 0
    error_message = "Cluster subnet ID must be provided."
  }
}

## Cluster Subnet firewall ID
variable "cluster_fw_id" {
  description = "Firewall ID for the Cluster subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.cluster_fw_id) > 0
    error_message = "Firewall ID for Cluster subnet must be provided."
  }
}