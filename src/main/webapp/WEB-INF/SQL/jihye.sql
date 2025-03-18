

-- 오라클 계정 생성을 위해서는 SYS 또는 SYSTEM 으로 연결하여 작업을 해야 합니다. [SYS 시작] --
show user;
-- USER이(가) "SYS"입니다.

-- 오라클 계정 생성시 계정명 앞에 c## 붙이지 않고 생성하도록 하겠습니다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

-- 오라클 계정명은 FINAL_ORAUSER3 이고 암호는 gclass 인 사용자 계정을 생성합니다.
create user FINAL_ORAUSER3 identified by gclass default tablespace users; 
-- User FINAL_ORAUSER3이(가) 생성되었습니다.

-- 위에서 생성되어진 FINAL_ORAUSER3 이라는 오라클 일반사용자 계정에게 오라클 서버에 접속이 되어지고,
-- 테이블 생성 등등을 할 수 있도록 여러가지 권한을 부여해주겠습니다.
grant connect, resource, create view, unlimited tablespace to FINAL_ORAUSER3;
-- Grant을(를) 성공했습니다.


show user;
--USER이(가) "FINAL_ORAUSER3"입니다.

select *
from tbl_test;


insert into tbl_test (no,name)
values('1010','이지혜');

commit;
------------------------------------------------------------

-- 사원 테이블
create table tbl_employee(
     employeeNo         number(6)                not null,   -- 사번
     FK_positionNo      number(2)                not null,   -- 직급번호
     FK_teamSeq         number(4)                not null,   -- 팀번호
     passwd             varchar2(16)             not null,   -- 비밀번호
     name               Nvarchar2(6)             not null,   -- 이름
     securityLevlel     number(2) default 1      not null,   -- 보안등급
     email              varchar2(30)             not null,   -- 이메일
     mobile             varchar2(20)             not null,   -- 전화번호
     directCall         varchar2(20)             not null,   -- 내선번호
     bank               Nvarchar2(20)            not null,   -- 은행  
     account            varchar2(25)               not null,   -- 계좌번호
     maritalStatus      number(1) default 1          null,   -- 결혼유무(0: 결혼, 1: 미혼)
     disability         number(1) default 1          null,   -- 장애여부(0: y, 1: n)
     employmentType     number(1) default 0      not null,   -- 채용구분(0: 신입, 1: 경력)
     registerDate       date  default sysdate    not null,   -- 입사일
     salary             number(10)               not null,   -- 기본급
     status             number(1)  default 1     not null,   -- 재직상태(1: 재직)
     lastDate           date                         null,   -- 퇴직일
     reasonForLeaving   varchar2(200)                null,   -- 퇴직사유
     constraint PK_tbl_employee_employeeNo primary key (employeeNo),
     constraint FK_tbl_employee_FK_positionNo foreign key (FK_positionNo) references tbl_position(positionNo),
     constraint FK_tbl_employee_FK_teamSeq foreign key (FK_teaeq) references tbl_team(teamSeq),
     constraint CK_tbl_employee_securityLevel check (securityLevel in (0,1,10)),
     constraint CK_tbl_employee_maritalStatus check (maritalStatus in (0,1)),
     constraint CK_tbl_employee_disability check (disability in (0,1)),
     constraint CK_tbl_employee_employmentType check (employmentType in (0,1)),
     constraint CK_tbl_employee_status check (status in (0,1))
 );
 
 
create sequence employeeNo 
start with 100001
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

select *
from tbl_employee
order by employeeNo desc;

select *
from tbl_position;

----------------------------------------
-- 직급 테이블
create table tbl_position(
    posiotionNo     number(2)        not null, --직급번호
    positionName    nvarchar2(10)    not null, --직급명
    constraint PK_tbl_position_positionNo primary key (positionNo)
);

