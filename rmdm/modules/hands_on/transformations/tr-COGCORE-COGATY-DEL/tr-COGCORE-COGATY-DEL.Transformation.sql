select
  externalId,
  space
from
  cdf_data_models(
    "cdf_cdm",
    "CogniteCore",
    "v1",
    "CogniteAssetType"
  )
where externalId like '%COGATY_%'