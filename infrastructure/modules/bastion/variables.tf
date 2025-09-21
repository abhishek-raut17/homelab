##################################################################################
#
# Bastion Module Variables
#
# Variables:
#   - project_name:             Project name
#   - region:                   Linode region
#   - admin_access_sshkey:      Admin's SSH public key
#   - bastion_node_type_id:     Compute instance type for bastion host
#   - bastion_node_img:         Linux image label for bastion host
#   - dmz_subnet_id:            ID for DMZ Subnet
#   - dmz_fw_id:                Firewall ID to attach to DMZ subnet nodes
##################################################################################

## Project name
variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "sigdep"
}

## Bastion nodes image provider (debian12) label
variable "bastion_node_img" {
  description = "Linux Image label"
  type        = string
  default     = ""

  validation {
    condition     = length(var.bastion_node_img) > 0
    error_message = "Linux Image label must be provided."
  }
}

## Admin SSH Key Path
variable "admin_access_sshkey" {
  description = "Admin's SSH public key"
  type        = string
  sensitive   = true
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

## DMZ Subnet CIDR
variable "dmz_subnet_id" {
  description = "Subnet ID for the DMZ subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.dmz_subnet_id) > 0
    error_message = "DMZ subnet ID must be provided."
  }
}

## DMZ Subnet firewall ID
variable "dmz_fw_id" {
  description = "Firewall ID for the DMZ subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.dmz_fw_id) > 0
    error_message = "Firewall ID for DMZ subnet must be provided."
  }
}