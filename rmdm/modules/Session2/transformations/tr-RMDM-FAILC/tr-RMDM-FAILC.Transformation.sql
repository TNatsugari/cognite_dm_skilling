SELECT 

  "dmu_rmdm_instances" AS space,
  code AS externalId,
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
  SUBSTRING_INDEX(code, '-', -1) AS code,
  category as category

FROM `RMDM_RefData`.`RMDMFAILC-FailureCause`;