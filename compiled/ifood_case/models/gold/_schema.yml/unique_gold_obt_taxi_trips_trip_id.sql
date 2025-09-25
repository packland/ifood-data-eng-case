
    
    

select
    trip_id as unique_field,
    count(*) as n_records

from `workspace`.`case_ifood`.`gold_obt_taxi_trips`
where trip_id is not null
group by trip_id
having count(*) > 1


