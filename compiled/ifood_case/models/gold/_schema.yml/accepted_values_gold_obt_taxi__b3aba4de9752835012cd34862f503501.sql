
    
    

with all_values as (

    select
        vendor_name as value_field,
        count(*) as n_records

    from `workspace`.`case_ifood`.`gold_obt_taxi_trips`
    group by vendor_name

)

select *
from all_values
where value_field not in (
    'Creative Mobile Technologies, LLC','Curb Mobility, LLC','Myle Technologies Inc','Helix','Id not mapped'
)


