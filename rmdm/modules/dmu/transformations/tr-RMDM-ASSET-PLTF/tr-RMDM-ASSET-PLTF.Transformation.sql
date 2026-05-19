SELECT DISTINCT
  'dmu_rmdm_instances' AS space
  ,CONCAT('PLTF-', FACILITY_ID, '-', COMPLEX_ID_NUM) AS externalId
  ,CASE 
      WHEN AREA_CODE IS NULL THEN NULL
      ELSE node_reference('dmu_rmdm_instances', CONCAT('FLD-', FIELD_NAME_CODE, '-', CAST(AREA_CODE AS STRING), CAST(BLOCK_NUMBER AS STRING)))
   END AS parent
  ,CONCAT(CAST(STRUCTURE_NAME AS STRING),'-',STRUC_TYPE_CODE) AS name
  ,SPLIT(COMPLEX_ID_NUM, ',') AS aliases
  ,CONCAT(
    ARRAY(cmpy.`SORT_NAME`),
    ARRAY(COMPLEX_ID_NUM),
    ARRAY(LEASE_NUMBER),
    ARRAY(CONCAT(CAST(AREA_CODE AS STRING), CAST(BLOCK_NUMBER AS STRING))),
    ARRAY(CONCAT('Water depth [ft]: ', WATER_DEPTH))  
  ) AS tags
  ,TO_TIMESTAMP(
    CASE 
      WHEN LOWER(TRIM(INSTALL_DATE)) IN ('unknown', 'uknown') THEN NULL
      ELSE INSTALL_DATE
    END,
    'M/d/yyyy'
  ) AS sourceCreatedTime
  ,CONCAT(STRUCT_TYPE, ' platform') AS description
  ,node_reference('dmu_rmdm_instances', 'COGATY-PLTF') as type
  ,'BSEE-Platform' AS sourceContext
  ,node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source

FROM `bsee`.`platforms_headers` pltf
LEFT JOIN `bsee`.`companies_headers` AS cmpy
ON pltf.BUS_ASC_NAME = cmpy.BUS_ASC_NAME
WHERE FACILITY_ID IS NOT NULL 