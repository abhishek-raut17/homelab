##################################################################################
#
# Bastion Module Variables
#
# Variables:
#   - project_name:             Project name
#   - region:                   Linode region
#   - admin_access_sshkey_path: Path to admin's SSH public key
#   - bastion_node_type_id:     Compute instance type for bastion host
#   - bastion_node_img:         Linux image label for bastion host
#   - bastion_fw_id:            Firewall ID to attach on bastion host
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

## Bastion Subnet CIDR
variable "bastion_subnet_id" {
  description = "Subnet ID for the Bastion subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.bastion_subnet_id) > 0
    error_message = "Bastion subnet ID must be provided."
  }
}

## Bastion Subnet firewall ID
variable "bastion_fw_id" {
  description = "Firewall ID for the Bastion subnet"
  type        = string
  default     = ""

  validation {
    condition     = length(var.bastion_fw_id) > 0
    error_message = "Firewall ID for bastion subnet must be provided."
  }
}