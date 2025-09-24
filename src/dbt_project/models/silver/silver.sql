-- dbt_project/models/silver/silver.sql

{{
    config(
        materialized='incremental',
        unique_key='trip_id'
    )
}}

-- CTE 1: Seleciona, renomeia e faz o casting das colunas da camada Bronze.
WITH source_data AS (
    SELECT
        -- IDs e Chaves (com dupla conversão)
        CAST(CAST(vendorid AS DOUBLE) AS INTEGER) AS vendor_id,
        CAST(CAST(ratecodeid AS DOUBLE) AS INTEGER) AS rate_code_id,
        CAST(CAST(pulocationid AS DOUBLE) AS INTEGER) AS pu_location_id,
        CAST(CAST(dolocationid AS DOUBLE) AS INTEGER) AS do_location_id,
        CAST(CAST(payment_type AS DOUBLE) AS INTEGER) AS payment_type,

        -- Timestamps
        CAST(tpep_pickup_datetime AS TIMESTAMP) AS tpep_pickup_datetime,
        CAST(tpep_dropoff_datetime AS TIMESTAMP) AS tpep_dropoff_datetime,

        -- Métricas da Viagem (com dupla conversão)
        CAST(CAST(passenger_count AS DOUBLE) AS INTEGER) AS passenger_count,
        CAST(trip_distance AS DOUBLE) AS trip_distance,
        store_and_fwd_flag,

        -- Valores Monetários
        CAST(fare_amount AS DOUBLE) AS fare_amount,
        CAST(extra AS DOUBLE) AS extra,
        CAST(mta_tax AS DOUBLE) AS mta_tax,
        CAST(tip_amount AS DOUBLE) AS tip_amount,
        CAST(tolls_amount AS DOUBLE) AS tolls_amount,
        CAST(improvement_surcharge AS DOUBLE) AS improvement_surcharge,
        CAST(total_amount AS DOUBLE) AS total_amount,
        CAST(congestion_surcharge AS DOUBLE) AS congestion_surcharge,
        CAST(airport_fee AS DOUBLE) AS airport_fee

    FROM {{ source('case_ifood', 'bronze') }}
    {% if is_incremental() %}
    -- Lógica incremental futura
    {% endif %}
),

-- CTE 2: Gera a chave primária robusta e aplica filtros de qualidade.
final AS (
    SELECT
        -- Geração da chave primária surrogate com mais colunas para garantir unicidade
        {{ dbt_utils.generate_surrogate_key([
            'vendor_id',
            'tpep_pickup_datetime',
            'tpep_dropoff_datetime',
            'pu_location_id',
            'do_location_id',
            'total_amount',
            'passenger_count',
            'trip_distance'
        ]) }} AS trip_id,
        *
    FROM source_data
    WHERE
        total_amount >= 0
        AND fare_amount >= 0
        AND tpep_dropoff_datetime > tpep_pickup_datetime
        AND passenger_count > 0
)

SELECT * FROM final