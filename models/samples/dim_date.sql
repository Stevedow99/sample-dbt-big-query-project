{{
	dbt_utils.date_spine(
	datepart="day",
	start_date="PARSE_DATE('%m/%d/%Y', '01/01/1996')",
	end_date="PARSE_DATE('%m/%d/%Y', '01/01/1998')"
	)
}}