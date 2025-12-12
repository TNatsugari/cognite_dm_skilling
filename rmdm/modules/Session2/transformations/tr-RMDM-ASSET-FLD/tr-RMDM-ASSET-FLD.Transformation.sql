SELECT
  'dmu_rmdm_instances' AS space,
  CONCAT('FLD-', FIELD_NAME_CODE, '-', CAST(AREA_CODE AS STRING), CAST(BLOCK_NUMBER AS STRING)) AS externalId,
  CASE 
    WHEN AREA_CODE IS NULL THEN NULL
    ELSE node_reference('dmu_rmdm_instances', CONCAT('CNY-', AREA_CODE))
  END AS parent,
  CAST(FIELD_NAME_CODE AS STRING) AS name,
  SPLIT(LEASE_NUMBER, ',') AS aliases,
  CONCAT(
    array(SORT_NAME),
    array(CONCAT('EIA Field Code: ', CAST(EIA_FIELD_CODE AS STRING)))
  ) AS tags,
  TO_TIMESTAMP(FLD_LSE_EFF_DATE, 'MMM-yyyy') AS sourceCreatedTime,
  TO_TIMESTAMP(FLD_LSE_EXPIR_DT, 'MMM-yyyy') AS sourceUpdatedTime,
  CASE 
    WHEN FLD_LSE_DESC IS NULL THEN 
      CONCAT(
        'Leased block of the ', AREA_CODE, 
        ' GoA canyon with, lease status: ', 
        COALESCE(LEASE_STATUS_GROUP, 'unknown')
      )
    ELSE 
      CONCAT('Field lease description: ', FLD_LSE_DESC, ', with lease status: ', 
        COALESCE(LEASE_STATUS_GROUP, 'unknown'))
  END AS description,
  node_reference('dmu_rmdm_instances', 'COGATY-FLD') AS type,
  'BSEE-Field' AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source
FROM `bsee`.`fields_headers`
WHERE SORT_NAME IS NOT NULL 
  AND FIELD_NAME_CODE IS NOT NULL 
  AND BLOCK_NUMBER IS NOT NULL