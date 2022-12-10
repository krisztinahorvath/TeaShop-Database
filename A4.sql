use TeaShop
go

create or alter procedure addTeaTypes
@n int 
as
begin
	declare @i int=0
	while @i < @n 
	begin 
		insert into TeaTypes values (concat ('Type ', @i))
		set @i = @i + 1
	end
end
go

create or alter procedure deleteTeaTypes
as
begin
	delete from TeaTypes where name like 'Type %'
end
go


create or alter procedure addTeas
@n int 
as
begin
	declare @type int  = (select top 1 ttid from TeaTypes where name like 'Type %') 

	declare @i int=0

	while @i < @n 
	begin 
		--(ttid, name, quantity, price, did)
		insert into Teas values (@type, concat ('Tea ', @i), 10, 2.5, 1)
		set @i = @i + 1
	end
end
go

create or alter procedure deleteTeas
as
begin
	delete from Teas where name like 'Tea %'
end 
go


create or alter procedure addTeaOrders
@n int 
as
begin
	declare @tid int
	declare @oid int
	declare curs cursor
		for
		select t.tid, o.oid from (select tid from Teas where name like 'Tea %')t cross join Orders o
	open curs
	declare @i int=0
	while @i < @n
	begin
		fetch next from curs into @tid, @oid
		insert into TeaOrders(tid, oid, price, quantity, orderingDate) values (@tid, @oid, 10, -100 * @i, '2022-02-14')
		set @i=@i+1
	end 
	close curs 
	deallocate curs
end
go

create or alter procedure deleteTeaOrders
as
begin
	delete from TeaOrders where quantity < 0
end
go 


create or alter view viewTeaTypes
as
	select name
	from TeaTypes
go
--select * from viewTeaTypes

create or alter view viewTeas
as
	select Teas.tid, Teas.ttid
	from Teas inner join TeaTypes on Teas.ttid = TeaTypes.ttid
go

create or alter view viewTeaOrders
as
	select Teas.name, sum(TeaOrders.quantity) as nrOfTeas
	from TeaOrders inner join Teas on TeaOrders.tid = Teas.tid
	group by Teas.name, TeaOrders.quantity
go
--select * from viewTeaOrders

create or alter procedure selectView
(@name varchar(100))
as
begin
	declare @sql varchar(250) = 'select * from ' + @name
	exec(@sql)
end
go


insert into Tests(Name) values ('addTeaTypes'), ('deleteTeaTypes'), ('addTeas'), ('deleteTeas'), ('addTeaOrders'), ('deleteTeaOrders'), ('selectView')
insert into Tables(Name) values ('TeaTypes'), ('Teas'), ('TeaOrders')
insert into Views(name) values ('viewTeaTypes'), ('viewTeas'), ('viewTeaOrders')

select * from Tests
select * from Tables
select * from Views

insert into TestViews(TestID, ViewID) values (7, 1), (7, 2), (7, 3)

-- 6 linii, delete din TeaOrders, din Teas, TeaTypes
-- inserez in TeaTypes, Teas, TeaOrders
insert into TestTables(TestID, TableID, NoOfRows, Position) 
values 
	(6, 3, 70, 1), --deleteTeaOrders
	(4, 2, 30, 2),
	(2, 1, 100, 3),
	(1, 1, 50, 1),  --insertTeaTypes
	(3, 2, 150, 2),
	(5, 3, 200, 3)

select * from TestTables
select * from TestViews

--fiecare linie in TestRun are 3 linii in TestRunTables
--TestRun facem deleturile
--TestRunTables - pt inserturi
--procedura de main care face asta
--exec de mana - 9, 
-- 5 teste in main ->

create or alter procedure mainTest
@testID int
as
begin
	print 'running test with id ' + convert(varchar, @testID)

	insert into TestRuns values ((select Name from Tests where TestID=@testID), getdate(), getdate())
	declare @testRunID int
	set @testRunID = (select max(TestRunID) from TestRuns)

	declare @noOfRows int
	declare @tableID int
	declare @tableName varchar(100)
	declare @startAt datetime
	declare @endAt datetime
	declare @viewID int
	declare @viewName varchar(100)

	-- delete tests

	declare testDeleteCursor cursor
	for
	select TableID, NoOfRows
	from TestTables
	where @testID = TestID
	order by Position desc

	open testDeleteCursor
	
	fetch next
	from testDeleteCursor
	into @tableID, @noOfRows

	while @@FETCH_STATUS = 0
	begin
		set @tableName = (select Name from Tables where @tableID = TableID)

		--exec delete_table @noOfRows, @tableName

		declare @sql varchar(250) = 'delete from ' + @tableName
		print @sql
		
		--declare @deleteName varchar(250) = (select Name from Tests where @testID = TestID)
		declare @name varchar(100) = '%' + @tableName
		declare @deleteName varchar(250) = (select Name from Tests where Name like 'delete%' and Name like @name)


		exec(@deleteName) -- might not work bcs @testID ???? in tests??

		fetch next
		from testDeleteCursor
		into @tableID, @noOfRows
	end

	close testDeleteCursor
	deallocate testDeleteCursor

	-- insert tests

	declare testInsertCursor cursor
	for
	select TableID, NoOfRows
	from TestTables
	where TestID = @testID
	order by Position asc

	open testInsertCursor

	fetch next
	from testInsertCursor
	into @tableID, @noOfRows

	while @@FETCH_STATUS = 0
	begin
		set @tableName = (select Name from Tables where TableID = @tableID)

		set @startAt = getdate()
		--exec insert_table @noOfRows, @tableName

		print 'insert into ' + @tableName
		
		declare @nameInsert varchar(100) = '%' + @tableName
		declare @insertName varchar(250) = (select Name from Tests where Name like 'add%' and Name like @nameInsert)
		
		set @noOfRows = (select NoOfRows from TestTables where TableID = @tableID and TestID = @testID)

		exec @insertName @noOfRows
		
		set @endAt = getdate()

		insert into TestRunTables values (@testRunID, @tableID, @startAt, @endAt)

		fetch next
		from testInsertCursor
		into @tableID, @noOfRows
	end

	close testInsertCursor
	deallocate testInsertCursor

	-- view tests

	declare testViewCursor cursor
	for 
	select ViewID
	from TestViews
	where @testID = TestID

	open testViewCursor

	fetch next
	from testViewCursor
	into @viewID

	while @@FETCH_STATUS = 0
	begin
		set @viewName = (select Name from Views where ViewID = @viewID)

		set @startAt = getdate()
		print 'view name' + @viewName
		exec selectView @viewName
		set @endAt = getdate()

		insert into TestRunViews values (@testRunID, @viewID, @startAt, @endAt)

		fetch next
		from testViewCursor
		into @viewID
	end

	close testViewCursor
	deallocate testViewCursor

	update TestRuns
	set EndAt = getdate()
	where TestRunID = @testRunID

end
go

delete from TestRunTables where TestRunID in (1, 2)
delete from TestRuns where TestRunID in (1, 2)

exec mainTest 1
exec mainTest 2
exec mainTest 3
exec mainTest 4
exec mainTest 5
exec mainTest 6
exec mainTest 7


select * from TestRunTables
select * from TestRunViews
select * from TestRuns