create sequence posiotionNo  
start with 100001
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
----------------------------------------
-- 부서 테이블
create table tbl_department(
    departmentNo      number(4)     not null, -- 부서번호
    FK_managerNo      number(4)     not null, -- 부서장사번
    teamName          Nvarchar2(10) not null, -- 부서명
    constraint PK_tbl_department_departmentNo primary key (department),
    constraint FK_tbl_team_FK_managerNo foreign key (FK_managerNo) references tbl_employee(employeeNo)
);

create sequence departmentNo 
start with 100001
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

----------------------------------------
-- 팀 테이블
create table tbl_team(
    teamSeq         number(4)       not null, -- 팀번호
    FK_employeeNo   number(6)       not null, -- 팀장사번
    FK_departmentNo number(4)       not null, -- 부서번호
    teamName        Nvarchar2(20)   not null, -- 팀명
    constraint PK_tbl_team_teamSeq primary key (teamSeq),
    constraint FK_tbl_team_FK_employeeNo foreign key (FK_employeeNo) references tbl_employee(employeeNo),
    constraint FK_tbl_team_FK_departmentNo foreign key (FK_departmentNo) references tbl_department(departmentNo)
);

select * from tbl_team;


create sequence teamNo
start with 100001
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
----------------------------------------
-- 주소록 테이블
create  table tbl_addressBook(
    addressBookNo   number(6)       not null, -- 주소록고유번호
    FK_employeeNo   number(6)       not null, -- 사번
    firstName       nvarchar2(5)    not null, -- 성
    middleName      nvarchar2(10)       null, -- 중간이름
    lastName        nvarchar2(10)   not null, -- 이름(마지막 이름)
    company         nvarchar2(20)       null, -- 회사
    department      nvarchar2(20)       null, -- 부서
    rank            nvarchar2(20)       null, -- 직위
    email           varchar2(50)    not null, -- 이메일  
    phoneNo         number(15)          null, -- 휴대전화
    directCal       number(15)      not null, -- 내선번호
    companyAddress  varchar2(30)        null, -- 회사주소
    constraint PK_tbl_addressBook_addressBookNo primary key (addressBook),
    constraint FK_tbl_addressBook_employeeNo foreign key (FK_employeeNo) references tbl_employee(employeeNo)
);


create sequence ADRSBNO
start with 100001
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-----------------------------------------
-- 그룹 테이블
create table tbl_group(
    groupNo             number(4)       not null, -- 그룹번호
    FK_addressBookNo    number(6)       not null, -- 주소록고유번호
    groupName           varchar2(20)    not null, -- 그룹이름
    person              varchar2(2000)      null, -- 그룹원
    constraint PK_tbl_group_groupNo primary key (groupNo),
    constraint FK_tbl_group_FK_addressBookNo foreign key (FK_addressBookNo) references tbl_addressBook(addressBookNo)
);

create sequence groupNo 
start with 100001
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


commit;



----------------------------------------------------------------------------------------------------


ALTER TABLE tbl_employee
DROP CONSTRAINT FK_teamSeq;
commit;

select  * from tbl_employee;

-- 로그인 sql 문

--


select employeeNo, FK_positionNo, PASSWD,NAME, SECURITYLEVEL,email, mobile, directCal , bank, account, maritalstatus,
       disability,employmenttype,registerdate,salary,status,motive
from tbl_employee 
where employeeNo = 100011 and passwd = 'qwer1234$' and status = 1;

insert into tbl_employee(employeeNo, FK_positionNo,FK_teamNo, PASSWD, NAME, securityLevel,email, mobile, directCal , bank, account, maritalstatus,
                         disability,employmenttype,registerdate,salary,status,motive)
                 values(employeeNo.nextval,1,1,'qwer1234$','이지혜',10,'banana5092@naver.com',01099998888,2110001111,'농협',3010270414861,1,1,1,sysdate,30000000,1,'동기');
commit;
delete from tbl_employee where employeeNo = 100008;


alter table tbl_employee add profileImg varchar2(50);
commit;


alter table tbl_employee add birth date;
commit;

SELECT * FROM tbl_employee WHERE status = 1;



