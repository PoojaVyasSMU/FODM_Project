/*create tables*/

CREATE TABLE `software_product` (`build_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `version` VARCHAR(45) NOT NULL,
  `product_status` VARCHAR(45) NULL,
  PRIMARY KEY (`name`, `version`));
  
 CREATE TABLE `proj2`.`build` (
  `build_id` INT NULL,
  `comp_id` INT NULL);
  

 create table Component(component_id int primary key, component_name varchar(30), version char(3), size int, 
                       language enum('C', 'C++','C#','Java','PHP'), owner_id int, foreign key(owner_id) 
                       references person(person_id) ,cstatus varchar(30));

  
  create table person(person_id int primary key,name varchar(30), hire_date date,
  manager int,seniority varchar(45));
  
  create table inspection(inspection_id int, inspection_date date,
	constraint u unique(pid,cid,inspection_date), description varchar(4000), score int,
                        pid int, foreign key(pid) references person(person_id),cid int,
                        foreign key (cid) references Component(component_id),status varchar(30));
                        
  
  drop table person;
  
  
  /* ensure range of PID*/
  delimiter $$    
create trigger id_checkrange before insert on person
for each row
begin
	if (new.person_id>9999 or new.person_id<99999) then
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'person_id should be 5 digit number';
	end if;
end;
$$
drop trigger prange;

/*ensure manager not null*/
delimiter $$
create trigger check_manager before insert on person
for each row
Begin
	if new.person_id != '10100' then
		if new.manager is Null then
			SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = 'manager is required';
		end if;
	end if;
end;
$$


/*status on basis of score*/
delimiter $$
create trigger calculate_status before insert on inspection
for each row
begin
if (new.score>=90) then
	set new.status = 'Ready';
    update component set component.cstatus = 'Ready'
			where component.component_id=new.cid;
	 update build set build.status = 'Ready'
			where build.comp_id=new.cid;
end if;
if (new.score<=75) then
	set new.status = 'Not ready';
    update component set component.cstatus = 'Not ready'
			where component.component_id=new.cid;
	update build set build.status = 'Not Ready'
			where build.comp_id=new.cid;
end if;
if (new.score>75 and new.score<90) then
	set new.status = 'quite ready';
    update component set component.cstatus = 'Quite ready'
			where component.component_id=new.cid;
	 update build set build.status = 'Quite Ready'
			where build.comp_id=new.cid;
end if;
end;
$$

select * from component
/*status in component*/


/* insert data*/

insert into person (person_id,name,hire_date,manager) values (10100,'Employee-1','1984-11-08',10100);
insert into person (person_id,name,hire_date,manager) values (10200,'Employee-2','1994-11-08',10100);
insert into person (person_id,name,hire_date,manager) values (10300,'Employee-3','2004-11-08',10200);
insert into person (person_id,name,hire_date,manager) values (10400,'Employee-4','2008-11-01',10200);
insert into person (person_id,name,hire_date,manager) values (10500,'Employee-5','2015-11-01',10400);
insert into person (person_id,name,hire_date,manager) values (10600,'Employee-6','2015-11-01',10400);
insert into person (person_id,name,hire_date,manager) values (10700,'Employee-7','2016-11-01',10400);
insert into person (person_id,name,hire_date,manager) values (10800,'Employee-8','2017-11-01',10200);

select * from person;

/*create trigger for seniority which runs on update*/

delimiter $$
create trigger seniority_up before update on person
for each row
begin
if(timestampdiff(year,new.hire_date,curdate())<= 1) then
	set new.seniority='newbie';
end if;
if(timestampdiff(year,new.hire_date,curdate())> 1 and timestampdiff(year,new.hire_date,curdate())<5) then
	set new.seniority='junior';
end if;
if(timestampdiff(year,new.hire_date,curdate())> 5) then
	set new.seniority='senior';
end if;
end;
$$

/*run update to check latest seniority*/
update person set name=name; 
select * from person

/*status for product*/
delimiter $$
create trigger find_product_status after update on build
for each row
begin
update software_product set software_product.product_status = (select min(build.status) 
														from build
                                                        where build.build_id=software_product.build_id
                                                        group by build.build_id)
						where new.build_id=software_product.build_id;
end;
$$

drop trigger status_product;

update build set comp_id=comp_id;
select min(component.cstatus) from component 
                                             group by component.build_id
 select * from software_product
 drop trigger status_product 
insert into component 

insert into software_product (`build_id`,`name`,`version`,`product_status`) values (1,'Excel','2010','not ready')
insert into software_product (`build_id`,`name`,`version`,`product_status`) values (2,'Excel','2015','not ready')
insert into software_product (`build_id`,`name`,`version`,`product_status`) values (3,'Excel','2018beta','not ready')
insert into software_product (`build_id`,`name`,`version`,`product_status`) values (4,'Excel','secret','not ready')


select * from software_product;

insert into build(`build_id`,`comp_id`) values (1,1);
insert into build(`build_id`,`comp_id`) values (1,3);
insert into build(`build_id`,`comp_id`) values (2,1);
insert into build(`build_id`,`comp_id`) values (2,4);
insert into build(`build_id`,`comp_id`) values (2,6);
insert into build(`build_id`,`comp_id`) values (3,1);
insert into build(`build_id`,`comp_id`) values (3,2);
insert into build(`build_id`,`comp_id`) values (3,5);
insert into build(`build_id`,`comp_id`) values (1,1);
insert into build(`build_id`,`comp_id`) values (1,2);
insert into build(`build_id`,`comp_id`) values (1,5);
insert into build(`build_id`,`comp_id`) values (1,8);


select * from build;



select * from build;

insert into component (component_id,component_name, version , size, language, owner_id) 
                        values (1,'Keyboard Driver','K11',1200,'C',10100),
                               (2,'Touch Screen Driver','T00',4000,'C++',10100),
                               (3,'Dbase Interface','D00',2500,'C++',10200),
                               (4,'Dbase Interface','D01',2500,'C++',10300),
                               (5,'Chart generator','C11',6500,'java',10200),
                               (6,'Pen driver','P01',3575,'C',10700),
                               (7,'Math unit','A01',5000,'C',10200),
                               (8,'Math unit','A02',3500,'java',10200);
 select * from component;
 insert into inspection(inspection_id, inspection_date,pid,description,score,cid) 
			   values (1,'2010-02-14',10100,'legacy code which is already approve',100,1),
					  (2,'2017-06-01',10200,'initial release ready for usage',95,2),
                      (3,'2010-02-22',10100,'too many hard coded parameters, the software must be 
                      more maintainable and configurable because we want to use this in other products.',55,3),
                      (4,'2010-02-24',10100,'improved, but only handles DB2 format',78,3),
                      (5,'2010-02-26',10100,'Okay, handles DB3 format.',95,3),
                      (6,'2010-02-28',10100,'satisifed',100,3),
                      (7,'2011-05-01',10200,'Okay ready for use',100,4),
                      (8,'2017-07-15',10300,'Okay ready for beta testing',80,6),
                      (9,'2014-06-10',10100,'almost ready',90,7),
                      (10,'2014-06-15',10100,'Accuracy problems!',70,8),
                      (11,'2014-06-30',10100,'Okay problems fixed',100,8),
					  (12,'2016-11-02',10700,'re-review for new employee to gain experience in the process.',
                      100,8);

select * from software_product;

select * from build;



select * from component;


select * from inspection;

select * from person;


person


describe inspection;

describe person;


describe component;
describe build;
describe software_product;

