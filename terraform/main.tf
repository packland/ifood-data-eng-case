# Arquivo: main.tf

# Este recurso define um cluster de computação no Databricks.
# O nome local "cluster_analise" é um apelido usado apenas dentro do Terraform.
resource "databricks_cluster" "cluster_analise" {
  
  # O nome que aparecerá na interface do Databricks.
  # Estamos usando a variável definida em variables.tf.
  cluster_name = var.cluster_name

  # A versão do Databricks Runtime.
  spark_version = var.spark_version

  # O tipo de máquina para o driver e os workers.
  node_type_id = var.node_type

  # Desligar o cluster automaticamente após 20 minutos de inatividade.
  # Essencial para controle de custos!
  autotermination_minutes = 15

  # Configuração de auto-scaling. O cluster irá escalar
  # entre 1 e 4 workers conforme a necessidade da carga de trabalho.
  autoscale {
    min_workers = 1
    max_workers = 4
  }
}
