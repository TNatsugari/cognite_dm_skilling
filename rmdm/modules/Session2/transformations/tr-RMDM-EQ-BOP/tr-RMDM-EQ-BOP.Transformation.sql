SELECT
  CONCAT('EQ_BOP-', CAST(bop.serialNumber AS STRING)) AS externalId,
  IFNULL(CAST(bop.serialNumber AS STRING), '') AS serialNumber,
  CAST(bop.name AS STRING) AS name,
  CAST(manufacturer AS STRING) AS manufacturer,
  bop.description AS description,
  node_reference('dmu_rmdm_instances', CONCAT('WLL-', CAST(bop.API_WELL_NUMBER AS STRING))) AS asset,
  'dmu_rmdm_instances' AS space,
  'Synthetic-Equipment-BOP' AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-SYN') AS source,
  TO_DATE(
    CASE 
      WHEN LOWER(TRIM(wll.WELL_SPUD_DATE)) IN ('unknown', 'uknown') THEN NULL
      ELSE wll.WELL_SPUD_DATE
    END,
    'M/d/yyyy'
  ) AS startDateCurrentService,
  CASE
    WHEN aliases = "" THEN null
    ELSE split(aliases, ",")
  END AS aliases,
  CASE
    WHEN tags = "" THEN null
    ELSE split(tags, ",")
  END AS tags,
  node_reference('dmu_rmdm_instances', CONCAT('EQTY-', 'SVLV')) AS equipmentType,
  node_reference('dmu_rmdm_instances', 'EQCL-VALVE') AS equipmentClass

FROM `bsee`.`bop_headers_synthetic` bop
LEFT JOIN `bsee`.`well_headers` AS wll
  ON CAST(bop.API_WELL_NUMBER AS STRING) = CAST(wll.API_WELL_NUMBER AS STRING)
WHERE bop.serialNumber IS NOT NULL
