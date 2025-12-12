SELECT DISTINCT
  CONCAT('MORD_OPT-', opt.SN_APM) AS externalId,
  'dmu_rmdm_instances' AS space,
  opt.APM_OP AS name,
  opt.APM_OP AS description,
  CONCAT(
    array('Optimization'),
    array(opt.APM_OP_CD)
  ) AS aliases,
  CONCAT(
    array(CONCAT('Permission to modify #: ', CAST(opt.SN_APM AS STRING)))
  ) AS tags,
  CONCAT('BSEE-MaintenanceOrder-', opt.APM_OP_CD) AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  node_reference('dmu_rmdm_instances', CONCAT('WLL-', CAST(opt.API_WELL_NUMBER AS STRING))) AS mainAsset,
  ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLB-', CAST(opt.API_WELLBORE_NUMBER AS STRING)))) AS assets,
  opt.APM_OP_CD AS type,
  opt.APM_OP AS typeDescription,
  'CLOSED' AS status,
  priority_synthetic AS priority,
  priorityDescription_synthetic AS priorityDescription,
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
  ) AS StartTime,
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
  TO_TIMESTAMP(
    CASE 
      WHEN LOWER(TRIM(opt.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
      ELSE opt.WORK_ENDS_DATE
    END,
    'yyyy-MM-dd'
  ) AS EndTime,
  opt.APM_OP_DESC AS longText,
  CAST(opt.EST_OPERATION_DAYS * 24 AS DOUBLE) AS activeMaintenanceTime,
  opt.APM_SUBOP_CD AS maintenanceActivityType,
  opt.APM_SUBOP_DESC AS activityDescription
FROM `bsee`.`extracted_optimizations` opt
WHERE NOT (
  LOWER(TRIM(COALESCE(opt.APM_SUBOP_DESC, ''))) = 'bop repairs/maintenance'
  AND EXISTS (
    SELECT 1
    FROM `bsee`.`extracted_optimizations` o2
    WHERE o2.SN_APM = opt.SN_APM
      AND LOWER(TRIM(COALESCE(o2.APM_SUBOP_DESC, ''))) <> 'bop repairs/maintenance'
  )
)
-- and opt.`SN_APM` == '77193'