# Bloco de configuração do Terraform e do provedor
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.90.0"
    }
  }
}

# Configuração do provedor Databricks (será autenticado via env vars no GitHub Actions)
provider "databricks" {}

# Recurso 1: Define o Notebook a ser implantado no Databricks
resource "databricks_notebook" "ingestion_notebook" {
  # Confirme se este é o caminho correto no seu projeto
  source = "${path.root}/src/bronze_ingestion/ingestion.ipynb"
  path   = "/Shared/ifood_case/ingest_bronze.ipynb"
}

# Recurso 2: Define o Job Serverless que executará o notebook
resource "databricks_job" "ingestion_job" {
  name = "iFood Ingestion Job (Serverless)"

  task {
    task_key = "ingest_bronze_task"
    
    # Tarefa de notebook que será executada em computação Serverless
    # A ausência de um bloco 'new_cluster' ou 'existing_cluster_id' ativa o modo Serverless.
    notebook_task {
      notebook_path = databricks_notebook.ingestion_notebook.path
    }
    timeout_seconds = 3600
    max_retries     = 1
  }

  
}