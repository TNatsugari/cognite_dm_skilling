select
  externalId,
  space
from
  cdf_data_models(
    "cdf_cdm",
    "CogniteCore",
    "v1",
    "CogniteFileCategory"
  )
where externalId like '%COGFLCA_%'