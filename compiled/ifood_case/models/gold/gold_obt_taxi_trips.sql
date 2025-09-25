with silver_trips as (
    select * from `workspace`.`case_ifood`.`silver`
),

final as (
    select
        -- chaves e ids
        trip_id, 
        vendor_id,

        -- métricas
        passenger_count,
        trip_distance,
        total_amount,

        -- timestamps
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        -- extraindo data e hora para facilitar filtros
        cast(tpep_pickup_datetime as date) as pickup_date,
        extract(hour from tpep_pickup_datetime) as pickup_hour,

        -- campos descritivos (enriquecimento via case)
        case 
            when vendor_id = 1 then 'Creative Mobile Technologies, LLC'
            when vendor_id = 2 then 'Curb Mobility, LLC'
            when vendor_id = 6 then 'Myle Technologies Inc'
            when vendor_id = 7 then 'Helix'
            else 'Id not mapped'
        end as vendor_name
        
    from silver_trips
)

select * from final