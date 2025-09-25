
    
    

with all_values as (

    select
        pickup_hour as value_field,
        count(*) as n_records

    from `workspace`.`case_ifood`.`gold_obt_taxi_trips`
    group by pickup_hour

)

select *
from all_values
where value_field not in (
    '0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23'
)


