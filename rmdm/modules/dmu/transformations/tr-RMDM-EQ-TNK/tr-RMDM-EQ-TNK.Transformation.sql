SELECT
  CONCAT('EQ_TNK-', CAST(FMP_NUMBER AS STRING), '-', CAST(TANK_SERIAL_NUM AS STRING)) AS externalId,
  IFNULL(CAST(TANK_SERIAL_NUM AS STRING), '') AS serialNumber,
  SPLIT(TANK_ID_NUM, ',') AS aliases,
  CONCAT('Tank','-',IFNULL(CAST(FMP_NUMBER AS STRING), '9999')) AS name,
  IFNULL(CAST(RECORDER_MAKE AS STRING), '') AS manufacturer,
  CONCAT(CAST(FMP_MEAS_TYP_DESC AS STRING), ', with status: ', CAST(TANK_STAT_DESC AS STRING)) AS description,
  node_reference('dmu_rmdm_instances', PLATFORM_ID) AS asset,
  'dmu_rmdm_instances' AS space,
  'BSEE-Equipment-Tank' AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  CONCAT(
    ARRAY(cmpy.SORT_NAME),
    ARRAY(CAST(FMP_NUMBER_SALES AS STRING)),
    ARRAY(CAST(FMP_NUMBER_OUT AS STRING)),
    ARRAY(CAST(FMP_OPERATOR_NUM AS STRING)),
    ARRAY(CONCAT('Tank storage capacity: ', CAST(TANK_STORAGE_CAP AS STRING)))
  ) AS tags,
  node_reference('dmu_rmdm_instances', CONCAT('EQTY-', FMP_MEAS_TYP_CD)) AS equipmentType,
  node_reference('dmu_rmdm_instances', 'EQCL-TANK') AS equipmentClass

FROM `bsee`.`tanks_headers` tnk
LEFT JOIN `bsee`.`companies_headers` AS cmpy
  ON tnk.BUS_ASC_NAME = cmpy.BUS_ASC_NAME
