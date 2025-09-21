# ifood-data-eng-case
Solução para o case técnico de engenharia de dados do iFood, utilizando PySpark, dbt e Delta Lake

Instruções de implementação. 

No seu workspace Databricks, clique no seu nome de usuário no canto superior direito e selecione "User Settings".

Vá para a aba "Developer".

Na seção "Access tokens", clique no botão "Manage".

Clique em "Generate new token".

Adicione um comentário descritivo, como Token para automação com Terraform/GitHub.

Defina o tempo de vida (em dias). Para começar, pode deixar 90 dias. Se deixar em branco, o token não expira (conveniente para agora, mas menos seguro para produção).

Clique em "Generate".

ATENÇÃO: O Databricks mostrará o token apenas uma vez. Copie o token imediatamente e guarde-o em um local seguro. Você não poderá vê-lo novamente.

Passo 2: Configurar os Secrets no Repositório GitHub
Agora, vamos ao seu repositório no GitHub. Vá em Settings > Secrets and variables > Actions e crie os dois secrets a seguir. Se já os criou antes, apenas atualize os valores.

DATABRICKS_HOST

Valor: A URL completa do seu workspace Databricks, começando com https://.

Exemplo: https://adb-1234567890123456.7.azuredatabricks.net

DATABRICKS_TOKEN

Valor: O token (PAT) que você acabou de gerar no passo anterior. Ele começará com dapi....

TERRAFORM

Passo 2: Gere um Token de API
Este token permitirá que o GitHub Actions se comunique com sua conta do Terraform Cloud de forma segura.

Dentro do Terraform Cloud, clique no seu ícone de perfil no canto superior direito e vá para "User Settings".

No menu à esquerda, clique em "Tokens".

Clique em "Create an API token".

Dê uma descrição (ex: GitHub Actions Token) e clique em "Create API token".

Copie o token gerado! Ele não será mostrado novamente.

Passo 3: Adicione o Token como um Segredo no GitHub
Vá para o seu repositório no GitHub.

Clique em "Settings" > "Secrets and variables" > "Actions".

Clique em "New repository secret".

No campo "Name", digite TF_API_TOKEN.

No campo "Secret", cole o token que você copiou do Terraform Cloud.

Clique em "Add secret".

Passo 4: Configure o Backend no seu Código Terraform
Crie um novo arquivo no seu projeto chamado terraform/backend.tf. Este arquivo dirá ao Terraform para usar o workspace que você criou.

Arquivo: terraform/backend.tf

Terraform

# Arquivo: terraform/backend.tf

terraform {
  cloud {
    # Substitua pelo nome da organização que você criou
    organization = "seu-nome-da-organizacao" 

    workspaces {
      # Substitua pelo nome do workspace que você criou
      name = "databricks-iac-ifood"
    }
  }
}
Importante: Lembre-se de substituir seu-nome-da-organizacao pelo nome da sua organização no Terraform Cloud.