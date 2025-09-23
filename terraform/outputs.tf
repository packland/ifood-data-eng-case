# Arquivo: terraform/outputs.tf

output "cluster_url" {
  description = "A URL para acessar a interface do cluster no Databricks."
  value       = databricks_cluster.cluster_analise.url
}

output "cluster_id" {
  description = "O ID do cluster criado."
  value       = databricks_cluster.cluster_analise.id
}

# --- BLOCO DE DEPURAÇÃO ---
# Adicione este bloco para testar se as variáveis estão chegando.

output "debug_repo_url_recebida" {
  description = "DEBUG: Mostra o valor da variável repo_url que o Terraform está vendo."
  value       = var.repo_url
}

output "debug_databricks_host_recebido" {
  description = "DEBUG: Mostra o valor da variável DATABRICKS_HOST."
  value       = var.DATABRICKS_HOST
}

# IMPORTANTE: NUNCA FAÇA UM OUTPUT DE UMA VARIÁVEL SENSÍVEL COMO O TOKEN!