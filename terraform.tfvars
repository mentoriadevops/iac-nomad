project = "mentoria-terraform"

server_pool = {
  server-node-1 = {
    instance_name           = "server1"
    machine_type            = "e2-small"
    instance_image          = "orquestradores-1634167564"
    zone                    = "us-central1-c"
    metadata_startup_script = <<EOF
    /usr/local/bin/nomad_bootstrap.sh server 3 '\"provider=gce project_name=${var.project} tag_value=nomad-server\"'
    EOF 
    tag                     = ["nomad", "nomad-server"]
    labels = {
      terraform = "true",
      component = "nomad_server"
    }
  },
  server-node-2 = {
    instance_name           = "server2"
    machine_type            = "e2-medium"
    instance_image          = "orquestradores-1634167564"
    zone                    = "us-central1-a"
    metadata_startup_script = <<EOF
    /usr/local/bin/nomad_bootstrap.sh server 3 '\"provider=gce project_name=${var.project} tag_value=nomad-server\"'
    EOF 
    tag                     = ["nomad", "nomad-server"]
    labels = {
      terraform = "true",
      component = "nomad_client"
    }
  }
}

client_pool = {
  client-node-1 = {
    instance_name           = "client1"
    machine_type            = "e2-medium"
    instance_image          = "orquestradores-1634167564"
    zone                    = "us-central1-f"
    metadata_startup_script = <<EOF
    /usr/local/bin/nomad_bootstrap.sh client '\"provider=gce project_name=${var.project} tag_value=nomad-server\"'
    EOF
    tag                     = ["nomad"]
    labels = {
      terraform = "true",
      component = "nomad_server"
    }
  },
  client-node-2 = {
    instance_name           = "client2"
    machine_type            = "e2-micro"
    instance_image          = "orquestradores-1634167564"
    zone                    = "us-central1-b"
    metadata_startup_script = <<EOF
    /usr/local/bin/nomad_bootstrap.sh client '\"provider=gce project_name=${var.project} tag_value=nomad-server\"'
    EOF
    tag                     = ["nomad"]
    labels = {
      terraform = "true",
      component = "nomad_client"
    }
  }
}
  
