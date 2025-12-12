select
  externalId,
  space
from
  cdf_data_models(
    "dmu_rmdm_model",
    "RMDM",
    "1.0.0",
    "Operation"
  )
where externalId like 'OPR_REST%'