use TeaShop
go


create table Clients (
	cid int primary key identity,
	fidelityCardNo int unique,
	name varchar(40) not null,
	email varchar(40) not null,
	address varchar(60) not null
)

create table Employees (
	eid int primary key identity,
	points int,
	name varchar(40) not null,
	jobTitle varchar(40) not null
)

create table EmployeeDetails (
	eid int foreign key references Employees(eid) on delete cascade on update cascade not null,
	email varchar(40) not null,
	salary float not null,
	address varchar(60),
	hiringDate date not null,
	constraint pk_EmployeeDetails primary key(eid)
)
