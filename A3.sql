use TeaShop

--a. modify the type of a column;
go 
create or alter procedure setSalaryFromEmployeeDetailsDecimal
as
	alter table EmployeeDetails alter column salary decimal(4,2)


go 
create or alter procedure setSalaryFromEmployeeDetailsInt
as
	alter table EmployeeDetails alter column salary float not null



--b. add / remove a column;
go 
create or alter procedure addPhoneNumberToEmployeeDetails
as 
	alter table EmployeeDetails add phone_number varchar(20)


go create or alter procedure removePhoneNumberFromEmployeeDetails
as 
	alter table EmployeeDetails drop column phone_number



--c. add / remove a DEFAULT constraint;
go
create or alter procedure addDefaultToPriceFromTeas
as 
	alter table Teas add constraint default_price default(1) for price


go 
create or alter procedure removeDefaultFromPriceFromTeas
as 
	alter table Teas drop constraint default_price


--d. add / remove a primary key;
go 
create or alter procedure addEmailPKEmployeeDetails
as
	alter table EmployeeDetails
		drop constraint pk_EmployeeDetails 
	alter table EmployeeDetails
		add constraint pk_EmployeeDetails primary key (eid, email)


go
create or alter procedure removeEmailPKEmployeeDetails
as
	alter table EmployeeDetails
		drop constraint pk_EmployeeDetails
	alter table EmployeeDetails
		add constraint pk_EmployeeDetails primary key (eid)


--e. add / remove a candidate key;
go
create or alter procedure newCandidateKeyTeas
as 
	alter table Teas
		add constraint teas_candidate_key unique (ttid, name, did)


go 
create or alter procedure removeCandidateKeyTeas
as
	alter table Teas
		drop constraint teas_candidate_key

--f. add / remove a foreign key;
go
create or alter procedure newForeignKeyGiftCard
as 
	alter table GiftCard
		add constraint gift_card_foreign_key foreign key(cid) references Clients(cid)


go 
create or alter procedure removeForeignKeyGiftCard
as
	alter table GiftCard
		drop constraint gift_card_foreign_key

--g. create / drop a table.
go
create or alter procedure addGiftCard
as 
	create table GiftCard(
			gcid int primary key,
			client_name varchar(40),
			expiryDate date, 
			nrOfPoints int
	)

go
create or alter procedure removeGiftCard
as 
	drop table GiftCard



--Create a new table that holds the current version of the database schema. 
--Simplifying assumption: the version is an integer number.

go
create table versionTable (
	version int
)

insert into versionTable
values 
	(1) -- initial version


--procedures table with all the procedures and their inital/final version
create table proceduresTable (
	initial_version int, 
	final_version int, 
	procedure_name varchar(70),
	primary key (initial_version, final_version)
)

insert into proceduresTable
values
	(1, 2, 'setSalaryFromEmployeeDetailsDecimal'),
	(2, 1, 'setSalaryFromEmployeeDetailsInt'),
	(2, 3, 'addPhoneNumberToEmployeeDetails'),
	(3, 2, 'removePhoneNumberFromEmployeeDetails'),
	(3, 4, 'addDefaultToPriceFromTeas'),
	(4, 3, 'removeDefaultFromPriceFromTeas'),
	(4, 5, 'addEmailPKEmployeeDetails'),
	(5, 4, 'removeEmailPKEmployeeDetails'),
	(5, 6, 'newCandidateKeyTeas'),
	(6, 5, 'removeCandidateKeyTeas'),
	(6, 7, 'newForeignKeyGiftCard'),
	(7, 6, 'removeForeignKeyGiftCard'),
	(7, 8, 'addGiftCard'),
	(8, 7, 'removeGiftCard')



--Write a stored procedure that receives as a parameter a version number
--and brings the database to that version.
go 
create or alter procedure goToVersion(@newVersion int)
as
	declare @currentVersion int
	declare @procedureName varchar(70)
	select @currentVersion = version from versionTable

	if (@newVersion > (select max(final_version) from proceduresTable) or @newVersion < 1)
		RAISERROR ('incorrect version', 10, 1)

	else 
	begin
		if @newVersion = @currentVersion
			print('The database is already in this version');
		else
		begin
			if @currentVersion > @newVersion
			begin
				while @currentVersion > @newVersion
				begin
					select @procedureName = procedure_name from proceduresTable where initial_version = @currentVersion AND final_version = @currentVersion-1
					print('executing' + @procedureName);
					exec (@procedureName)
					set @currentVersion = @currentVersion - 1
				end
			end

			if @currentVersion < @newVersion
			begin
				while @currentVersion < @newVersion
				begin
					select @procedureName =  procedure_name FROM proceduresTable WHERE initial_version = @currentVersion AND final_version = @currentVersion + 1
					print('executing' + @procedureName);
					exec (@procedureName)
					set @currentVersion = @currentVersion + 1
				end
			end

			update versionTable set version = @newVersion
		end
	end


exec goToVersion 1

select * from versionTable

select * from proceduresTable
