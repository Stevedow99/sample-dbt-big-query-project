{% macro money(col) -%}
ROUND(CAST({{col}} AS  NUMERIC),2)
{%- endmacro %}


