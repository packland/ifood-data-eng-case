select
    -- chaves da granularidade
    cast(date_trunc('month', tpep_pickup_datetime) as date) as mes_ano,
    extract(hour from tpep_pickup_datetime) as hora_do_dia,
    
    avg(passenger_count) as media_passageiros, -- responde ao case
    count(trip_id) as quant_corridas,
    avg(total_amount) as media_valor_total,
    avg(trip_distance) as media_km_percorrida

from `workspace`.`case_ifood`.`silver`
group by
    1, 2