# Arquivo: main.tf

resource "databricks_cluster" "cluster_analise" {
  
  cluster_name = var.cluster_name
  spark_version = var.spark_version
  node_type_id = var.node_type
  autotermination_minutes = 15

  num_workers = 0

  # Opcional: Confirma o modo de nó único para algumas versões de DBR
  spark_conf = {
    "spark.databricks.cluster.profile" = "singleNode"
  }
}

resource "databricks_catalog" "catalog_padrao" {
  name    = var.catalog_name
  comment = "Catálogo principal criado via IaC para o projeto de análise."
  
  # Define que todos os usuários da conta são proprietários do catálogo.
  # Ajuste conforme as políticas de segurança da sua organização.
  owner   = "account users"
}