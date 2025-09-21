################################################################################
# Project: SigDep
# Security Module
#
# Provisions core networking resources on Linode:
#   - Firewalls for cluster and dmz subnets
#
# Inputs:
#   - project_name:         Project name
#   - cluster_subnet_cidr:  CIDR for cluster subnet
#   - dmz_subnet_cidr:      CIDR for DMZ subnet
#
# Outputs:
#   - Firewall IDs
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
# Firewall: Cluster Subnet Firewall for internal/cluster resources
# ------------------------------------------------------------------------------
resource "linode_firewall" "cluster_fw" {
  label = "${var.project_name}-cluster-subnet-fw"

  # Allow specific TCP from bastion subnet for secured maintanance access
  inbound {
    label    = "allow-tcp-from-dmz-subnet"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "6443,50000"
    ipv4     = [var.dmz_subnet_cidr]
  }

  # Allow HTTP/S from NodeBalancer (lb) to cluster nodes
  # inbound {
  #   label    = "allow-tcp-from-lb"
  #   action   = "ACCEPT"
  #   protocol = "TCP"
  #   ports    = "80,443"
  #   ipv4     = [] # Nodebalancer (lb) ipv4
  # }

  # Allow all TCP within the cluster subnet for internal cluster communication
  inbound {
    label    = "allow-tcp-from-cluster-subnet"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = [var.cluster_subnet_cidr]
  }

  # Allow all UDP within the cluster subnet for internal cluster communication
  inbound {
    label    = "allow-udp-from-cluster-subnet"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "1-65535"
    ipv4     = [var.cluster_subnet_cidr]
  }

  # Allow all ICMP within the cluster subnet for internal cluster communication
  inbound {
    label    = "allow-icmp-from-cluster-subnet"
    action   = "ACCEPT"
    protocol = "ICMP"
    ipv4     = [var.cluster_subnet_cidr]
    # No ports specified: allows all ICMP types
  }

  # Allow essential outbound services (DNS, HTTP, HTTPS) to the internet
  outbound {
    label    = "allow-essential-tcp-services"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "53,80,443"
    ipv4     = ["0.0.0.0/0"]
  }

  # Allow DNS (UDP) to the internet for name resolution
  outbound {
    label    = "allow-essential-udp-services"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "53"
    ipv4     = ["0.0.0.0/0"]
  }

  # Allow all ICMP outbound to the internet for network diagnostics
  outbound {
    label    = "allow-essential-icmp-services"
    action   = "ACCEPT"
    protocol = "ICMP"
    ipv4     = ["0.0.0.0/0"]
    # No ports specified: allows all ICMP types
  }

  inbound_policy  = "DROP"
  outbound_policy = "DROP"

  tags = ["cluster", "k8s"]
}

# ------------------------------------------------------------------------------
# Firewall: DMZ Subnet Firewall for secure access to cluster resources
# ------------------------------------------------------------------------------
resource "linode_firewall" "dmz_fw" {
  label = "${var.project_name}-dmz-subnet-fw"

  # Allow SSH from the internet to the bastion host
  inbound {
    label    = "allow-ssh-from-internet"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
  }

  # Allow specific TCP to cluster subnet for secured maintanance access
  outbound {
    label    = "allow-tcp-to-cluster-subnet"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "6443,50000"
    ipv4     = [var.cluster_subnet_cidr]
  }

  # Allow essential outbound services (DNS, HTTP, HTTPS) to the internet
  outbound {
    label    = "allow-essential-tcp-services"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "53,80,443"
    ipv4     = ["0.0.0.0/0"]
  }

  # Allow DNS (UDP) to the internet for name resolution and NTP for time sync
  outbound {
    label    = "allow-essential-udp-services"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "53,123"
    ipv4     = ["0.0.0.0/0"]
  }

  # Allow all ICMP outbound to the internet for network diagnostics
  outbound {
    label    = "allow-essential-icmp-services"
    action   = "ACCEPT"
    protocol = "ICMP"
    ipv4     = ["0.0.0.0/0"]
    # No ports specified: allows all ICMP types
  }

  inbound_policy  = "DROP"
  outbound_policy = "DROP"

  tags = ["dmz", "access"]
}

# ------------------------------------------------------------------------------
# Firewall: Entrypoint loadbalancer Firewall for web traffic access to cluster
# ------------------------------------------------------------------------------
resource "linode_firewall" "lb_fw" {
  label = "${var.project_name}-entrypoint-lb-fw"

  # Allow HTTP/S from the internet to the NodeBalancer in the DMZ
  inbound {
    label    = "allow-tcp-from-internet"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80,443"
    ipv4     = ["0.0.0.0/0"]
  }

  # Allow essential outbound services (DNS, HTTP, HTTPS) to the internet
  outbound {
    label    = "allow-essential-tcp-services"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "53,80,443"
    ipv4     = ["0.0.0.0/0"]
  }

  # Allow DNS (UDP) to the internet for name resolution
  outbound {
    label    = "allow-essential-udp-services"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "53"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound_policy  = "DROP"
  outbound_policy = "DROP"

  tags = ["nodebalancer", "lb"]
}
# ------------------------------------------------------------------------------