terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

# Set up the Linode provider
provider "linode" {
  token = {YOUR_API_TOKEN}
}

# Define the firewall policy
resource "linode_firewall" "lke_firewall_sample" {
  label = "lke_firewall_sample"

  # Allow kubelet health checks
  inbound {
    label = "kubelet_health_checks"
    action   = "ACCEPT"
    protocol = "tcp"
    ports = "10250"
    ipv4 = ["192.168.128.0/17"]
  }

  # Allow Wireguard tunneling for kubectl proxy
  inbound {
    label = "wireguard_tunneling"
    action   = "ACCEPT"
    protocol = "udp"
    ports = "51820"
    ipv4 = ["192.168.128.0/17"]
  }

  # Allow Calico BGP traffic
  inbound {
    label = "calico_bgp_traffic"
    action   = "ACCEPT"
    protocol = "tcp"
    ports = "179"
    ipv4 = ["192.168.128.0/17"]
  }

  # Allow NodePorts for workload services
  inbound {
    label = "node_ports_workload_services"
    action   = "ACCEPT"
    protocol = "tcp"
    ports = "30000-32767"
    ipv4 = ["192.168.128.0/17"]
  }

  # Allow IPENCAP for IP ranges 192.168.128.0/17
  inbound {
    label = "ipencap_internal_communication"
    action   = "ACCEPT"
    protocol = "ipencap"
    ipv4 = ["192.168.128.0/17"]
  }
  
  inbound_policy = "DROP"

  # Block all other TCP traffic
  inbound {
    label = "block_all_tcp_traffic"
    action   = "DROP"
    protocol = "tcp"
    ipv4 = ["0.0.0.0/0"]
  }

  # Block all other UDP traffic
  inbound {
    label = "block_all_udp_traffic"
    action   = "DROP"
    protocol = "udp"
    ipv4 = ["0.0.0.0/0"]
  }

  # Block all ICMP traffic
  inbound {
    label = "block_all_icmp_traffic"
    action   = "DROP"
    protocol = "icmp"
    ipv4 = ["0.0.0.0/0"]
  }

  outbound_policy = "ACCEPT"
}
