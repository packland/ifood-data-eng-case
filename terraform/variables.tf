# Arquivo: variables.tf

variable "cluster_name" {
  type        = string
  description = "O nome do cluster que será visível na UI do Databricks."
  default     = "iac_cluster_analise_ifood"
}

variable "node_type" {
  type        = string
  description = "O tipo de máquina (VM) para os workers do cluster. Ex: Standard_DS3_v2."
  default     = "Standard_D4ds_v6"
}

variable "spark_version" {
  type        = string
  description = "A versão do Databricks Runtime para o cluster."
  # Nota: Sempre use uma versão LTS (Long Term Support) para maior estabilidade.
  default     = "14.3.x-scala2.12"
}

variable "catalog_name" {
  type        = string
  description = "O nome do catálogo principal para o projeto."
  default     = "iac_catalog_ifood"
}

variable "DATABRICKS_HOST" {
  type        = string
  description = "A URL do workspace Databricks, fornecida pelo Terraform Cloud."
}

variable "DATABRICKS_TOKEN" {
  type        = string
  description = "O token de API do Databricks, fornecido pelo Terraform Cloud."
  sensitive   = true # Marca a variável como sensível para não exibi-la nos logs.
}