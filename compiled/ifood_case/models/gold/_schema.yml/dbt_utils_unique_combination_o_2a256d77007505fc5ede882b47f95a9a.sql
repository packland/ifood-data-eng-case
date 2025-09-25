





with validation_errors as (

    select
        mes_ano, hora_do_dia
    from `workspace`.`case_ifood`.`gold_hourly_metrics`
    group by mes_ano, hora_do_dia
    having count(*) > 1

)

select *
from validation_errors


