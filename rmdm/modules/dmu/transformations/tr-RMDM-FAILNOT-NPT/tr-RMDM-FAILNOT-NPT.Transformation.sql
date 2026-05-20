SELECT DISTINCT
  CONCAT('FAILNOT_NPT-', npt.SN_NPT) AS externalId,
  'dmu_rmdm_instances' AS space,
  npt.LABLE AS name,
  'Equipment failure during the drilling and completion phase' AS description,
  CONCAT(
    array('Non Productive Time')
  ) AS aliases,
  CONCAT(
    array(CONCAT('Weekly Drilling Report #: ', CAST(SUBSTRING_INDEX(npt.SN_NPT, '_', 1) AS STRING)))
  ) AS tags,
  CONCAT('BSEE-NPT-',npt.LABLE) AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  node_reference('dmu_rmdm_instances', CONCAT('WLL-',CAST(npt.API_WELL_NUMBER AS STRING))) AS asset,
  ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLB-', CAST(npt.API_WELLBORE_NUMBER AS STRING)))) AS subunit,
  'NPT' AS type,
  'Non Productive Time' AS typeDescription,
  'SBMT' AS status,
  'Submitted' AS statusDescription,
  CAST(3 AS BIGINT) AS priority,
  'High' AS priorityDescription,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(npt.START_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE npt.START_DATE
  END,
  'yyyy-MM-dd'
  ) AS startTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(npt.START_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE npt.START_DATE
  END,
  'yyyy-MM-dd'
  ) AS StartTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(npt.END_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE npt.END_DATE
  END,
  'yyyy-MM-dd'
  ) AS endTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(npt.END_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE npt.END_DATE
  END,
  'yyyy-MM-dd'
  ) AS EndTime,
  npt.PROCEDURAL_NARRATIVE AS longText,
  'Drilling Non Productive Time' AS discipline,
  node_reference('dmu_rmdm_instances', failc.code) AS failureCause,
  node_reference('dmu_rmdm_instances', failmd.code) AS failureMode,
  node_reference('dmu_rmdm_instances', failm.code) AS failureMechanism,
  npt.PROCEDURAL_NARRATIVE AS failureImpactOnHSE,
  npt.PROCEDURAL_NARRATIVE AS failureImpactOnOperations,
  npt.PROCEDURAL_NARRATIVE AS failureEffect,
  npt.PROCEDURAL_NARRATIVE AS detectionMethod,
  npt.PROCEDURAL_NARRATIVE AS operatingConditionAtFailure
FROM `bsee`.`extracted_npts_with_target` npt
  LEFT JOIN `RMDM_RefData`.`RMDMFAILMD-FailureMode` AS failmd
  	ON npt.LABLE = failmd.refersTo
  LEFT JOIN `RMDM_RefData`.`RMDMFAILC-FailureCause` AS failc
  	ON npt.LABLE = failc.refersTo
  LEFT JOIN `RMDM_RefData`.`RMDMFAILM-FailureMechanism` AS failm
  	ON npt.LABLE = failm.refersTo