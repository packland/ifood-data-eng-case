-- Pergunta 1: Qual a média de valor total (total_amount) recebido em um mês?
-- Esta query consulta a tabela agregada 'gold_monthly_metrics' para retornar o resultado diretamente.
-- Para executar, copie e cole este código no SQL Editor do Databricks.

SELECT
    mes_ano,
    media_valor_total
FROM
    -- Nome completo da tabela no Databricks (catálogo.schema.tabela)
    workspace.case_ifood.gold_monthly_metrics
ORDER BY
    mes_ano;