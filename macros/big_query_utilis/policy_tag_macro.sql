{% macro policy_tag_macro() -%}
    {% if 'id' model.raw_code %}

    - name: id
      policy_tags:
        - 'projects/sales-demo-project-314714/locations/us/taxonomies/2703891762432668776/policyTags/615563296199740135'

    {% else %}
        ''


{%- endmacro %}
