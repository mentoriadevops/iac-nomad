locals {

  server_pool = {
    server-node-1 = {
      instance_name  = "server1"
      machine_type   = "e2-small"
      instance_image = "orquestradores-20211110235155"
      zone           = "us-central1-c"
    },
    server-node-2 = {
      instance_name  = "server2"
      machine_type   = "e2-medium"
      instance_image = "orquestradores-20211110235155"
      zone           = "us-central1-a"
    },
    server-node-3 = {
      instance_name  = "server3"
      machine_type   = "e2-medium"
      instance_image = "orquestradores-20211110235155"
      zone           = "us-central1-a"
    }
  }
}
