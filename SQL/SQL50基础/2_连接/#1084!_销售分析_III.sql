-- 解答
select s.product_id, p.product_name
from sales s left join product p
on s.product_id = p.product_id
where s.sale_date between '2019-01-01' and '2019-03-31'
and s.product_id not in (select product_id from sales where sale_date > '2019-03-31')
and s.product_id not in (select product_id from sales where sale_date < '2019-01-01');

-- 答案
-- 1
select sales.product_id as product_id, product.product_name as product_name
from sales left join product on sales.product_id = product.product_id
group by product_id
having count(sale_date between '2019-01-01' and '2019-03-31' or null) = count(*)
-- 2
# Write your MySQL query statement below
select Product.product_id,Product.product_name
from Product
join Sales
on Product.product_id = Sales.product_id 
group by Sales.product_id
having Min(Sales.sale_date) >= '2019-01-01' and Max(Sales.sale_date) <= '2019-03-31';