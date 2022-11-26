locals {
  server_pool = {
    server-node-1 = {
      machine_type   = "e2-small"
      instance_image = "nomad-v0-3-0"
      zone           = "${var.region}-c"
    },
    server-node-2 = {
      machine_type   = "e2-small"
      instance_image = "nomad-v0-3-0"
      zone           = "${var.region}-b"
    },
    server-node-3 = {
      machine_type   = "e2-small"
      instance_image = "nomad-v0-3-0"
      zone           = "${var.region}-a"
    }
  }
}

module "nomad_servers" {
  source   = "github.com/mentoriaiac/iac-modulo-compute-gcp.git?ref=v0.2.1"
  for_each = local.server_pool

  project = var.project
  zone    = each.value.zone

  instance_name  = each.key
  instance_image = each.value.instance_image
  machine_type   = each.value.machine_type

  network    = data.google_compute_network.groundwork.name
  subnetwork = data.google_compute_subnetwork.nomad.name
  tags       = ["nomad", "nomad-server", "consul"]

  metadata_startup_script = <<EOF
/usr/local/bin/nomad_bootstrap.sh server 3 '\"provider=gce project_name=${var.project} tag_value=nomad-server\"' global dc1 nomad-ca-cert:1 nomad-server-cert:1 nomad-server-key:1
/usr/local/bin/consul_bootstrap.sh server 3 '\"provider=gce project_name=${var.project} tag_value=consul\"'
EOF

  roles = [
    "roles/secretmanager.secretAccessor",
    "roles/compute.viewer",
  ]

  labels = {
    terraform = "true",
    component = "nomad_server"
  }
}
