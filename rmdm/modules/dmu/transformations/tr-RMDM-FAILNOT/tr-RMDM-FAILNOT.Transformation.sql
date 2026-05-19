SELECT DISTINCT
  CONCAT('FAILNOT-', fail.UNIQUE_ID) AS externalId,
  'dmu_rmdm_instances' AS space,
  fail.LABLE AS name,
  'Equipment failure during the production life of the well(s)' AS description,
  CONCAT(
    -- array('Failure'),
    array(fail.LABLE_2),
    array(fail.APM_SUBOP_CD),
    array(fail.APM_OP_CD)
  ) AS aliases,
  CONCAT(
    array(CONCAT('Permission to modify #: ', CAST(fail.SN_APM AS STRING)))
  ) AS tags,
  CONCAT('BSEE-Failure-',fail.LABLE) AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  node_reference('dmu_rmdm_instances', CONCAT('MORD_REST-',CAST(SN_APM AS STRING))) AS maintenanceOrder,
  node_reference('dmu_rmdm_instances', CONCAT('WLL-',CAST(fail.API_WELL_NUMBER AS STRING))) AS asset,
  ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLB-', CAST(fail.API_WELLBORE_NUMBER AS STRING)))) AS subunit,
  -- node_reference('dmu_rmdm_instances', fail.PLATFORM_ID) AS asset,
  -- ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLL-', CAST(fail.API_WELL_NUMBER AS STRING)))) AS subunit,
  'FAIL' AS type,
  fail.LABLE_2 AS typeDescription,
  -- 'Failure' AS typeDescription,
  'SBMT' AS status,
  'Submitted' AS statusDescription,
  priority_synthetic AS priority,
  priorityDescription_synthetic AS priorityDescription,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(fail.WORK_COMMENCES_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE fail.WORK_COMMENCES_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS startTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(fail.WORK_COMMENCES_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE fail.WORK_COMMENCES_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS StartTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(fail.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE fail.WORK_ENDS_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS endTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(fail.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE fail.WORK_ENDS_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS EndTime,
  fail.APM_OP_DESC AS longText,
  fail.APM_OP_CD AS discipline,
  node_reference('dmu_rmdm_instances', failc.code) AS failureCause,
  node_reference('dmu_rmdm_instances', failmd.code) AS failureMode,
  node_reference('dmu_rmdm_instances', failm.code) AS failureMechanism,
  fail.PROCEDURAL_NARRATIVE AS failureImpactOnHSE,
  fail.PROCEDURAL_NARRATIVE AS failureImpactOnOperations,
  fail.PROCEDURAL_NARRATIVE AS failureEffect,
  fail.PROCEDURAL_NARRATIVE AS detectionMethod,
  fail.PROCEDURAL_NARRATIVE AS operatingConditionAtFailure
FROM `bsee`.`extracted_failures` fail
-- FROM `bsee`.`synthetic_tank_failures` fail
--   LEFT JOIN `bsee`.`extracted_restorations` AS rest
-- 	ON CAST(fail.SN_APM AS STRING) = CAST(rest.SN_APM AS STRING)
--   	AND CAST(fail.API_WELLBORE_NUMBER AS STRING) = CAST(rest.API_WELLBORE_NUMBER AS STRING)
  LEFT JOIN `RMDM_RefData`.`RMDMFAILMD-FailureMode` AS failmd
  	ON fail.LABLE = failmd.refersTo
  LEFT JOIN `RMDM_RefData`.`RMDMFAILC-FailureCause` AS failc
  	ON fail.LABLE = failc.refersTo
  LEFT JOIN `RMDM_RefData`.`RMDMFAILM-FailureMechanism` AS failm
  	ON fail.LABLE = failm.refersTo