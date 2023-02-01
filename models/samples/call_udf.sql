SELECT
    val,
   `{{this.database}}.{{this.schema}}`.AddEightAndDivide(val, 2) as udf_callback_eight
FROM
  (Select * from UNNEST([2,3,5,8,12]) as val)