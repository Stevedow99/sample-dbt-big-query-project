{%- macro get_column_descriptions_update() -%}
  {#- Set the model name based on the context -#}
  {%- set model_name = this.name -%}

  {#- Log the model name for debugging purposes -#}
  {{ log('Model name: ' ~ model_name, info=True) }}

  {%- if execute and flags.WHICH == 'run' -%}

    {#- Retrieve the model details from the graph nodes using the model name -#}
    {%- set model = graph.nodes.values() | selectattr("alias", "equalto", model_name) | first -%}

        {#- Check if the model exists -#}
        {%- if model -%}
            {#- Set variables for table name and description -#}
            {%- set table_name = model['name'] -%}
            {%- set table_description = model['description'] -%}

            {#- Log the table details for debugging purposes -#}
            {{ log("Table Name: " ~ table_name ~ ", Table Description: " ~ table_description, info=True) }}

            {#- Output the table name and description -#}
            {{ table_name }}
            {{ table_description }}

            {#- Log additional model details -#}
            {{ log('Project: ' ~ model.database, info=True) }}
            {{ log('Dataset/Schema: ' ~ model.schema, info=True) }}

            {#- Define SQL for updating the table description -#}
            {% set alter_sql %}
            ALTER TABLE `{{ model.database }}.{{ model.schema }}.{{ table_name }}`
            SET OPTIONS (
                description = '{{ table_description | replace("'", "\\'") }}'
            );
            {% endset %}
            
            {#- Log the execution of the SQL query -#}
            {{ log('Executing SQL: ' ~ alter_sql, info=True) }}

            {#- Execute the query to update the table description -#}
            {% set table_results = run_query(alter_sql) %}

            {#- Iterate over each column in the model for description updates -#}
            {%- for column in model['columns'].items() -%}
            {%- set column_name = column[1]['name'] -%}
            {%- set column_description = column[1]['description'] -%}

            {#- Log the column details for debugging purposes -#}
            {{ log("Column Name: " ~ column_name ~ ", Description: " ~ column_description, info=True) }}

            {#- Output the column name and description -#}
            {{ column_name }}
            {{ column_description }}

            {#- Define SQL for updating the column description -#}
            {% set alter_column_sql %}
                ALTER TABLE `{{ model.database }}.{{ model.schema }}.{{ table_name }}`
                ALTER COLUMN {{ column_name }}
                SET OPTIONS (
                description = '{{ column_description | replace("'", "\\'") }}'
                );
            {% endset %}
            
            {#- Log the execution of the SQL query -#}
            {{ log('Executing SQL: ' ~ alter_column_sql, info=True) }}

            {#- Execute the query to update the column description -#}
            {% set column_results = run_query(alter_column_sql) %}
            {%- endfor %}
        {%- else -%}
            {#- Log an error if the model is not found -#}
            {{ log("Model not found", info=True) }}
        {%- endif -%}
    {%- endif -%}
{% endmacro %}