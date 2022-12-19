use TeaShop
go


-- a. Write queries on Ta such that their execution plans contain the following operators:

-- clustered index scan - entire table
select * from Clients

-- clustered index seek - return a specific subset of rows from a clustered index
select * 
from Clients
where cid > 3

-- nonclustered index scan - scan the entire nonclustered index
select fidelityCardNo
from Clients
order by fidelityCardNo

-- nonclustered index seek - return a specific subset of rows from a nonclustered index
select fidelityCardNo
from Clients
where fidelityCardNo between 1000 and 5000

-- key lookup - nonclustered index seek + key lookup - the data is found in a nonclustered index, but additional data is needed
select name, fidelityCardNo
from Clients
where fidelityCardNo = 1234


-- b. Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
-- Create a nonclustered index that can speed up the query. Examine the execution plan again.

select * 
from Employees
where points = 15

create nonclustered index Employees_points_index on Employees(points)
drop index Employees_points_index on Employees

-- c. Create a view that joins at least 2 tables. Check whether existing indexes are helpful; 
-- if not, reassess existing indexes / examine the cardinality of the tables.

create or alter view myView 
as 
	select C.fidelityCardNo, E.points, O.oid
	from Orders O
	inner join Clients C on C.cid = O.cid
	inner join Employees E on E.eid = O.oid
	where E.points > 5 and C.fidelityCardNo < 7000
go

select * from myView

create nonclustered index Orders_index on Orders(cid, eid)
drop index Orders_index on Orders

