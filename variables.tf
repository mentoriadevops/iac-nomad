variable "project" {
  description = "Nome do projeto (Default é staging)"
  type        = string
}

variable "region" {
  description = "Nome da região"
  type        = string
  default     = "us-central1"
}

# A decisão em utilizar a variável instance_name ao invés da key se deu no sentido de facilitar a leitura dos nomes e tipos das instâncias (server/client) para todos os níveis de utilizadores.
variable "server_pool" {
  description = "Quantidade de Máquinas Servers"
  type = map(object({
    instance_name           = string
    machine_type            = string
    instance_image          = string
    zone                    = string
    metadata_startup_script = string
    tag                     = list(string)
    labels                  = map(string)
  }))
}

variable "client_pool" {
  description = "Quantidade de Máquinas Clients"
  type = map(object({
    instance_name           = string
    machine_type            = string
    instance_image          = string
    zone                    = string
    metadata_startup_script = string
    tag                     = list(string)
    labels                  = map(string)
  }))
}
