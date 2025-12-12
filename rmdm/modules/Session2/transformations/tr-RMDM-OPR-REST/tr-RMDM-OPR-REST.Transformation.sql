SELECT DISTINCT
  CONCAT('OPR_REST-', rest.UNIQUE_ID) AS externalId,
  'dmu_rmdm_instances' AS space,
  rest.LABLE AS name,
  rest.APM_SUBOP_DESC AS description,
  CONCAT(
    array(rest.LABLE_2),
    -- array('Restoration'),
    array(rest.APM_OP_CD),
    array(rest.APM_SUBOP_CD)
  ) AS aliases,
  CONCAT(
    array(CONCAT('Permission to modify #: ', CAST(rest.SN_APM AS STRING)))
  ) AS tags,
  CONCAT('BSEE-Operation-',rest.APM_SUBOP_CD) AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  node_reference('dmu_rmdm_instances', CONCAT('MORD_REST-',CAST(rest.SN_APM AS STRING))) AS maintenanceOrder,
  node_reference('dmu_rmdm_instances', CONCAT('WLL-', CAST(rest.API_WELL_NUMBER AS STRING))) AS mainAsset,
  ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLB-', CAST(rest.API_WELLBORE_NUMBER AS STRING)))) AS assets,
  -- node_reference('dmu_rmdm_instances', rest.PLATFORM_ID) AS mainAsset,
  -- ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLL-', CAST(rest.API_WELL_NUMBER AS STRING)))) AS assets,
  rest.APM_SUBOP_CD AS operationCode,
  rest.APM_OP_DESC AS operationDesc,
  'CLOSED' AS status,
  rest.Sequence AS sequence,
  rest.APM_OP AS phase,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(rest.WORK_COMMENCES_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE rest.WORK_COMMENCES_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS startTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(rest.WORK_COMMENCES_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE rest.WORK_COMMENCES_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS scheduledStartTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(rest.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE rest.WORK_ENDS_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS endTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(rest.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE rest.WORK_ENDS_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS scheduledEndTime,
  TO_DATE(
  CASE 
    WHEN LOWER(TRIM(rest.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE rest.WORK_ENDS_DATE
  END,
  'yyyy-MM-dd'
  -- 'dd/MM/yyyy'
  ) AS maintenanceOrderDueDate,
  'Shut-in' AS systemCondition,
  -- 'Out of Service' AS systemCondition,
  TRUE AS finalConfirmed,
  CAST(rest.EST_OPERATION_DAYS * 24 AS DOUBLE) AS personHours,
  rest.APM_SUBOP_DESC AS maintActivityTypeDesc
FROM `bsee`.`extracted_restorations` rest
-- FROM `bsee`.`synthetic_tank_restorations` rest
-- where rest.`UNIQUE_ID` == '193428-608114041300-BOP repairs/maintenance'