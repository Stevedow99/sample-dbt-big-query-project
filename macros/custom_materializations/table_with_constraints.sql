{%- materialization table_with_constraints, adapter='bigquery' -%}

  --prepare database for new model
  {%- set identifier = this.identifier -%}

  {%- set old_relation = adapter.get_relation(database=database, schema=schema, identifier=identifier) -%}

  -- drop original table if it exists
  {% if old_relation is not none %}
    {% do adapter.drop_relation(old_relation) %}
  {% endif %}
  
  --set the new target table  
  {%- set target_relation = api.Relation.create(
        identifier=identifier, schema=schema, database=database,
        type='table') -%}

  --optional configs
  {%- set raw_partition_by = config.get('partition_by', none) -%}
  {%- set raw_cluster_by = config.get('cluster_by', none) -%}
  {%- set sql_header = config.get('sql_header', none) -%}

  {%- set partition_config = adapter.parse_partition_by(raw_partition_by) -%}

  {{ sql_header if sql_header is not none }}
  {%- set user_provided_columns = model['columns'] -%}
  
  {% call statement('main') -%}
    create or replace table {{ target_relation }}
    {% if config.get('has_constraints', False) %}
      (
      {% for i in user_provided_columns %}
        {% set col = user_provided_columns[i] %}
        {{ col['name'] }} {{ col['data_type'] }} {{ col['meta']['constraint'] or "" }} {{ "," if not loop.last }}
      {% endfor %}
    )
    {% endif %}
    {{ partition_by(partition_config) }}
    {{ cluster_by(raw_cluster_by) }}
    {{ bigquery_table_options(config, model, temporary) }}
    as (
      {{ sql }}
    );
  {%- endcall %}

  {{ return({'relations': [target_relation]}) }}

{%- endmaterialization -%}