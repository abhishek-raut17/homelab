##################################################################################
#
# Compute/Disk-Manager Module Variables
#
# Variables:
#   - project_name:             Project name
#   - region:                   Linode region
#   - k8s_node_type_id:         Cluster node type ID
#   - cluster_node_img:         Cluster node image ID
#   - control_plane_id:         Control Plane ID provisioned in compute
#   - worker_node_ids:          Worker node IDs provisioned in compute
#   - worker_node_count:        # of worker nodes for the cluster (default: 3)
#   - cluster_subnet_id:        Cluster Subnet ID
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

## Control Plane ID
variable "control_plane_id" {
  description = "Control plane ID from the cluster"
  type        = number
}

## Worker nodes IDs
variable "worker_node_ids" {
  description = "Worker node ID from the cluster"
  type        = set(number)
}

## Cluster Instance Type
variable "k8s_node_type_id" {
  description = "The type (category) of compute node instance for k8s cluster host"
  type        = string
  default     = ""

  validation {
    condition     = length(var.k8s_node_type_id) > 0
    error_message = "Node type must be provided."
  }
}


## Cluster nodes image provider (talos) ID
variable "cluster_node_img" {
  description = "Talos Image ID"
  type        = string
  sensitive   = true
  default     = ""

  validation {
    condition     = length(var.cluster_node_img) > 0
    error_message = "Talos Image ID must be provided."
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