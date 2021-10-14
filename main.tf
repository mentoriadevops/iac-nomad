# colocar a chamada do módulo aqui

## Exemplo

provider "google" {
  project = var.project
  region  = var.region
}

module "network_gcp" {
  source      = "github.com/Rehzende/iac-modulo-rede-gcp.git?ref=d8c3058"
  project     = var.project
  vpc_name    = "rede-mentoria"
  direction   = "INGRESS"
  target_tags = ["nomad"]
  source_tags = ["nomad"]
  subnetworks = [
    {
      name          = "subnet-nomad"
      ip_cidr_range = "10.0.0.0/16"
      region        = "us-central1"
    }
  ]

  firewall_allow = [
    {
      protocol = "tcp"
      port     = [22, 4646, 4647, 4648]
    }
  ]
}

module "nomad_servers" {
  source         = "github.com/mentoriaiac/iac-modulo-compute-gcp.git?ref=v0.1.0"
  project        = var.project
  instance_name  = "nomad-server1"
  instance_image = "orquestradores-1634167564"
  machine_type   = "e2-small"
  zone           = "us-central1-a"
  network        = module.network_gcp.vpc_id
  subnetwork     = module.network_gcp.subnets[0].id
  tags           = ["nomad", "nomad-server"]

  metadata_startup_script = "/usr/local/bin/nomad_bootstrap.sh server 1 '\"provider=gce project_name=${var.project} tag_value=nomad-server\"'"

  labels = {
    key = "value"
  }
}

module "nomad_clients" {
  source         = "github.com/mentoriaiac/iac-modulo-compute-gcp.git?ref=v0.1.0"
  project        = var.project
  instance_name  = "nomad-client1"
  instance_image = "orquestradores-1634167564"
  machine_type   = "e2-small"
  zone           = "us-central1-a"
  network        = module.network_gcp.vpc_id
  subnetwork     = module.network_gcp.subnets[0].id
  tags           = ["nomad", "nomad-client"]

  metadata_startup_script = "/usr/local/bin/nomad_bootstrap.sh client '\"provider=gce project_name=${var.project} tag_value=nomad-server\"'"

  labels = {
    key = "value"
  }
}
