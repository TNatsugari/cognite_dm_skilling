WITH sources AS (
  SELECT
    fail.space,
    fail.externalId,
    COALESCE(ef.TARGET, stf.TARGET, enpt.TARGET) AS raw_target
  FROM cdf_data_models('dmu_rmdm_model', 'RMDM', '1.0.0', 'FailureNotification') fail
  LEFT JOIN `bsee`.`extracted_failures` ef
    ON fail.externalId = CONCAT('FAILNOT-', ef.UNIQUE_ID)
  LEFT JOIN `bsee`.`synthetic_tank_failures` stf
    ON fail.externalId = CONCAT('FAILNOT-', stf.UNIQUE_ID)
  LEFT JOIN `bsee`.`extracted_npts_with_target` enpt
    ON fail.externalId = CONCAT('FAILNOT_NPT-', enpt.SN_NPT)
),
mapped AS (
  SELECT
    space,
    externalId,
    CASE
      WHEN raw_target IS NULL OR LOWER(TRIM(raw_target)) = 'unknown' THEN NULL
      WHEN INSTR(LOWER(raw_target), 'tubing') > 0
        OR INSTR(LOWER(raw_target), 'casing') > 0
        OR INSTR(LOWER(raw_target), 'liner') > 0
        THEN CONCAT('EQ_TBL-', raw_target)
      WHEN INSTR(LOWER(raw_target), 'sn_') > 0
        THEN CONCAT('EQ_BOP-', raw_target)
      WHEN INSTR(LOWER(raw_target), 'sn-') > 0
        THEN CONCAT('EQ_BOP-', raw_target)
      ELSE raw_target
    END AS mapped_target
  FROM sources
)
SELECT
  space,
  externalId,
  ARRAY(node_reference('dmu_rmdm_instances', mapped_target)) AS equipment
FROM mapped
WHERE mapped_target IS NOT NULL   -- <-- prevents null overwrites