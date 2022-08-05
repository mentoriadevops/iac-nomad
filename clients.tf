data "google_compute_zones" "us-central1" {
  region = var.region
}

module "nomad_clients" {
  source = "github.com/mentoriaiac/iac-modulo-compute-gcp.git?ref=v0.2.1"
  count  = 2

  project = var.project
  zone    = data.google_compute_zones.us-central1.names[count.index % length(data.google_compute_zones.us-central1.names)]

  instance_name  = "client-${count.index + 1}"
  instance_image = "nomad-v0-3-0"
  machine_type   = "e2-small"

  network    = module.network_gcp.vpc_id
  subnetwork = module.network_gcp.subnets[0].id
  tags       = ["nomad", "consul"]

  metadata_startup_script = <<EOF
/usr/local/bin/nomad_bootstrap.sh client '\"provider=gce project_name=${var.project} tag_value=nomad-server\"' global dc1 nomad-ca-cert:1 nomad-client-cert:1 nomad-client-key:1
/usr/local/bin/consul_bootstrap.sh agent '\"provider=gce project_name=${var.project} tag_value=consul\"'
  EOF

  roles = [
    "roles/secretmanager.secretAccessor",
    "roles/compute.viewer",
  ]

  labels = {
    terraform = "true",
    component = "nomad_client"
  }
}
