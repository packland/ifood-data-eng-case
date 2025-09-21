terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
    }
  }
}

provider "databricks" {
  // O host e o token serão fornecidos por variáveis de ambiente
  // no GitHub Actions, então não precisamos colocar nada aqui.
  // O provider detecta DATABRICKS_HOST e DATABRICKS_TOKEN automaticamente.
}