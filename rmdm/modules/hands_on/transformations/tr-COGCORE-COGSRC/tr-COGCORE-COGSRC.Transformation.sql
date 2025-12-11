SELECT 

"dmu_rmdm_instances" AS space
,concat('COGSRC-',code) AS externalId
,name as name
,description as description
,case
  when aliases = "" then null
  else split(aliases, ",")
end as aliases
,case
  when tags = "" then null
  else split(tags, ",")
end as tags
,version as version
,manufacturer as manufacturer

from `CogCore_RefData`.`COGSRC-Sources`