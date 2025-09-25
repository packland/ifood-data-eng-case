WITH silver_trips AS (
    SELECT * FROM `workspace`.`case_ifood`.`silver`
),

final AS (
    SELECT
        -- Chaves e IDs
        trip_id, 
        vendor_id,

        -- Métricas
        passenger_count,
        trip_distance,
        total_amount,

        -- Timestamps
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        -- Extraindo data e hora para facilitar filtros
        CAST(tpep_pickup_datetime AS DATE) AS pickup_date,
        EXTRACT(HOUR FROM tpep_pickup_datetime) AS pickup_hour,

        -- Campos Descritivos (Enriquecimento via CASE)
        CASE 
            WHEN vendor_id = 1 THEN 'Creative Mobile Technologies, LLC'
            WHEN vendor_id = 2 THEN 'Curb Mobility, LLC'
            WHEN vendor_id = 6 THEN 'Myle Technologies Inc'
            WHEN vendor_id = 7 THEN 'Helix'
            ELSE 'Id not mapped'
        END AS vendor_name
        
    FROM silver_trips
)

SELECT * FROM final