select * 
from  tbl_team;

desc tbl_team;
desc tbl_department;

alter table tbl_department rename column  TEAMNAME TO departmentname;
commit;

-- join X 로그인

select employeeNo, FK_positionNo, passwd, name, securitylevel, email, mobile, directcal, bank, account, maritalstatus,
 disability,employmenttype,registerdate,salary,status,motive
from tbl_employee
where employeeNo = 100011 and passwd = 'qwer1234$' and status = 1;



-- JOIN LOGIN
select employeeNo, FK_positionNo, PASSWD,NAME, SECURITYLEVEL,email, mobile, directCal , bank, account, maritalstatus,
       disability,employmenttype,registerdate,salary,status,motive,  
       T.fk_departmentno
from tbl_employee E left join tbl_team T
on E.fk_teamno = T.teamno
where employeeNo = 100011 and passwd = 'qwer1234$' and status = 1;


desc tbl_team;

ALTER TABLE tbl_team DROP foreign key FK_TBL_TEAM_FK_EMPLOYEENO;



alter table tbl_employee add constraint FK_positionNo foreign key(FK_positionNo) references tbl_position(posiotionNo);
commit;


desc tbl_employee;

select *
from tbl_employee;



desc tbl_department;


-- 로그인 쿼리
SELECT E.EMPLOYEENO, E.passwd, E.FK_POSITIONNO, E.FK_TEAMNO, E.Name, 
       E.SECURITYLEVEL, E.Email, E.Bank, E.Mobile, E.directcall, 
       E.account, E.registerdate, E.Status, E.REASONFORLEAVING, 
       E.lastDate, E.MOTIVE, E.PROFILEIMG, E.Address, E.birth, 
       E.FK_DEPARTMENTNO , D.departmentname
FROM tbl_employee E 
LEFT JOIN tbl_department D ON E.FK_DEPARTMENTNO = D.DEPARTMENTNO
WHERE E.employeeNo = 100011 
AND E.passwd = 'qwer1234$' 
AND E.status = 1;




SELECT E.EMPLOYEENO, E.passwd, E.FK_POSITIONNO, E.FK_TEAMNO, E.Name, 
       E.SECURITYLEVEL, E.Email, E.Bank, E.Mobile, E.directcall, 
       E.account, E.registerdate, E.Status, E.REASONFORLEAVING, 
       E.lastDate, E.MOTIVE, E.PROFILEIMG, E.Address, E.birth, 
       E.FK_DEPARTMENTNO , D.departmentname
FROM tbl_employee E 
LEFT JOIN tbl_department D ON E.FK_DEPARTMENTNO = D.DEPARTMENTNO
order by E.employeeNO desc;


commit;



--  관리자의 사원 추가 ----------------------------

insert into tbl_employee(EMPLOYEENO,passwd,name,FK_DEPARTMENTNO,FK_POSITIONNO,FK_TEAMNO,directcall,SECURITYLEVEL,email,Mobile,bank,account,registerdate,address,birth)
                  values(100015,'qwer1234','테스트',100000,100000,100000, 10212129090,1,'testacount@naver.com',01023239090,'농협', 1231234123412,sysdate, '충남','2002-08-08');


rollback;



--  샘 시작 ---
select departmentno, departmentname
from tbl_department
order by departmentno asc;
--  샘 끝 ---


select *
from tbl_employee;

-- 직급
select * 
from tbl_position;

desc tbl_position;

insert into tbl_position(posiotionno, positionname, salary) values(100001, '사원', 30000000);
insert into tbl_position(posiotionno, positionname, salary) values(100002, '대리', 40000000);
insert into tbl_position(posiotionno, positionname, salary) values(100003, '과장', 50000000);
insert into tbl_position(posiotionno, positionname, salary) values(100004, '차장', 70000000);
insert into tbl_position(posiotionno, positionname, salary) values(100005, '부장', 80000000);
insert into tbl_position(posiotionno, positionname, salary) values(100006, '상무', 100000000);
insert into tbl_position(posiotionno, positionname, salary) values(100007, '전무', 150000000);
insert into tbl_position(posiotionno, positionname, salary) values(100008, '사장', 200000000);

