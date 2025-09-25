-- dbt_project/models/silver/silver.sql

with source_data as (
    select
        -- ids e chaves (com dupla conversão)
        cast(cast(vendorid as double) as integer) as vendor_id,
        cast(cast(ratecodeid as double) as integer) as rate_code_id,
        cast(cast(pulocationid as double) as integer) as pu_location_id,
        cast(cast(dolocationid as double) as integer) as do_location_id,
        cast(cast(payment_type as double) as integer) as payment_type,

        -- timestamps
        cast(tpep_pickup_datetime as timestamp) as tpep_pickup_datetime,
        cast(tpep_dropoff_datetime as timestamp) as tpep_dropoff_datetime,

        -- métricas da viagem (com dupla conversão)
        cast(cast(passenger_count as double) as integer) as passenger_count,
        cast(trip_distance as double) as trip_distance,
        store_and_fwd_flag,

        -- valores monetários
        cast(fare_amount as double) as fare_amount,
        cast(extra as double) as extra,
        cast(mta_tax as double) as mta_tax,
        cast(tip_amount as double) as tip_amount,
        cast(tolls_amount as double) as tolls_amount,
        cast(improvement_surcharge as double) as improvement_surcharge,
        cast(total_amount as double) as total_amount,
        cast(congestion_surcharge as double) as congestion_surcharge,
        cast(airport_fee as double) as airport_fee

    from {{ source('case_ifood', 'bronze') }}
    where tpep_pickup_datetime >= '2023-01-01' and tpep_pickup_datetime < '2023-06-01'
),

-- cte 2: gera a chave primária robusta e aplica filtros de qualidade.
final as (
    select
        -- geração da chave primária surrogate com mais colunas para garantir unicidade
        {{ dbt_utils.generate_surrogate_key([
            'vendor_id',
            'tpep_pickup_datetime',
            'tpep_dropoff_datetime',
            'pu_location_id',
            'do_location_id',
            'total_amount',
            'passenger_count',
            'trip_distance'
        ]) }} as trip_id,
        *
    from source_data
    where
        total_amount >= 0
        and fare_amount >= 0
        and tpep_dropoff_datetime > tpep_pickup_datetime
        and passenger_count > 0
)

select * from final