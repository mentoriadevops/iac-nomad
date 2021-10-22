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
  source = "github.com/mentoriaiac/iac-modulo-compute-gcp.git?ref=v0.1.0"

  for_each = var.server_pool

  project                 = var.project
  instance_name           = each.value.instance_name
  instance_image          = each.value.instance_image
  machine_type            = each.value.machine_type
  zone                    = each.value.zone
  network                 = module.network_gcp.vpc_id
  subnetwork              = module.network_gcp.subnets[0].id
  tags                    = each.value.tag
  metadata_startup_script = each.value.metadata_startup_script
  labels                  = each.value.labels
}

module "nomad_clients" {
  source = "github.com/mentoriaiac/iac-modulo-compute-gcp.git?ref=v0.1.0"

  for_each = var.client_pool

  project                 = var.project
  instance_name           = each.value.instance_name
  instance_image          = each.value.instance_image
  machine_type            = each.value.machine_type
  zone                    = each.value.zone
  network                 = module.network_gcp.vpc_id
  subnetwork              = module.network_gcp.subnets[0].id
  tags                    = each.value.tag
  metadata_startup_script = each.value.metadata_startup_script
  labels                  = each.value.labels
}