commit;

select positionno, positionname
from tbl_position
order by positionno asc;

select departmentno, departmentname
from tbl_department
order by departmentno asc;

update tbl_team set teamname='국내영업팀'
where teamno = 100003;

select *
from tbl_team ;


insert into tbl_team(teamno,fk_departmentno, teamname) values(100001,100003,'총무팀');

insert into tbl_team(teamno,fk_departmentno, teamname) values(100002,100002,'해외영업팀');
insert into tbl_team(teamno,fk_departmentno, teamname) values(100003,100002,'국내영업팀');
insert into tbl_team(teamno,fk_departmentno, teamname) values(100004,100002,'고객관리팀');

insert into tbl_team(teamno,fk_departmentno, teamname) values(100005,100004,'운송파트');
insert into tbl_team(teamno,fk_departmentno, teamname) values(100006,100004,'자재파트');

insert into tbl_team(teamno,fk_departmentno, teamname) values(100007,100005,'인사팀');
insert into tbl_team(teamno,fk_departmentno, teamname) values(100008,100005,'경리팀');

delete from tbl_team where teamname = '생산2팀';

commit;

select teamno, teamname, fk_departmentno
from tbl_team ;
 

    


select teamno, teamname
from tbl_team
order by teamno asc;



select *
from tbl_employee
order by employeeno desc;

update tbl_employee set address = '충청남도 천안시 서북구 와촌 3길 5', mobile='010-2070-6651'
where employeeNo = 100011;


update tbl_employee set email='banana5092@naver.com', mobile='01020706651', directCall='0289891212', birth = to_date(20020807,'yyyy-mm-dd') ,
 							address = '충청남도 천안시 서북구', motive='월급루팡'
	where employeeNo = 100011;

rollback;






----- 팀번호 알아오기 1
select T.teamNo, T.teamName
from tbl_department D LEFT JOIN tbl_team T
ON D.departmentNo = T.fk_departmentNo
where D.departmentNo = 100002;



----- 팀번호 알아오기 2
-- 영업부
select teamNo, teamName
from tbl_team
where fk_departmentNo = to_number('100004')
order by teamNo asc;

desc tbl_employee;

-- employeeNo,passwd,name,FK_departmentNo,FK_positionNo,FK_teamNo,directcall,securityLevel,email,mobile,bank,account,registerdate,address,birth


select * from tbl_employee order by employeeNo desc;
select * from tbl_department order by departmentNo desc;
select * from tbl_addressbook order  by ADRSBNO desc;
select * from tbl_position order  by positionNO desc;


desc tbl_employee ;

select * from tbl_addressbook;

insert into tbl_addressbook(ADRSBNO,FK_EMPLOYEENO,FIRSTNAME,LASTNAME,COMPANY,EMAIL,DIRECTCAL)
                     values(100000,100011,'김','봉춘','주식회사','kim@gmail.com','0432120909');
                     
commit;
rollback;

ALTER table tbl_addressbook modify DIRECTCAL VARCHAR2(20);


insert into tbl_addressbook(ADRSBNO,FK_EMPLOYEENO,FIRSTNAME ,MIDDLENAME,LASTNAME,COMPANY,DEPARTMENT,RANK,EMAIL,PHONENO,DIRECTCAL,COMPANYADRS,PROFILEIMG)
values(ADRSBNO.nextval,100011,'김',' ','봉춘','주식회사','영업부','부장','bamu6651@gmail.com','01020706651','04178129878','충청남도 천안',' ');

insert into tbl_addressbook(ADRSBNO,fk_employeeNo,firstName ,middleName,lastName,company,department,rank,email,phoneNo,directCal,COMPANYADRS)
	               values(ADRSBNO.nextval,100011,'김','봉','춘', '주식회사','영업부','부장','bamu6651@gmail.com','01020706651','04178129878','충청남도 천안');



