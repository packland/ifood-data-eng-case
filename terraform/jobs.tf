# terraform/jobs.tf

resource "databricks_repo" "repo_ifood_case" {
  url    = var.REPO_URL
  branch = "main"

  path = "${var.repo_base_path}/ifood-data-eng-case"
}

resource "databricks_job" "job_ingestao_bronze" {
  name                = "1 - [iFood Case] - Ingestão Camada Bronze"

  task {
    task_key = "ingestao_bronze"
    existing_cluster_id = databricks_cluster.cluster_analise.id
    notebook_task {
      notebook_path = "${databricks_repo.repo_ifood_case.path}/main_flow.ipynb"
    }
  }

  tags = {
    "Projeto"       = "iFood Case IaC",
    "Camada"        = "Bronze",
    "GerenciadoPor" = "Terraform"
  }
}