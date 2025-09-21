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