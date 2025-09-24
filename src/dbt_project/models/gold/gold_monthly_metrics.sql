SELECT
    -- Chave da granularidade: primeiro dia do mês
    CAST(DATE_TRUNC('MONTH', tpep_pickup_datetime) AS DATE) AS mes_ano,
    
    -- Métricas Agregadas
    COUNT(trip_id) AS quant_corridas,
    AVG(total_amount) AS media_valor_total, -- Responde ao case
    SUM(total_amount) AS total_valor_arrecadado,
    SUM(passenger_count) AS total_passageiros,
    AVG(passenger_count) AS media_passageiros_por_corrida,
    SUM(trip_distance) AS total_km_percorrida,
    AVG(trip_distance) AS media_km_por_corrida

FROM {{ ref('silver') }}
GROUP BY
    1