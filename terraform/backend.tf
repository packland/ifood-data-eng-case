# Arquivo: terraform/backend.tf

terraform {
  cloud {
    # Substitua pelo nome da organização que você criou
    organization = "case-ifood" 

    workspaces {
      # Substitua pelo nome do workspace que você criou
      name = "databricks-iac-ifood"
    }
  }
}