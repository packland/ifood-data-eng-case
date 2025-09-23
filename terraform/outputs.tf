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