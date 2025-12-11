SELECT
  CONCAT('EQ_TBL-', CSNG_TYPE, '-', CAST(SN_WAR AS STRING), '-',CAST(tbl.API_WELLBORE_NUMBER AS STRING)) AS externalId,
  CONCAT('SN_', CAST(tbl.key AS STRING)) AS serialNumber,
  CONCAT(CSNG_TYPE,'-SN',CAST(tbl.key AS STRING)) AS name,
  'Pseudo Manufacturer Co.' AS manufacturer,
  eqfn.description AS description,
  node_reference('dmu_rmdm_instances', CONCAT('WLB-', CAST(tbl.API_WELLBORE_NUMBER AS STRING))) AS asset,
  'dmu_rmdm_instances' AS space,
  CONCAT('BSEE-Equipment-',CSNG_TYPE) AS sourceContext,
  node_reference('dmu_rmdm_instances', 'COGSRC-BSEE') AS source,
  TO_DATE(
    CASE 
      WHEN LOWER(TRIM(wlb.WELL_SPUD_DATE)) IN ('unknown', 'uknown') THEN NULL
      ELSE wlb.WELL_SPUD_DATE
    END,
    'M/d/yyyy'
  ) AS startDateCurrentService,
  CONCAT(
    array('Tubular'),
    array('Pipe')
  ) AS aliases,
  CONCAT(
    array(CONCAT('Nominal size [in.]: ', CAST(CASING_SIZE AS STRING))),
    array(CONCAT('Cement volume [bbl]: ', CAST(CSNG_CEMENT_VOL AS STRING))),
    array(CONCAT('Pipe grade: ', CASING_GRADE)),
    array(CONCAT('Setting depth [ft]: ', CAST(CSNG_SETTING_BOTM_MD AS STRING)))
  ) AS tags,
  node_reference('dmu_rmdm_instances', CONCAT('EQTY-', CSNG_TYPE_CD)) AS equipmentType,
  node_reference('dmu_rmdm_instances', 'EQCL-TUBULAR') AS equipmentClass

FROM `bsee`.`casings_tb` tbl
LEFT JOIN `bsee`.`wellbore_headers` AS wlb
  ON CAST(tbl.API_WELLBORE_NUMBER AS STRING) = CAST(wlb.API_WELLBORE_NUMBER AS STRING)
LEFT JOIN `RMDM_RefData`.`RMDMEQFN-EquipmentFunction` AS eqfn
  ON tbl.CSNG_TYPE_CD = eqfn.code
WHERE CSNG_TYPE != 'Other'