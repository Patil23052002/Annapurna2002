select * from  olist_ecomm.olist_orders_dataset;
select * from olist_ecomm. olist_order_payments_dataset;
select kpi1.day_end,
concat(round(kpi1.total_payment/(select sum(payment_value) from olist_order_payments_dataset)*100,2)
,'%') as percentage_payments_values
from 
(select ord.day_end ,sum(pmt.payment_value) as total_payment
from olist_order_payments_dataset as pmt 
join 
(select distinct order_id,
case
when weekday(order_purchase_timestamp) in (5,6) then "weekend"
else "weekday"
end as Day_end 
from  olist_orders_dataset ) as ord 
on ord.order_id =pmt.order_id 
group by ord.day_end) as kpi1 ;