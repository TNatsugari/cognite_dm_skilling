select
  externalId,
  space
from
  cdf_data_models(
    "dmu_rmdm_model",
    "RMDM",
    "1.0.0",
    "FailureCause"
  )
where externalId like 'FAILC%'