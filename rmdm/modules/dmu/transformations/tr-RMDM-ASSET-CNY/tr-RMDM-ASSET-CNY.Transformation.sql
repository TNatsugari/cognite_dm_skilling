SELECT DISTINCT
  'dmu_rmdm_instances' AS space
  ,CONCAT('CNY-', CAST(AREA_CODE AS STRING)) AS externalId
  ,CAST(CANYON_NAME AS STRING) AS name
  ,SPLIT(AREA_CODE, ',') AS aliases
  ,'Subsurface offshore canyon of the Gulf of America (former Gulf of Mexico)' AS description
  ,node_reference('dmu_rmdm_instances', 'COGATY-CNY') AS type
  ,'BSEE-Canyon' AS sourceContext
  ,node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source

FROM `bsee`.`fields_headers` 
WHERE AREA_CODE IS NOT NULL