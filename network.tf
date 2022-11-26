# Busca informações do groundwork.
data "google_compute_network" "groundwork" {
  name = "groundwork"
}

data "google_compute_subnetwork" "nomad" {
  name = "nomad"
}

# Firewall
resource "google_compute_firewall" "tmp_nomad_allow_access" {
  name        = "tmp-nomad-allow-access"
  description = "Regra temporária para permitir acesso direto às máquinas do cluster Nomad para debug. Remover quando tiver infraestrura de bastion."

  network       = data.google_compute_network.groundwork.name
  target_tags   = ["nomad", "consul"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports = [
      22,
      # Nomad
      4646, 4647, 4648,
      # Consul
      "8300-8302", "8500-8502", 8600, "21000-21255",
    ]
  }
}
