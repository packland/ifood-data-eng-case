
    
    

with all_values as (

    select
        payment_type as value_field,
        count(*) as n_records

    from `workspace`.`case_ifood`.`silver`
    group by payment_type

)

select *
from all_values
where value_field not in (
    '0','1','2','3','4','5','6'
)


