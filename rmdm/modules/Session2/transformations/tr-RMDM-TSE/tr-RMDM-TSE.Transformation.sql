SELECT 
	uniqueId AS externalId,
	'dmu_rmdm_instances' AS space,
	name AS name,
	description AS description,
    aliases AS aliases,
    tags AS tags, 
	sourceUnit AS sourceUnit,
	ARRAY(node_reference('dmu_rmdm_instances', meterId)) AS equipment,
    CONCAT(
      array(node_reference('dmu_rmdm_instances', platformId)),
      array(node_reference('dmu_rmdm_instances', sourceId)),
      array(node_reference('dmu_rmdm_instances', wellboreId))
    ) AS assets,
    false AS isStep,
	'numeric' AS type,
	sourceContext AS sourceContext,
    node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
	node_reference('cdf_cdm_units', cogUoM) AS unit
FROM `bsee`.`production_data_ts_headers`
	