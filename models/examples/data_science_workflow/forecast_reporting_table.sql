with forecast_daily_returns as (

    Select * from {{ ref('forecast_daily_returns') }}
)


Select 
*
from forecast_daily_returns