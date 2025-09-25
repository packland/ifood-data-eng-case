
    
    

select
    mes_ano as unique_field,
    count(*) as n_records

from `workspace`.`case_ifood`.`gold_monthly_metrics`
where mes_ano is not null
group by mes_ano
having count(*) > 1


