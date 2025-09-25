



select
    1
from `workspace`.`case_ifood`.`silver`

where not(tpep_dropoff_datetime >= tpep_pickup_datetime)

