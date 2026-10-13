# Single-Table Queries
# Q: How many gyms order through us?
	# Good to know to see how much of our client base is gyms
select count(customer_ID)
from customer
where `type` = 'G';
# Q: How many batches of wood did each machine process in December 2025?
	# Good to show the amount of wood that was processed in one month for future wood restock or for machine efficiency data
select machine.machine_ID, count(wood_machine.wood_ID) as batches_processed
from machine
left join wood_machine
on machine.machine_ID = wood_machine.machine_ID
and wood_machine.`date` >= '2025-12-01'
and wood_machine.`date` < '2026-01-01'
group by machine.machine_ID
order by machine.machine_ID;
# Q: How many employees operate the special equipment? (saw/machine/finish)
	# Good to know if we have enough employees for the equipment
select count(employee_ID)
from employee
where specialty in('M', 'S', 'F');
# Q: Which machines are currently down?
	# Good to know if there is a machine that needs to be fixed
	# (condition is logged per run, so a machine is down only if its most recent log entry says 'Down')
select machine_ID, `date` as last_logged_date
from (
	select machine_ID, `date`, machine_condition,
		row_number() over (partition by machine_ID order by `date` desc, start_time desc) as rn
	from wood_machine
) as latest
where rn = 1 and machine_condition = 'Down';
# Q: What is the average buying cost of soft products?
	# Good to know what we are paying on average to stock soft products
select avg(buying_cost)
from soft_product;

# Multi-Table Queries
# Q: How many TB2's are ordered by out of state customers? (in/out of Colorado)
	# Good to know how many TB2s  travel out of state
select sum(amount_sold)
from product_order
where order_ID in
		(select order_ID
        from `order`
        where customer_ID in(
			select customer_ID
            from customer
            where state != "CO"
        ))
        and
	product_ID in (
		select product_ID 
        from product
        where name like "%TB2%");

# Q: Which soft products are sold out and wood products are below 20 stock on hand?
	# Good to know if a product needs to be reordered or produced
select `name`
from product
where product_ID in(
	select product_ID 
    from soft_product
) and qty_on_hand = 0 
or
product_ID in(
	select product_ID
	from wood_product
) and qty_on_hand <20;

# Q: Which employee has machined the most product?
	# Good to know how efficient the employees are
select employee.first_name, employee.last_name, sum(EOD_amount)
from employee
inner join machine
on employee.employee_ID = machine.employee_ID
inner join wood_machine
on machine.machine_ID = wood_machine.machine_ID
group by employee.employee_ID
order by sum(EOD_amount) desc 
limit 1;

# Q: For each wood product, what is the difference between how many there are in stock and how many are prepacked
	# Good to know for if we need to prepack some more wood products
select product.qty_on_hand, prepack.prepack_amount,product.`name`, (prepack.prepack_amount -product.qty_on_hand) as "Difference between prepack and in Stock"
from product
inner join prepack
on product.product_ID = prepack.product_ID
where product.product_ID in
	(select product_ID
	from prepack);
    
# Q: Which employees have ordered anything and what have they ordered?
	# Good to see which employees use our own products and just how many are buying product
select employee.first_name,employee.last_name,product.`name`
from employee
inner join employee_order
on employee.employee_ID = employee_order.employee_ID
inner join `order`
on `order`.order_ID = employee_order.order_ID
left join product_order
on product_order.order_ID = `order`.order_ID
left join product
on product_order.product_ID = product.product_ID
where employee.employee_ID in(
	select employee_ID
    from employee_order);
    
# Q: What is the most popular product?
	# Good to know what is being bought the most
select product.name,sum(product_order.amount_sold) 
from product_order
inner join product
on product_order.product_ID=product.product_ID
group by product_order.product_ID
order by sum(product_order.amount_sold) desc
limit 1;