insert into tbl_addressbook(ADRSBNO,fk_employeeNo,firstName ,middleName,lastName,company,department,rank,email,phoneNo,directCal,COMPANYADRS)
                     values(ADRSBNO.nextval,100011,'곽','두','팔','주식회사','영업부','사원','banana5092@naver.com','01020706651','04178129878','충청남도 천안');


desc tbl_addressbook ;


--상세 보기 일 때 
select FIRSTNAME||MIDDLENAME||LASTNAME AS name,
       COMPANY,DEPARTMENT,RANK,EMAIL,PHONENO,DIRECTCAL,COMPANYADRS
from tbl_addressbook
where fk_employeeNo=100011 and ADRSBNO = 100005
order by ADRSBNO desc;


-- 전체 주소록
select ADRSBNO,FIRSTNAME||MIDDLENAME||LASTNAME AS name,
       COMPANY,DEPARTMENT,RANK,EMAIL,PHONENO,DIRECTCALL
from tbl_addressbook
where fk_employeeNo=111111 
order by ADRSBNO desc;


-- 부서 주소록
select FIRSTNAME||MIDDLENAME||LASTNAME AS name,
       COMPANY,DEPARTMENT,RANK,EMAIL,PHONENO,DIRECTCALL
from tbl_addressbook
where fk_employeeNo=100011 and DEPARTMENT='영업부' 
order by DEPARTMENT, ADRSBNO desc;


	select FIRSTNAME||MIDDLENAME||LASTNAME AS name,
		       COMPANY,DEPARTMENT,RANK,EMAIL,PHONENO,DIRECTCALL
		from tbl_addressbook
		where fk_employeeNo=111111 and COMPANY='flow up'
		order by DEPARTMENT, ADRSBNO desc;


select FIRSTNAME||MIDDLENAME||LASTNAME AS name,
       COMPANY,DEPARTMENT,RANK,EMAIL,PHONENO,DIRECTCALL
from tbl_addressbook
where fk_employeeNo=111111 and COMPANY !='flow up'
order by DEPARTMENT, ADRSBNO desc;


--- 부서주소록
select department
from tbl_addressBook
group by department
order by DEPARTMENT;
--
select department
from tbl_addressBook
where COMPANY ='flow up'
group by department
order by DEPARTMENT asc;

select * 
from tbl_addressBook
where fk_employeeno = 111111;

select directcall
from tbl_employee
where employeeno=100011;


update tbl_addressBook set directcall = '0289891212'
where adrsbno=100008;
commit;

-- 삭제 쿼리
delete from tbl_addressBook where adrsbno=100008;

rollback;


--

WITH A AS (
    SELECT E.name, E.employeeno, P.positionname
    FROM tbl_employee E 
    JOIN tbl_position P ON E.FK_positionno = P.positionno
    ORDER BY E.employeeno DESC
),
B AS (
    SELECT E.employeeno, D.departmentno, D.departmentname
    FROM tbl_department D 
    JOIN tbl_employee E ON E.FK_departmentno = D.departmentno
),
C AS (
    SELECT T.Teamname, D.departmentno
    FROM tbl_team T 
    JOIN tbl_department D ON T.Fk_departmentno = D.departmentno
)
SELECT A.name, A.employeeno, A.positionname, 
       B.departmentname, 
       C.Teamname
FROM A
JOIN B ON A.employeeno = B.employeeno 
JOIN C ON B.departmentno = C.departmentno
ORDER BY A.employeeno DESC;  




---- 주소록 삭제 쿼리 
delete from tbl_addressbook where fk_employeeno =111111 and adrsbno=100019;
rollback;
commit;

select *
from tbl_employee
order by employeeno desc;

select * 
from tbl_addressbook;

select*
from tbl_team;

-- 주소록 상세보기
select FIRSTNAME||MIDDLENAME||LASTNAME AS name,
       COMPANY,DEPARTMENT,RANK,EMAIL,PHONENO,DIRECTCALL, CompanyAdrs
