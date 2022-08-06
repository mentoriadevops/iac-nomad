module "network_gcp" {
  source = "github.com/mentoriaiac/iac-modulo-rede-gcp.git?ref=v0.2.0"

  project = var.project
  region  = var.region

  vpc_name  = "rede-mentoria"
  direction = "INGRESS"

  target_tags = ["nomad", "consul"]
  source_tags = ["nomad", "consul"]

  subnetworks = [
    {
      name          = "subnet-nomad"
      ip_cidr_range = "10.0.0.0/16"
      region        = var.region
    }
  ]

  firewall_allow = [
    {
      protocol = "tcp"
      port = [
        22,
        # Nomad
        4646, 4647, 4648,
        # Consul
        "8300-8302", "8500-8502", 8600, "21000-21255",
      ]
    }
  ]
}
