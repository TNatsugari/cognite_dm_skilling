SELECT DISTINCT
  CONCAT('MORD_REST-', rest.SN_APM) AS externalId,
  'dmu_rmdm_instances' AS space,
  rest.APM_OP AS name,
  rest.APM_OP AS description,
  CONCAT(
    array('Restoration'),
    array(rest.APM_OP_CD)
  ) AS aliases,
  CONCAT(
    array(CONCAT('Permission to modify #: ', CAST(rest.SN_APM AS STRING)))
  ) AS tags,
  CONCAT('BSEE-MaintenanceOrder-', rest.APM_OP_CD) AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  node_reference('dmu_rmdm_instances', CONCAT('WLL-', CAST(rest.API_WELL_NUMBER AS STRING))) AS mainAsset,
  ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLB-', CAST(rest.API_WELLBORE_NUMBER AS STRING)))) AS assets,
  -- node_reference('dmu_rmdm_instances', rest.PLATFORM_ID) AS mainAsset,
  -- ARRAY(node_reference('dmu_rmdm_instances', CONCAT('WLL-', CAST(rest.API_WELL_NUMBER AS STRING)))) AS assets,
  rest.APM_OP_CD AS type,
  rest.APM_OP AS typeDescription,
  'CLOSED' AS status,
  priority_synthetic AS priority,
  priorityDescription_synthetic AS priorityDescription,
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
  ) AS StartTime,
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
  TO_TIMESTAMP(
    CASE 
      WHEN LOWER(TRIM(rest.WORK_ENDS_DATE)) IN ('unknown', 'uknown') THEN NULL
      ELSE rest.WORK_ENDS_DATE
    END,
    'yyyy-MM-dd'
    -- 'dd/MM/yyyy'
  ) AS EndTime,
  rest.APM_OP_DESC AS longText,
  CAST(rest.EST_OPERATION_DAYS * 24 AS DOUBLE) AS activeMaintenanceTime,
  rest.APM_SUBOP_CD AS maintenanceActivityType,
  rest.APM_SUBOP_DESC AS activityDescription
FROM `bsee`.`extracted_restorations` rest
  -- FROM `bsee`.`synthetic_tank_restorations` rest
WHERE NOT (
  LOWER(TRIM(COALESCE(rest.APM_SUBOP_DESC, ''))) = 'bop repairs/maintenance'
  AND EXISTS (
    SELECT 1
    FROM `bsee`.`extracted_restorations` r2
    -- FROM `bsee`.`synthetic_tank_restorations` r2
    WHERE r2.SN_APM = rest.SN_APM
      AND LOWER(TRIM(COALESCE(r2.APM_SUBOP_DESC, ''))) <> 'bop repairs/maintenance'
  )
)
-- and rest.`SN_APM` == '77193'