from tbl_addressbook
where fk_employeeno = 111111
order by adrsbno desc;




select * from tbl_department;

With A AS (
select E.name, D.departmentname, E.employeeno,D.departmentno
from tbl_employee E join tbl_department D
on E.fk_departmentno = D.departmentno
),
B AS(
select P.positionname, E.employeeno
from tbl_employee E join tbl_position P
on E.fk_positionno = P.positionno

),
C AS(
select T.teamname, E.employeeno, T.teamno
from tbl_employee E join tbl_team T
on E.fk_teamno = T.teamno
)
select A.name as name, A.employeeno as employeeno, A.departmentname as departmentname,
       B.positionname as positionname, C.teamname as teamname, A.departmentno as departmentno, C.teamno as teamno
From A JOIN 
    B ON A.employeeno = B.employeeno JOIN
    C ON B.employeeno = C.employeeno
ORDER BY A.employeeno desc;






select to_char(positionno)
from tbl_position
where positionname = '부장';

select to_char(departmentno)
from tbl_department
where departmentname = '총무부';

select to_char(teamno)
from tbl_team
where teamname = '총무팀';

select *
from tbl_employee;

select *
from tbl_team;

select teamno
from tbl_team
where teamname = '해외영업팀';


alter table tbl_employee add fileSize varchar2(255);
commit;
alter table tbl_employee add fileName varchar2(255);
commit;




SELECT E.EMPLOYEENO, E.passwd, E.FK_POSITIONNO, E.FK_TEAMNO, E.Name, 
	           E.SECURITYLEVEL, E.Email, E.Bank, substr(E.Mobile, 1, 3) || '-' || substr(E.Mobile, 4, 4) || '-' || substr(E.Mobile, 8) AS Mobile, 
	           substr(E.directcall, 1, 2) || ')' || substr(E.directcall, 3, 4) || '-' || substr(E.directcall, 7) AS directcall, 
	           E.account, to_char(E.registerdate, 'yyyy-mm-dd') AS registerdate, E.Status, E.REASONFORLEAVING, 
	           E.lastDate, E.MOTIVE, E.FILENAME, E.Address, to_char(E.birth, 'yyyy-mm-dd') AS birth,
	           E.FK_DEPARTMENTNO , D.departmentname
	    FROM tbl_employee E LEFT JOIN tbl_department D 
	    ON E.FK_DEPARTMENTNO = D.DEPARTMENTNO
	    WHERE E.employeeNo = 111111
	    AND E.passwd = #{passwd}
	    AND E.status = 1;







select *
from tbl_addressbook A join  tbl_group G
on A.ADRSBNO = G.fk_ADRSBNO;

select * from tbl_addressbook;

insert into tbl_group(GROUPNO,FK_ADRSBNO,GROUPNAME)
values(100000,111111,'그룹은');


ALTER TABLE tbl_group 
RENAME COLUMN FK_ADRSBNO TO FK_EMPLOYEENO;
commit;

rollback;

select *
from tbl_group;

insert into tbl_group(groupno,fk_employeeno,GROUPNAME)
values(groupno.nextval,111111,'우리회사');

rollback;

select *
from tbl_group ;

select groupNo, groupName
from tbl_group 
where fk_employeeno = 111111
order by groupno asc;

delete tbl_group where groupno = 100004;
commit;

select groupNo, groupName
from tbl_group
where fk_employeeno  = 111111 and groupNo=100002;

select *
from tbl_addressbook
where fk_employeeno = 111111;


SELECT B.groupNo, B.groupname
FROM tbl_addressbook A
JOIN tbl_group B
  ON A.fk_employeeno = B.fk_employeeno
WHERE A.fk_employeeno = 111111
  AND A.adrsbno = 100039
  AND B.groupNo = 100002;

select *
from tbl_employee
order by employeeno desc;


select * from tbl_team;
select * from tbl_department;

select * from tbl_group;
