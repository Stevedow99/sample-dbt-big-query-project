{{
  config(
    materialized = "table",
    persist_docs={"relation": true, "columns": true},
    tags='projects/sales-demo-project-314714/locations/us/taxonomies/2703891762432668776/policyTags/615563296199740135'

  )
}}

select 
  1 as id, 
  'blue' as color, 
  cast('2019-01-01' as date) as date_day,
  'column' as new_col