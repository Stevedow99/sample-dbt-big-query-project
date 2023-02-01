{{
    config(
        materialized='raw_sql'
    )
}}


CREATE OR REPLACE FUNCTION `{{this.database}}.{{this.schema}}`.AddEightAndDivide(x INT64, y INT64)
RETURNS FLOAT64
AS (
  (x + 8) / y
);