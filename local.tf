locals {

  server_pool = {
    server-node-1 = {
      machine_type   = "e2-small"
      instance_image = "orquestradores-v0-2-0"
      zone           = "${var.region}-c"
    },
    server-node-2 = {
      machine_type   = "e2-medium"
      instance_image = "orquestradores-v0-2-0"
      zone           = "${var.region}-b"
    },
    server-node-3 = {
      machine_type   = "e2-medium"
      instance_image = "orquestradores-v0-2-0"
      zone           = "${var.region}-a"
    }
  }
}
