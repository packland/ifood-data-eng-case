SELECT
    -- Chaves da granularidade
    CAST(DATE_TRUNC('MONTH', tpep_pickup_datetime) AS DATE) AS mes_ano,
    EXTRACT(HOUR FROM tpep_pickup_datetime) AS hora_do_dia,
    
    AVG(passenger_count) AS media_passageiros, -- Responde ao case
    COUNT(trip_id) AS quant_corridas,
    AVG(total_amount) AS media_valor_total,
    AVG(trip_distance) AS media_km_percorrida

FROM `workspace`.`case_ifood`.`silver`
GROUP BY
    1, 2