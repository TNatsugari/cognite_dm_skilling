SELECT 

  "dmu_rmdm_instances" AS space,
  concat('EQTY-', code) AS externalId,
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
  standardReference AS standardReference,
  class AS equipmentClass,
  node_reference('dmu_rmdm_instances', CONCAT('EQCL-', equipmentClass)) AS class

FROM `RMDM_RefData`.`RMDMEQTY-EquipmentType`;








