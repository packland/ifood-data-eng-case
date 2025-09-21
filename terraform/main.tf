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
# --- BIBLIOTECAS A SEREM INSTALADAS ---
  # Adicionamos os pacotes dbt necessários via PyPI.
  library {
    pypi {
      package = "dbt-core"
    }
  }

  library {
    pypi {
      package = "dbt-databricks"
    }
  }
}

resource "databricks_schema" "schema_bronze" {
  catalog_name = "hive_metastore" 
  name    = var.schema_name
  comment = "Schema para os dados brutos do projeto Ifood, criado via IaC."
}