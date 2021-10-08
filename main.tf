# colocar a chamada do módulo aqui

## Exemplo

# provider "google" {
#   project = var.project
#   region  = var.region
# }

# module "groundwork" {
#   source   = "github.com/mentoriaiac/iac-modulo-groundwork.git?ref=v0.1.0"
#   project  = var.project
#   vpc_name = "groundwork"
# }

# variable "project" {
#   description = "Nome do projeto (Default é staging)"
#   type        = string
#   default     = "direct-link-325016"
# }

# variable "region" {
#   description = "Nome da região"
#   type        = string
#   default     = "us-central1"
# }