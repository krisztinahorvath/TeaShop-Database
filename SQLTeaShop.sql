--create database TeaShop
--go

use TeaShop
go

create table TeaTypes (
	ttid int primary key identity,
	name varchar(40) not null
)

create table Allergens(
	alid int primary key identity,
	name varchar(40) not null
)

create table Teas (
	tid int primary key identity,
	ttid int foreign key references TeaTypes(ttid),
	alid int foreign key references Allergens(alid),
	name varchar(40) not null,
	quantity int default 1,
	price float not null
)

create table AllergTeas (
	tid int foreign key references Teas(tid),
	alid int foreign key references Allergens(alid),
	constraint pf_AllergTeas primary key(tid,alid)
)

create table Distributors (
	did int primary key identity,
	tid int foreign key references Teas(tid),
	name varchar(40) not null,
	address varchar(40),
	quantity int default 1
	-- constraint ???
)

create table Clients (
	cid int primary key identity,
	name varchar(40) not null,
	email varchar(40) not null,
	address varchar(40) not null
)

create table Employees (
	eid int primary key identity,
	name varchar(40) not null,
	jobTitle varchar(40) not null
)

create table EmployeeDetails (
	eid int foreign key references Employees(eid),
	email varchar(40) not null,
	salary float not null,
	address varchar(40),
	hiringDate date not null,
	constraint pk_EmployeeDetails primary key(eid)
)

create table Orders (
	oid int primary key identity,
	eid int foreign key references Employees(eid),
	cid int foreign key references Clients(cid)
)

create table TeaOrders (
	tid int foreign key references Teas(tid),
	oid int foreign key references Orders(oid),
	constraint pk_TeaOrders primary key(oid, tid),
	price float not null,  -- here or in orders???
	quantity int default 1
)


--drop database TeaShop

