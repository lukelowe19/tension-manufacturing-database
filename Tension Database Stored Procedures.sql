# Procedures
# Q: How many customers are in state vs. out of state? (in/out of Colorado)
	# Good to know how many orders travel out of state vs. in state
DELIMITER //
drop procedure if exists inOutState//
create procedure inOutState()
begin
	declare inState int;
    declare outState int;
    
	select count(*)
    into inState
    from customer
    where state = 'CO';
    
    select count(*)
    into outState
    from customer
    where state != 'CO';
    
    select inState, outState;
    
end//

call inOutState()//

# Update qty_on_hand for wood products when we finish more 
drop procedure if exists updateWood//
create procedure updateWood(
	in product_name char(25), 	# Which product is being updated
	in amount int 				# Amount to increase stock by
)
begin
	declare product int;

	select product_ID
    into product
    from product
    where `name` = product_name;
    
    UPDATE product
	SET qty_on_hand = qty_on_hand + amount
    where product_ID = product
    limit 1;

end//

call updateWood('Skin Trimmer', 6)//

select *
from product
where `name` = 'Skin Trimmer'
limit 1;