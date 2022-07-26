
with orders as (
    
    select * from {{ ref('stg_tpch_orders') }}

),

line_item as (

    select * from {{ ref('stg_tpch_line_items') }}

),

joined_line_item as (

select 

    line_item.order_item_key,
    orders.order_key,
    orders.customer_key,
    line_item.part_key,
    line_item.supplier_key,
    orders.order_date,
    orders.status_code as order_status_code,
    
    
    line_item.return_flag,
    
    line_item.line_number,
    line_item.status_code as order_item_status_code,
    line_item.ship_date,
    line_item.commit_date,
    line_item.receipt_date,
    line_item.ship_mode,
    line_item.extended_price,
    line_item.quantity,
    
    -- extended_price is actually the line item total,
    -- so we back out the extended price per item
    (line_item.extended_price/nullif(line_item.quantity, 0)) as base_price,
    line_item.discount_percentage,
    ((line_item.extended_price/nullif(line_item.quantity, 0)) * (1 - line_item.discount_percentage)) as discounted_price,

    line_item.extended_price as gross_item_sales_amount,
    (line_item.extended_price * (1 - line_item.discount_percentage)) as discounted_item_sales_amount,
    -- We model discounts as negative amounts
    (-1 * line_item.extended_price * line_item.discount_percentage) as item_discount_amount,
    line_item.tax_rate,
    (((line_item.extended_price + (-1 * line_item.extended_price * line_item.discount_percentage)) * line_item.tax_rate)) as item_tax_amount,
    (
        line_item.extended_price + 
        (-1 * line_item.extended_price * line_item.discount_percentage) + 
        (((line_item.extended_price + (-1 * line_item.extended_price * line_item.discount_percentage)) * line_item.tax_rate))
    ) as net_item_sales_amount

from
    orders
inner join line_item
        on orders.order_key = line_item.order_key
order by
    orders.order_date)

select
    order_item_key,
    order_key,
    customer_key,
    part_key,
    supplier_key,
    order_date,
    order_status_code,
    return_flag,
    line_number,
    order_item_status_code,
    ship_date,
    commit_date,
    receipt_date,
    ship_mode,
    extended_price,
    quantity,
    {{money('base_price')}} as base_price,
    discount_percentage,
    {{money('discounted_price')}} as discounted_price,
    {{money('gross_item_sales_amount')}} as gross_item_sales_amount,
    {{money('discounted_item_sales_amount')}} as discounted_item_sales_amount,
    {{money('item_discount_amount')}} as item_discount_amount,
    tax_rate,
    {{money('item_tax_amount')}} as item_tax_amount,
    {{money('net_item_sales_amount')}} as net_item_sales_amount
from joined_line_item