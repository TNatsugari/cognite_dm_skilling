SELECT DISTINCT
  'dmu_rmdm_instances' AS space
  ,CONCAT('WLB-', CAST(wlb.API_WELLBORE_NUMBER AS STRING)) AS externalId
  ,node_reference('dmu_rmdm_instances', wll.externalId) AS parent
  ,CAST(wlb.WELL_NAME_SUFFIX AS STRING) AS name
  ,CONCAT(
    array(CONCAT(cmpy.`SORT_NAME`)),
    array(wlb.BOREHOLE_STAT_CD),
    array(CONCAT(wlb.BOTM_AREA_CODE, CAST(wlb.BOTM_BLOCK_NUMBER AS STRING))),
    array(wlb.BOTM_LEASE_NUMBER)
  ) AS tags
  ,TO_TIMESTAMP(
    CASE 
      WHEN LOWER(TRIM(wlb.BOREHOLE_STAT_DT)) IN ('unknown', 'uknown') THEN NULL
      ELSE wlb.BOREHOLE_STAT_DT
    END,
    'M/d/yyyy'
  ) AS sourceCreatedTime
  ,CONCAT(
        wlb.BOREHOLE_STAT_CD, 
        ', with status effective from: ', 
        wlb.BOREHOLE_STAT_DT) AS description
  ,node_reference('dmu_rmdm_instances', 'COGATY-WLB') as type
  ,'BSEE-Wellbore' AS sourceContext
  ,node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source
FROM `bsee`.`wellbore_headers` as wlb
LEFT JOIN `bsee`.`companies_headers` AS cmpy
  ON wlb.COMPANY_NAME = cmpy.BUS_ASC_NAME
INNER JOIN cdf_data_models('dmu_rmdm_model', 'RMDM', '1.0.0', 'Asset') AS wll
  ON CONCAT('WLL-', wlb.API_WELL_NUMBER) = wll.externalId
WHERE wlb.API_WELL_NUMBER IS NOT NULL
AND wlb.API_WELLBORE_NUMBER IS NOT NULL 