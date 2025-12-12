WITH filtered_pltf AS (
  SELECT *
  FROM cdf_data_models('dmu_rmdm_model', 'RMDM', '1.0.0', 'Asset')
  WHERE externalId LIKE 'PLTF%'
),
joined_data AS (
  SELECT
    'dmu_rmdm_instances' AS space,
    CONCAT('WLL-', CAST(wll.API_WELL_NUMBER AS STRING)) AS externalId,
    node_reference('dmu_rmdm_instances', pltf.externalId) AS parent,
    CAST(wll.WELL_NAME AS STRING) AS name,
    CONCAT(
      array(cmpy.SORT_NAME),
      array(wll.WELL_TYPE_CODE),
      array(CONCAT(wll.BOTM_AREA_CODE, CAST(wll.BOTM_BLOCK_NUMBER AS STRING))),
      array(wll.SURF_LEASE_NUMBER)
    ) AS tags,
    TO_TIMESTAMP(
      CASE 
        WHEN LOWER(TRIM(wll.WELL_SPUD_DATE)) IN ('unknown', 'uknown') THEN NULL
        ELSE wll.WELL_SPUD_DATE
      END,
      'M/d/yyyy'
    ) AS sourceCreatedTime,
    CONCAT(
      wll.WELL_TYPE_CODE, ' well with spud date: ', wll.WELL_SPUD_DATE
    ) AS description,
    node_reference('dmu_rmdm_instances', 'COGATY-WLL') AS type,
    'BSEE-Well' AS sourceContext,
    node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source
  FROM `bsee`.`well_headers` AS wll
  LEFT JOIN `bsee`.`companies_headers` AS cmpy
    ON wll.COMPANY_NAME = cmpy.BUS_ASC_NAME
  INNER JOIN cdf_data_models('dmu_rmdm_model', 'RMDM', '1.0.0', 'Asset') AS pltf
    ON CONCAT('PLTF-', wll.PLATFORM_ID) = pltf.externalId
  WHERE wll.API_WELL_NUMBER IS NOT NULL
)
SELECT *
FROM joined_data
