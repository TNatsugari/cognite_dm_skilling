SELECT 
  "dmu_rmdm_instances" AS space,
  concat('COGFLCA-', code) AS externalId,
  name AS name,
  description AS description,
  CASE
    WHEN aliases = "" THEN null
    ELSE split(aliases, ",")
  END AS aliases,
  CASE
    WHEN tags = "" THEN null
    ELSE split(tags, ",")
  END AS tags,
  code AS code,
  standard AS standard
FROM `CogCore_RefData`.`COGFLCA-FileCategory`;