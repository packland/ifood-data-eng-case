# ifood-data-eng-case
Solução para o case técnico de engenharia de dados do iFood, utilizando PySpark, dbt e Delta Lake

Projeto de IaC para Databricks com Terraform e GitHub Actions
Este repositório contém a infraestrutura como código (IaC) para provisionar um ambiente de análise no Azure Databricks. O processo é 100% automatizado via GitHub Actions e o estado da infraestrutura é gerenciado de forma segura pelo Terraform Cloud.

Configuração e Implementação
Siga estes passos para configurar e executar o projeto pela primeira vez.

Passo 1: Obter Credenciais do Databricks
Para que o Terraform possa se comunicar com sua conta, ele precisa de um token de acesso.

No seu workspace Databricks, clique no seu nome de usuário no canto superior direito e selecione "User Settings".

Vá para a aba "Developer".

Na seção "Access tokens", clique no botão "Manage" e depois em "Generate new token".

Adicione um comentário (ex: Token para IaC do GitHub) e defina um tempo de vida (ex: 90 dias).

Clique em "Generate".

Atenção: Copie o token gerado imediatamente e guarde-o em um local seguro. Você não poderá vê-lo novamente.

Passo 2: Configurar o Terraform Cloud
O Terraform Cloud irá armazenar o "estado" da nossa infraestrutura e executar os planos e aplicações.

Crie uma Conta Gratuita: Acesse app.terraform.io e crie uma conta (pode usar seu login do GitHub).

Crie uma "Organization" e um "Workspace": Siga o setup inicial para criar uma organização (pode ser seu nome de usuário) e um novo workspace do tipo "CLI-driven workflow" (ex: databricks-iac-ifood).

Gere um Token de API do Terraform Cloud:

Dentro do Terraform Cloud, vá em "User Settings" > "Tokens".

Clique em "Create an API token", dê uma descrição e copie o token gerado.

Configure o Backend no Código: Crie o arquivo terraform/backend.tf com o conteúdo abaixo, substituindo os valores da sua organização e workspace:

Terraform

# Arquivo: terraform/backend.tf

terraform {
  cloud {
    organization = "seu-nome-da-organizacao"
    workspaces {
      name = "databricks-iac-ifood"
    }
  }
}
Passo 3: Configurar as Variáveis no Terraform Cloud
Agora, vamos informar ao Terraform Cloud quais são as credenciais do Databricks. É aqui que as variáveis são gravadas, e não mais no GitHub.

Acesse seu workspace no Terraform Cloud.

Vá para a aba "Variables".

Na seção "Workspace Variables", adicione as duas variáveis a seguir:

DATABRICKS_HOST

Value: A URL completa do seu workspace Databricks (https://adb-....azuredatabricks.net).

Deixe como "Terraform Variable" e NÃO marque como "Sensitive".

DATABRICKS_TOKEN

Value: O token do Databricks que você gerou no Passo 1.

Deixe como "Terraform Variable" e MARQUE a opção "Sensitive".