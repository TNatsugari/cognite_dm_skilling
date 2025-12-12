SELECT 
  "dmu_rmdm_instances" AS space,
  concat('FILE-', key) AS externalId,
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
  system AS system,
  workflowStatus AS workflowStatus,
  CAST(revision AS STRING) AS revision,
  true AS latest,
  true AS isUploaded,
  facility AS facility,
  originatingContractor AS originatingContractor,
  className AS className,
  'application/pdf' AS mimeType,
  classId AS classId,
  revisionRemark AS revisionRemark,
  area AS area,
  CONCAT('BSEE-Files-',name) AS sourceContext,
  node_reference("dmu_rmdm_instances", CONCAT('COGFLCA-', name)) AS category,
  CONCAT(
    array(node_reference("dmu_rmdm_instances", assets))
  ) AS assets,
  TO_TIMESTAMP(
  CASE 
    WHEN LOWER(TRIM(uploadedTime)) IN ('unknown', 'uknown') THEN NULL
    ELSE uploadedTime
  END,
  'dd/MM/yyyy'
  ) AS uploadedTime
FROM `bsee`.`extracted_files_headers`