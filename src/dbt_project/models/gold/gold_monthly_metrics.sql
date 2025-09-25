select
    -- chave da granularidade: primeiro dia do mês
    cast(date_trunc('month', tpep_pickup_datetime) as date) as mes_ano,
    
    -- métricas agregadas
    count(trip_id) as quant_corridas,
    avg(total_amount) as media_valor_total, -- responde ao case
    sum(total_amount) as total_valor_arrecadado,
    sum(passenger_count) as total_passageiros,
    avg(passenger_count) as media_passageiros_por_corrida,
    sum(trip_distance) as total_km_percorrida,
    avg(trip_distance) as media_km_por_corrida

from {{ ref('silver') }}
group by
    1