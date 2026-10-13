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

# Update qty_on_hand for wood products when we finish more
# Rejects non-positive amounts and names that aren't wood products (soft products can't be "finished")
drop procedure if exists updateWood//
create procedure updateWood(
	in p_product_name varchar(25), 	# Which wood product is being updated
	in p_amount int 				# Amount to increase stock by (must be > 0)
)
begin
	if p_amount is null or p_amount <= 0 then
		signal sqlstate '45000' set message_text = 'updateWood: amount must be a positive number';
	end if;

	update product
	set qty_on_hand = qty_on_hand + p_amount
	where `name` = p_product_name
	and product_ID in (select product_ID from wood_product);

	if row_count() = 0 then
		signal sqlstate '45000' set message_text = 'updateWood: no wood product with that name';
	end if;
end//

DELIMITER ;

# Demo calls (uncomment to try them; updateWood changes data, so it is not run automatically)
# call inOutState();
# call updateWood('Whetstone', 6);
# select product_ID, `name`, qty_on_hand from product where `name` = 'Whetstone';
