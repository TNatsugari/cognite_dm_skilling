select
  externalId,
  space
from
  cdf_data_models(
    "dmu_rmdm_model",
    "RMDM",
    "1.0.0",
    "TimeSeriesExt"
  )
where space == 'dmu_rmdm_instances'
-- UNCOMMENT FOR TARGET DELETION
-- where externalId like '%%'