locals {

  server_pool = {
    server-node-1 = {
      machine_type   = "e2-medium"
      instance_image = "orquestradores-v0-1-0"
      zone           = "us-central1-c"
    }
  }
}
