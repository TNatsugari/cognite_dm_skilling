select
  externalId,
  space
from
  cdf_data_models(
    "dmu_rmdm_model",
    "RMDM",
    "1.0.0",
    "Asset"
  )
where space == 'dmu_rmdm_instances'
-- UNCOMMENT FOR TARGET DELETION
-- where type.externalId == 'COGATY-PLTF'