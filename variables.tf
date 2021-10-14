variable "project" {
  description = "Nome do projeto (Default é staging)"
  type        = string
}

variable "region" {
  description = "Nome da região"
  type        = string
  default     = "us-central1"
}
