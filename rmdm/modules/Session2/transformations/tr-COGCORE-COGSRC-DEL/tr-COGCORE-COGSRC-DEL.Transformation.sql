select
  externalId,
  space
from
  cdf_data_models(
    "cdf_cdm",
    "CogniteCore",
    "v1",
    "CogniteSourceSystem"
  )
where externalId like '%COGSRC_%'