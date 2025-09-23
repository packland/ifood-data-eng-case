# Arquivo: terraform/backend.tf

terraform {
  backend "remote" {
    organization = "case-ifood" 

    workspaces {
      name = "databricks"
    }
  }
}