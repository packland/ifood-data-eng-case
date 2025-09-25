
    
    

with all_values as (

    select
        rate_code_id as value_field,
        count(*) as n_records

    from `workspace`.`case_ifood`.`silver`
    group by rate_code_id

)

select *
from all_values
where value_field not in (
    '1','2','3','4','5','6','99'
)


