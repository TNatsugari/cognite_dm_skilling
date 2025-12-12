SELECT DISTINCT
  CONCAT('OPR_OPT-', opt.UNIQUE_ID) AS externalId,
  'dmu_rmdm_instances' AS space,
  opt.LABLE AS name,
  CONCAT('Optimization-type operation: ', opt.LABLE) AS description,
  CONCAT(
    array(opt.LABLE_2),
    array(opt.APM_OP_CD),
    array(opt.APM_SUBOP_CD)
  ) AS aliases,
  CONCAT(
    array(CONCAT('Permission to modify #: ', CAST(opt.SN_APM AS STRING)))
  ) AS tags,
  CONCAT('BSEE-Operation-',opt.APM_SUBOP_CD) AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  node_reference('dmu_rmdm_instances', CONCAT('MORD_OPT-',CAST(opt.SN_APM AS STRING))) AS maintenanceOrder,
  node_reference('dmu_rmdm_instances', CONCAT('WLL-', CAST(opt.API_WELL_NUMBER AS STRING))) AS mainAsset,
  ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLB-', CAST(opt.API_WELLBORE_NUMBER AS STRING)))) AS assets,
  opt.APM_SUBOP_CD AS operationCode,
  opt.APM_OP_DESC AS operationDesc,
  'CLOSED' AS status,
  opt.Sequence AS sequence,
  opt.APM_OP AS phase,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(opt.WORK_COMMENCES_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE opt.WORK_COMMENCES_DATE
  END,
  'yyyy-MM-dd'
  ) AS startTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(opt.WORK_COMMENCES_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE opt.WORK_COMMENCES_DATE
  END,
  'yyyy-MM-dd'
  ) AS scheduledStartTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(opt.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE opt.WORK_ENDS_DATE
  END,
  'yyyy-MM-dd'
  ) AS endTime,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(opt.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE opt.WORK_ENDS_DATE
  END,
  'yyyy-MM-dd'
  ) AS scheduledEndTime,
  TO_DATE(
  CASE 
    WHEN LOWER(TRIM(opt.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
    ELSE opt.WORK_ENDS_DATE
  END,
  'yyyy-MM-dd'
  ) AS maintenanceOrderDueDate,
  'Shut-in' AS systemCondition,
  TRUE AS finalConfirmed,
  CAST(opt.EST_OPERATION_DAYS * 24 AS DOUBLE) AS personHours,
  opt.APM_SUBOP_DESC AS maintActivityTypeDesc
FROM `bsee`.`extracted_optimizations` opt