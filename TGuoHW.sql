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



select title from film where film_id in (

select film_id  from  inventory 
where inventory_id in (
select inventory_id from  rental) 
group by film_id
order by count(inventory_id) desc
);


select t2.store_id, t1.a
from  (
select staff_id, sum(amount) as a from payment group by staff_id ) t1
inner join 
(select store_id from store) t2
on t2.store_id=t1.staff_id;


-- 7h and 8e a lot of joins and subqueries , also creating a view 
create view top_five_genres as 
(
select t8.name, t7.revenue
from 
(
select t6. category_id, sum(t5.c) as revenue
from (
select t4.film_id, sum(t3.b) as c 
from 
(
select t2.inventory_Id, sum(t.a) as b
from 
(
select rental_id, sum(amount) as a from payment group by rental_id order by sum(amount) desc) t
inner join
(select inventory_id, rental_id from rental) t2
on t2. rental_id = t.rental_id
group by t2.inventory_id order by sum(t.a) desc

)  as t3 

inner join 
(select film_id, inventory_id from inventory) t4
on t3.inventory_id=t4.inventory_id
group by t4.film_id order by sum(t3.b)  desc
) as t5 
inner join 
(select film_id, category_id from film_category) as t6
on t6.film_id=t5.film_id
group by category_id order by sum(t5.c) desc
) as t7 
inner join 
(select name, category_id from category) as t8
on t8.category_id=t7.category_id
limit 0,5)
;


select * from  top_five_genres; 
drop view top_five_genres;



