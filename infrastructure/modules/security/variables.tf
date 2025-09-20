##################################################################################
#
# Security Module Variables
#
# Variables:
#   - project_name:             Project name
#   - cluster_subnet_cidr:      CIDR for cluster subnet
#   - bastion_subnet_cidr:      CIDR for bastion subnet
#   - dmz_subnet_cidr:          CIDR for DMZ subnet
##################################################################################

## Project name
variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "sigdep"
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