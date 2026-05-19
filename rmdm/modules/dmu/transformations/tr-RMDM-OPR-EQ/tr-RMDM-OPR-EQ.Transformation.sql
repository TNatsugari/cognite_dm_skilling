WITH sources AS (
  SELECT
    opr.space,
    opr.externalId,
    COALESCE(er.TARGET, or.TARGET, sr.TARGET) AS raw_target
  FROM cdf_data_models('dmu_rmdm_model', 'RMDM', '1.0.0', 'Operation') opr
  LEFT JOIN `bsee`.`extracted_restorations` er
    ON opr.externalId = CONCAT('OPR_REST-', er.UNIQUE_ID)
  LEFT JOIN `bsee`.`extracted_optimizations` or
    ON opr.externalId = CONCAT('OPR_OPT-', or.UNIQUE_ID)
  LEFT JOIN `bsee`.`synthetic_tank_restorations` sr
    ON opr.externalId = CONCAT('OPR_REST-', sr.UNIQUE_ID)
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