use sakila;
select first_name, last_name from actor;

alter table actor
add column actor_name varchar(50);
update actor
set actor_name= concat(first_name, " ", last_name);
select  actor_name from actor;

select* from actor where first_name="Joe";

select* from actor where last_name like "%g%e%n%";

select* from actor 
where last_name like "%li%" 
order by last_name;

select* from actor 
where last_name like "%li%" 
order by first_name;


select country_id, country from  country
where country in ("Afghanistan", "Bangladesh" , "China");

alter table actor
add column description blob;

alter table actor
drop description; 

-- important to use having with count 

select last_name, count(actor_id)  from actor
group by last_name
having count(actor_id) not in (1);

update actor 
set actor_name= "HARPO WILLIAMS" 
where actor_name= "GROUCHO WILLIAMS";

update actor 
set first_name= "HARPO" 
where first_name= "GROUCHO ";

update actor 
set first_name= "GROUCHO" 
where first_name= "HARPO";


select * from staff 
inner join address
on staff.address_id=address.address_id;



select staff_id, sum(amount) 
from payment as totals
group by staff_id
; 

-- merging a dereived table 
select * from staff
inner join 
(
select staff_id, sum(amount) 
from payment as totals
group by staff_id 

) as joint_tables

on staff.staff_id=joint_tables.staff_id; 



select * from film 
inner join 
(
select film_id, count(film_id) from film_actor
group by film_id
) as film_actor_count
on film.film_id=film_actor_count.film_id;

select count(film_id) from inventory where film_id in (
select film_id from film where title="Hunchback Impossible" );


-- 6e How to delete duplicate columns ?????

select * from (select  customer_id, first_name, last_name from customer  ) as t1 
inner join  
(select customer_id, sum(amount) from payment 
group by customer_id
) as t2  
on t2.customer_id = t1.customer_id 

order by last_name;


select title from film 
where (title like "K%" or "Q%")
and ( language_id in (

select  language_id from language where name="English"));



select actor_name from actor where actor_id in (
select actor_id  from film_actor where film_id in (
select film_id from film where title="Alone Trip"));


select film_id  from film_category where category_id in (
select category_id from category where name="Family");


