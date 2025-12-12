SELECT
  opr.externalId,
  opr.space,
  collect_set(node_reference("dmu_rmdm_instances", prd.uniqueId)) AS timeSeries
FROM
  cdf_data_models(
    "dmu_rmdm_model",
    "RMDM",
    "1.0.0",
    "Operation"
  ) opr
LEFT JOIN `bsee`.`production_data_ts_headers` prd
  ON opr.mainAsset.externalId = CONCAT('WLL-', prd.wellAPI)
WHERE
  opr.externalId LIKE 'OPR_OPT-%'
GROUP BY
  opr.externalId, opr.space
