-- Pergunta 2: Qual a média de passageiros (passenger_count) por cada hora do dia no mês de maio?
-- Esta query consulta a tabela agregada 'gold_hourly_metrics', filtrando apenas para o mês de Maio.
-- Para executar, copie e cole este código no SQL Editor do Databricks.

SELECT
    hora_do_dia,
    media_passageiros
FROM
    -- Nome completo da tabela no Databricks (catálogo.schema.tabela)
    workspace.case_ifood.gold_hourly_metrics
WHERE
    mes_ano = '2023-05-01'
ORDER BY
    hora_do_dia;