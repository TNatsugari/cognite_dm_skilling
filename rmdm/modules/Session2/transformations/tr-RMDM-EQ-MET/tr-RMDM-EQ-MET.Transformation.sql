SELECT
  CONCAT('EQ_MET-', CAST(FMP_NUMBER AS STRING), '-', CAST(METER_SERIAL_NUM AS STRING)) AS externalId,
  IFNULL(CAST(METER_SERIAL_NUM AS STRING), '') AS serialNumber,
  SPLIT(FMP_NAME, ',') AS aliases,
  CONCAT(CAST(FMP_NUMBER AS STRING), '-', IFNULL(CAST(RECORDER_MAKE AS STRING), 'Meter')) AS name,
  CONCAT(
  CAST(METER_MAKE AS STRING), '-', CAST(FMP_MEAS_TYP_CD AS STRING), ' meter; ', IFNULL(CAST(RECORDER_MAKE AS STRING), 'unknown'), ' recording device maker'
  	) AS manufacturer,
  CONCAT(CAST(FMP_MEAS_TYP_DESC AS STRING), ' meter, with status: ', CAST(METER_STAT_DESC AS STRING)) AS description,
  node_reference('dmu_rmdm_instances', PLATFORM_ID) AS asset,
  'dmu_rmdm_instances' AS space,
  'BSEE-Equipment-Meter' AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  CONCAT(
    ARRAY(cmpy.SORT_NAME),
    ARRAY(CAST(FMP_NUMBER_SALES AS STRING)),
    ARRAY(CAST(FMP_NUMBER_OUT AS STRING)),
    ARRAY(CAST(FMP_OPERATOR_NUM AS STRING)),
    ARRAY(CONCAT('Meter size [in]: ', CAST(METER_SIZE AS STRING)))
  ) AS tags,
  node_reference('dmu_rmdm_instances', CONCAT('EQTY-', METER_TYPE_CODE)) AS equipmentType,
  node_reference('dmu_rmdm_instances', 'EQCL-METER') AS equipmentClass

FROM `bsee`.`meters_headers` tnk
LEFT JOIN `bsee`.`companies_headers` AS cmpy
  ON tnk.BUS_ASC_NAME = cmpy.BUS_ASC_NAME
