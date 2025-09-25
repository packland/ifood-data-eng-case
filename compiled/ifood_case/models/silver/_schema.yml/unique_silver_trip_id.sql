
    
    

select
    trip_id as unique_field,
    count(*) as n_records

from `workspace`.`case_ifood`.`silver`
where trip_id is not null
group by trip_id
having count(*) > 1


