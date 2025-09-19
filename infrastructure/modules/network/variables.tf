##################################################################################
#
# Network Module Variables
#
# Variables:
#   - project_name:             Project name
#   - region:                   Linode region
#   - cluster_subnet_cidr:      CIDR for cluster subnet
#   - bastion_subnet_cidr:      CIDR for bastion subnet
#   - dmz_subnet_cidr:          CIDR for DMZ subnet
##################################################################################

## Project name
variable "project_name" {
  description = "Project Name"
  type        = string
}
## Linode Region
variable "region" {
  description = "Linode Region"
  type        = string
}
## Cluster Subnet CIDR
variable "cluster_subnet_cidr" {
  description = "CIDR block for the Cluster subnet"
  type        = string
}
## Bastion Subnet CIDR
variable "bastion_subnet_cidr" {
  description = "CIDR block for the Bastion subnet"
  type        = string
}
## DMZ Subnet CIDR
variable "dmz_subnet_cidr" {
  description = "CIDR block for the DMZ subnet"
  type        = string
}