# colocar a chamada do módulo aqui

## Exemplo

provider "google" {
  project = var.project
  region  = var.region
}

module "network_gcp" {
  source      = "github.com/mentoriaiac/iac-modulo-rede-gcp.git?ref=main"
  project     = var.project
  vpc_name    = "rede-mentoria"
  direction   = "INGRESS"
  target_tags = ["nomad", "consul"]
  #  TODO: `source_tags` assim bloqueia o SSH da CLI do GCP.
  #  source_tags = ["nomad", "consul"]
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

module "nomad_servers" {
  source = "github.com/mentoriaiac/iac-modulo-compute-gcp.git?ref=v0.2.0"

  for_each = local.server_pool

  project                 = var.project
  instance_name           = each.key
  instance_image          = each.value.instance_image
  machine_type            = each.value.machine_type
  zone                    = each.value.zone
  network                 = module.network_gcp.vpc_id
  subnetwork              = module.network_gcp.subnets[0].id
  metadata_startup_script = <<EOF
  /usr/local/bin/nomad_bootstrap.sh server 3 '\"provider=gce project_name=${var.project} tag_value=nomad-server\"'
  /usr/local/bin/consul_bootstrap.sh server 3 '\"provider=gce project_name=${var.project} tag_value=consul\"'
  EOF
  tags                    = ["nomad", "nomad-server", "consul"]
  labels = {
    terraform = "true",
    component = "nomad_server"
  }
  service_account_scopes = [
    "https://www.googleapis.com/auth/compute.readonly",
  ]
}


data "google_compute_zones" "us-central1" {
  #  project = mentoria-terraform
  region = "us-central1"
}

module "nomad_clients" {
  source = "github.com/mentoriaiac/iac-modulo-compute-gcp.git?ref=v0.2.0"

  count = 3

  project                 = var.project
  instance_name           = "client-${count.index + 1}"
  machine_type            = "e2-medium"
  instance_image          = "orquestradores-20211110235155"
  zone                    = data.google_compute_zones.us-central1.names[count.index % length(data.google_compute_zones.us-central1.names)]
  network                 = module.network_gcp.vpc_id
  subnetwork              = module.network_gcp.subnets[0].id
  metadata_startup_script = <<EOF
  /usr/local/bin/nomad_bootstrap.sh client '\"provider=gce project_name=${var.project} tag_value=nomad-server\"'
  /usr/local/bin/consul_bootstrap.sh agent '\"provider=gce project_name=${var.project} tag_value=consul\"'
  EOF

  service_account_scopes = [
    "https://www.googleapis.com/auth/compute.readonly",
  ]

  tags = ["nomad", "consul"]
  labels = {
    terraform = "true",
    component = "nomad_client"
  }
}
