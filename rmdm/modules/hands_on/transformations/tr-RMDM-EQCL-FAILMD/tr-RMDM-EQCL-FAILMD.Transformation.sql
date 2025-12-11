WITH FailureModes AS (
  SELECT 
    failmd.code AS failmdExternalId,
    'dmu_rmdm_instances' AS failmdSpace,
    failmd.equipmentClasses AS equipmentClass
  FROM `RMDM_RefData`.`RMDMFAILMD-FailureMode` failmd
)

SELECT
  eqcl.space AS space,
  eqcl.externalId AS externalId,
  ARRAY_AGG(DISTINCT node_reference(fmd.failmdSpace, fmd.failmdExternalId)) AS failureModes
FROM cdf_data_models('dmu_rmdm_model', 'RMDM', '1.0.0', 'EquipmentClass') eqcl
JOIN FailureModes fmd
  ON eqcl.code = fmd.equipmentClass
GROUP BY eqcl.space, eqcl.externalId;