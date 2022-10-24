use TeaShop
go

--insert data – for at least 4 tables; 
--at least one statement must violate referential integrity constraints;

insert into TeaTypes (
	name
) values
	('sleep'),
	('energy'),
	('focus'),
	('meditation')



insert into Allergens(
	name
) values
	('Almonds'),
	('Milk'),
	('Soy Lecithin'),
	('Coconut')




insert into Distributors(
	name,
	address
) values 
	('Native American Herbal Tea Company', '102 4th Ave SE, Aberdeen, SD 57401, USA'),
	('Hugo Tea Company', '1007 Swift Ave, Kansas City, MO 64116'),
	('Cooper Tea Company', '408 S Pierce Ave, Louisville, CO 80027'),
	('New Mexico Tea Company', '1131 Mountain Rd NW Ste 2, Albuquerque'),
	('Phoenix Tea Company', '4243 W 3rd St # 9651, Battlefield'),
	('International Company', 'Fatherland Street, Nashville, TN 37206')



insert into Teas(
	ttid,
	name,
	quantity,
	price,
	did
)values
	(1, 'Evergreen', 4, 2.6, 1),
	(2, 'Grand Tisane', 3, 9.3, 2),
	(3, 'Toasted Almond', 2, 7, 1),
	(3, 'Johannesburg', 5, 6.5, 6),
	(4, 'Mama Bahama', 10, 9.2, 6),
	(2, 'Mango Flip', 13, 5.5, 4),
	(4, 'Coconut Vanilla', 4, 3.2,5),
	(2, 'Organic Rooi Coconut', 5, 7, 3),
	(2, 'Sencha Tropic', 1, 12.5, 6),
	(3, 'Red Jamaica', 2, 10, 4)




insert into AllergTeas(
	tid,
	alid
) values
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 2),
	(5, 2),
	(6, 2),
	(7, 4),
	(8, 4),
	(10, 2),
	(5, 4),
	(6, 4),
	(4, 3),
	(9, 4),
	(10, 4)

--integrity constraint, no tea with tid=11
--insert into AllergTeas(
--	tid,
--	alid
--) values
--	(11,2)

insert into Clients(
	name, 
	email,
	address
)values
	('Sherlock Holmes', 'sherlock.holmes@email.com', '750 Bartoletti Burgs, Apt. 038, Great Britain'),
	('Nicole Willis', 'nicole.willis@email.com', 'Larsplein 6, 2 hoog, Utrecht, Netherlands'),
	('Jason Simon', 'jason.simon@email.com', '56 Schuster Plaza, Suite 269, New York, United States'),
	('Melissa Bell', 'melissa.bell@email.com', '708 Casandra Mission, Apt. 800, Great Britain'),
	('Anthony Glover', 'anthony.glover@email.com', '3341 Wolff Shoals, Suite 737, Great Britain'),
	('Donna Gonzalez', 'donna.gonzalez@email.com', '3574 Hayes Common, Kansas, United States'),
	('Barbara Brown', 'barbara.brown@email.com', '926 Kaden Mission, Apt. 921, Colorado, United States'),
	('Dorothy Lee', 'dorothy.lee@email.com', '55182 Runolfsson Mission, Apt. 843, Utah, United States')



insert into Employees(
	name,
	jobTitle
) values
	('Stephen Perry', 'manager'),
	('Bernard Scott', 'cashier'),
	('Chelsea Ashley', 'cleaning'),
	('Erika Hamilton', 'cashier'),
	('Thomas Hoffman', 'cashier'),
	('Richard Morton', 'cashier')



insert into EmployeeDetails(
	eid,
	email,
	salary,
	address,
	hiringDate
)values
	(1, 'stephen.perry@email.com', 7000, '5 Daron Alley, Suite 1, Ohio, United States', '2015-02-15'),
	(2, 'bernard.scott@email.com', 4500, 'Suite 022, Boyerside, Massachusetts, United States', '2012-03-08'),
	(3, 'chelsea.ashley@email.com', 2000, 'Wilderman Rest, Suite 010, California, United States', '2020-09-01'),
	(4, 'erika.hamilton@email.com', 3500, '2134 Abel Orchard, Apt.21, Wisconsin, United States', '2018-12-21'),
	(5, 'thomas.hoffman@email.com', 3400, '0248 Inlet, Suite 203, Montana, United States', '2019-12-16'),
	(6, 'richard.morton@email.com', 4000, '5299 Pagac Port, Texas, United States', '2014-05-27'),
	(7, 'ana.popescu@email.com', 3900 , null, '2022-10-24'),
	(8, 'maria.andronescu@email.co', 4000, 'Wilderman Rest, Apt.21, Wisconsin, United States','2022-10-23')



insert into Orders(
	eid,
	cid
) values
	(2, 1),
	(4, 2),
	(4, 2),
	(5, 6),
	(6, 3), 
	(2, 7),
	(6, 5)



insert into TeaOrders(
	tid,
	oid,
	price,
	quantity,
	orderingDate
) values
	(1, 1, 2.6, 1, '2022-02-14'),
	(3, 2, 18.6, 2, '2022-04-17'),
	(3, 3, 9.3, 1, '2022-04-17'),
	(6, 4, 11, 2, '2022-06-19'),
	(8, 4, 7, 1, '2022-06-19'),
	(10, 5, 20, 2, '2022-09-15'),
	(5, 6, 27.6, 3, '2019-01-01'),
	(2, 7, 9.3, 1,'2020-07-28'),
	(9, 6, 12.5,1, '2019-01-01')



--update data – for at least 3 tables;


--increases the salary with 100 of all employees that have a salary >=4500
update EmployeeDetails
set salary=salary + 100
where salary >= 4500
select * from EmployeeDetails


--decreases the price by 2 euros of all the teas that have at least 10 pieces and at most 15
select * from Teas
update Teas
set price=price-2
where quantity between 10 and 15
select * from Teas

--update TeaOrders
--set price=20
--where tid=10 and oid=5

--gives a 10% discount for all orders placed in june and september of 2022.
select * from TeaOrders
update TeaOrders
set  price=price-0.1*price
where  Month(orderingDate) in (6, 9)
select * from TeaOrders



--delete data – for at least 2 tables

--USE CASCADE ON DELETE/UPDATE???

--delete all the orders that are 


--delete the employees who don't have an adress or have an invalid email
--(doesn't end with '@email.com') 
select * from Employees

delete from EmployeeDetails
where email not like '%email.com' or address is null

select * from Employees, EmployeeDetails






