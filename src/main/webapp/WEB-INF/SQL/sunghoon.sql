CREATE table tbl_document
(documentNo         NVARCHAR2(20)           not null
,fk_employeeNo       number                  not null
,subject            NVARCHAR2(200)          not null
,draftDate          date    default sysdate not null
,status             number  default 0       not null
,securityLevel      number  default 0
,temp               number  default 0
,documentType       NVARCHAR2(20)           not null
,constraint     PK_tbl_document primary key(documentNo)
,constraint     fk_tbl_document_employeeNo foreign key(fk_employeeNo) references tbl_employee(employeeNo) on delete cascade
);

create sequence seq_document
start with 100001
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- drop sequence seq_document;


CREATE table tbl_document_attach
(documentAttachNo   number          not null
,fk_documentNo      NVARCHAR2(20)   not null
,fileName           Nvarchar2(200)  not null
,orgFilename        Nvarchar2(200)  not null
,fileSize           number          not null
,constraint PK_tbl_document_attach primary key(documentAttachNo)
,constraint fk_doc_attach_documentNo foreign key(fk_documentNo) references tbl_document(documentNo) on delete cascade
);
-- Table TBL_DOCUMENT_ATTACH이(가) 생성되었습니다.

CREATE table tbl_approval
(approvalNo     number          not null
,fk_documentNo  NVARCHAR2(20)   not null
,fk_approver    number          not null
,approvalOrder  number          not null
,approvalStatus number          not null
,executionDate  date            default sysdate
,constraint PK_tbl_approval_approvalNo primary key(approvalNo)
,constraint fk_tbl_approval_documentNo foreign key(fk_documentNo) references tbl_document(documentNo) on delete cascade
,constraint fk_tbl_approval_approver foreign key(fk_approver) references tbl_employee(employeeNo) on delete cascade
);
-- Table TBL_APPROVAL이(가) 생성되었습니다.

create sequence seq_approval
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

CREATE table tbl_draft_annual
(documentNo     NVARCHAR2(20)   not null
,useAmount      number          not null
,reason         NVARCHAR2(200)  not null
,startDate      Date            not null
,endDate        Date            not null
,annualtype     number          not null
,constraint PK_tbl_draft_annual_documentNo primary key(documentNo)
,constraint FK_tbl_draft_annual_documentNo foreign key(documentNo) references tbl_document(documentNo) on delete cascade
);
-- Table TBL_DRAFT_ANNUAL이(가) 생성되었습니다.

CREATE table tbl_draft_business
(documentNo     NVARCHAR2(20)   not null
,doDate         Date            not null
,content        NVARCHAR2(200)  not null   
,coDepartment   NVARCHAR2(20)
,constraint PK_draft_business_documentNo primary key(documentNo)
,constraint FK_draft_business_documentNo foreign key(documentNo) references tbl_document(documentNo) on delete cascade
);
-- Table TBL_DRAFT_BUSINESS이(가) 생성되었습니다.

CREATE table tbl_draft_expense
(documentNo     NVARCHAR2(20)   not null
,writeDate      Date            not null
,reason         NVARCHAR2(200)  not null   
,totalAmount    number          not null
,department     NVARCHAR2(20)   not null
,constraint PK_draft_expense_documentNo primary key(documentNo)
,constraint FK_draft_expense_documentNo foreign key(documentNo) references tbl_document(documentNo) on delete cascade
);
-- Table TBL_DRAFT_EXPENSE이(가) 생성되었습니다.

CREATE table tbl_draft_overtime
(documentNo     NVARCHAR2(20)   not null
,reason         NVARCHAR2(200)  not null   
,constraint PK_draft_overtime_documentNo primary key(documentNo)
,constraint FK_draft_overtime_documentNo foreign key(documentNo) references tbl_document(documentNo) on delete cascade
);
-- Table TBL_DRAFT_OVERTIME이(가) 생성되었습니다.

CREATE table tbl_expense_detail
(expenseDetailNo    number          not null
,fk_documentNo      NVARCHAR2(20)   not null
,amount             number          not null
,useDate            date            not null
,type               Nvarchar2(20)   not null
,content            Nvarchar2(100)  not null
,note               Nvarchar2(200)
,constraint PK_expense_detail_detailNo primary key(expenseDetailNo)
,constraint FK_expense_detail_documentNo foreign key(fk_documentNo) references tbl_draft_expense(documentNo) on delete cascade
);
-- Table TBL_EXPENSE_DETAIL이(가) 생성되었습니다.

create sequence seq_expensedetail
start with 100001
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


select * from tab;

select (Endtime - starttime)*24
from tbl_commute;

select *
from tbl_commute
where commuteno != 100010;

select employeeNo.nextval
from dual;

SELECT seq_document.nextval FROM DUAL;

insert into tbl_draft_annual(DOCUMENTNO, USEAMOUNT, REASON, STARTDATE, ENDDATE, ANNUALTYPE)
values(seq_document.currval, 1, 'dd', to_date('2025-02-17', 'yyyy-MM-dd'), to_date('2025-02-18', 'yyyy-MM-dd' ), '연차');

select * from tbl_document;
select * from tbl_draft_annual;

select *
from tbl_document;

select documentNo, subject, documentType, draftDate
		from tbl_document
		where fk_employeeNo = 100014 and temp = 1;
    
    
    
    
select documentNo, subject, documentType, draftDate, status
from tbl_document;

select documentNo, subject, documentType, draftDate, status, name
from
(
    select employeeNo, name
    from
        (
            select fk_departmentno
            from tbl_employee
            where employeeNo = '100014'
        ) E1 JOIN tbl_employee E2
    ON E1.fk_departmentNo = E2.fk_departmentno
) E JOIN tbl_document D
ON E.employeeNO = D.fk_employeeNo;



select *
from tbl_document
where fk_employeeno = '100014';

SELECT *
  FROM all_sequences;


select *
from tbl_document D JOIN tbl_draft_annual A
ON d.documentNo = A.documentNo;

select d.documentNo, d.fk_employeeNo, subject, draftDate, status, securityLevel, temp, documentType, approvalDate
     , useAmount, reason, startDate, endDate, annualType
from tbl_document D JOIN tbl_draft_annual A
ON d.documentNo = A.documentNo JOIN tbl_employee E
ON d.fk_employeeNo = E.employeeNo
where d.documentNo = '2025-100002';

select d.documentNo, fk_employeeNo, subject, to_char(draftDate, 'yyyy-mm-dd') as draftDate, status, securityLevel, temp, documentType, to_char(approvalDate, 'yyyy-mm-dd') as approvalDate
     , useAmount, reason, to_char(startDate, 'yyyy-mm-dd') as startDate, to_char(endDate, 'yyyy-mm-dd') as endDate, annualType
from tbl_document D JOIN tbl_draft_annual A
ON d.documentNo = A.documentNo
where d.documentNo = '2025-100002';

select approvalNo, fk_documentNo, fk_approver, approvalOrder, approvalStatus
     , to_char(executionDate, 'yyyy-mm-dd') as executionDate, positionname, name
from tbl_approval JOIN tbl_employee
ON fk_approver = employeeNo JOIN tbl_position
ON fk_positionno = positionno
where fk_documentNo = '2025-100032'
order by approvalOrder desc;


select *
from tbl_document D JOIN tbl_draft_annual A
ON d.documentNo = A.documentNo;

select d.documentNo, d.fk_employeeNo, subject, draftDate, d.status, e.securityLevel, temp, documentType, approvalDate
     , useAmount, reason, startDate, endDate, annualType, name, teamname
from tbl_document D JOIN tbl_draft_annual A
ON d.documentNo = A.documentNo JOIN tbl_employee E
ON d.fk_employeeNo = E.employeeNo JOIN tbl_team T
ON E.fk_teamNo = T.teamno
where d.documentNo = '2025-100002';



select *
from tbl_approval
where fk_approver = '100014';


select approvalNo, fk_approver, fk_documentNo, approvalOrder, fk_employeeNo, subject, draftDate, documentType, name, documentNo
from
(
    select approvalNo, fk_approver, fk_documentNo, approvalOrder, ROW_NUMBER() OVER(PARTITION BY fk_documentNo ORDER BY approvalOrder DESC) AS rn
    from tbl_approval
    where APPROVALSTATUS = 0
) A JOIN tbl_document
ON fk_documentNo = documentNo
JOIN tbl_employee
ON fk_employeeNo = employeeNo
where rn = 1 and fk_approver = '100014' and temp = 0;


select approvalNo, fk_approver, fk_documentNo, approvalOrder, FK_EMPLOYEENO, SUBJECT, DRAFTDATE, TEMP
from
(
    select approvalNo, fk_approver, fk_documentNo, approvalOrder, ROW_NUMBER() OVER(PARTITION BY fk_documentNo ORDER BY approvalOrder DESC) AS rn
    from tbl_approval
    where APPROVALSTATUS = 0
) A JOIN tbl_document
ON fk_documentNo = documentNo
where rn != 1 and fk_approver = '100014' and temp = 0;


select approvalNo, fk_approver, fk_documentNo, approvalOrder, fk_employeeNo, subject, draftDate, documentType, name, documentNo
from
(
    select approvalNo, fk_approver, fk_documentNo, approvalOrder, ROW_NUMBER() OVER(PARTITION BY fk_documentNo ORDER BY approvalOrder DESC) AS rn
    from tbl_approval
    where APPROVALSTATUS = 0
) A JOIN tbl_document
ON fk_documentNo = documentNo
JOIN tbl_employee
ON fk_employeeNo = employeeNo
where rn != 1 and fk_approver = '100014' and temp = 0;


select approvalNo, fk_approver, fk_documentNo, approvalOrder, fk_employeeNo, subject, draftDate, documentType, name, documentNo, approvalDate ,D.status
from
(
    select approvalNo, fk_approver, fk_documentNo, approvalOrder
    from tbl_approval
    where APPROVALSTATUS != 0 and fk_approver = '100014'
) A JOIN tbl_document D
ON fk_documentNo = documentNo
JOIN tbl_employee
ON fk_employeeNo = employeeNo
where temp = 0;


select documentNo, subject, documentType, draftDate, status
from
(
    select rownum AS rno, documentNo, subject, documentType, to_char(draftDate, 'yyyy-mm-dd') as draftDate, status
    from tbl_document
    where fk_employeeNo = '100014' and temp = 0
            and lower(subject) like '%'||lower('휴가')||'%'
    order by documentNo desc
)
WHERE rno BETWEEN 1 AND 10;

select teamNo, teamName, FK_departmentNo
		from tbl_team;
        
        
select * from tbl_document order by documentNo desc;
select * from tbl_draft_annual order by documentNo desc;

delete from tbl_document
where documentNo IN ('2025-100091', '2025-100090');

commit;

select occurannual, overannual, addannual, occurannual + overannual - addannual as total
from tbl_annual
where fk_employeeNo = '100014' and year = 2025;



select documentNo, subject, documentType, to_char(draftDate, 'yyyy-mm-dd') as draftDate, status
from
(
    select rownum as rn, documentNo, subject, documentType, draftDate, status
    from tbl_document
    where fk_employeeNo = '100014' and status = 0 and temp != 1
    order by documentNo desc
)
where rn BETWEEN 1 AND 5;

select fk_employeeNo, subject, draftDate, documentType, name, documentNo, positionname
from
(
    select rownum, fk_employeeNo, subject, to_char(draftDate, 'yyyy-mm-dd') as draftDate, documentType, name, documentNo, positionname
    from
    (
        select fk_approver, fk_documentNo, ROW_NUMBER() OVER(PARTITION BY fk_documentNo ORDER BY approvalOrder DESC) AS rn
        from tbl_approval
        where APPROVALSTATUS = 0
    ) A JOIN tbl_document D
    ON fk_documentNo = documentNo
    JOIN tbl_employee
    ON fk_employeeNo = employeeNo
    JOIN tbl_position
    ON fk_positionno = positionno
    where rn = 1 and fk_approver = '100020' and temp = 0 and D.status != 2
    order by documentNo desc
)
where rownum between 1 and 5;


select approvalNo, fk_approver, fk_documentNo, approvalOrder, fk_employeeNo, subject, to_char(draftDate, 'yyyy-mm-dd') as draftDate
     , documentType, documentNo, to_char(approvalDate, 'yyyy-mm-dd') as approvalDate ,D.status, urgent
from
(
    select approvalNo, fk_approver, fk_documentNo, approvalOrder
    from tbl_approval
    where APPROVALSTATUS != 0 and fk_approver = '100014'
) A JOIN tbl_document D
ON fk_documentNo = documentNo
where temp = 0;

insert into tbl_commute(commuteNo, FK_employeeNo, status, rest, overTimeYN, workdate, starttime, endtime)
values(commuteSeq.nextval, to_number('100014'), 1, 1, 0, to_date('2025-03-24', 'yyyy-mm-dd'), to_date('2025-03-24', 'yyyy-mm-dd'), to_date('2025-03-25', 'yyyy-mm-dd'));
commit;

select employeeNo, teamname, name, securityLevel, positionname
from tbl_employee JOIN tbl_team
ON FK_teamno = teamno
JOIN tbl_position
ON FK_positionNo = positionno
where employeeNo = '100014';

insert into tbl_commute(commuteNo, FK_employeeNo, status, rest, overTimeYN, workdate, starttime, endtime)
values(commuteSeq.nextval, 100014, to_number('6'), 2, to_number('0'), '2025-03-28', to_date('2025-03-28', 'yyyy-mm-dd'), to_date('2025-03-28', 'yyyy-mm-dd'));
rollback;

select *
from tbl_commute
where status in (1,2,3) and fk_employeeNo = 100014 and workdate between '2025-03-28' and '2025-03-31';

update tbl_commute set overTimeYN = 0
where fk_employeeNo = '100014' and workdate = '2025-03-07';

commit;

select count(*)
from TBL_CALENDAR_SMALL_CATEGORY
where FK_LGCATGONO = 1 and SMCATGONAME = '휴가' and fk_employeeNo = '100020';

select SEQ_SMCATGONO.nextval
from dual;

insert into TBL_CALENDAR_SMALL_CATEGORY(SMCATGONO, FK_LGCATGONO, SMCATGONAME, FK_EMPLOYEENO)
values(seq_smcatgono.nextval, 1, '휴가', '100014');

commit;

select *
from TBL_CALENDAR_SCHEDULE;

insert into TBL_CALENDAR_SCHEDULE(SCHEDULENO, STARTDATE, ENDDATE, SUBJECT, COLOR, FK_SMCATGONO, FK_LGCATGONO, FK_EMPLOYEENO)
values(seq_scheduleno.nextval, #{starDate}, #{endDate}, '연차', '#009900', #{SMCATGONO}, 1, #{fk_employeeNo});


      select sum(useamount) as usedAnnual
      from tbl_document D join tbl_draft_annual A
      on D.DOCUMENTNO = A.DOCUMENTNO
      where fk_employeeno = to_number('100014')
      and to_char(startdate, 'yyyy') = '2025'
      and D.status = 1;
      group by to_char(startdate, 'yyyy');



        select occurannual + overannual - addannual - (
        
			select sum(useamount) as usedAnnual
			from tbl_document D join tbl_draft_annual A
			on D.DOCUMENTNO = A.DOCUMENTNO
			where fk_employeeno = to_number('100014')
			and to_char(startdate, 'yyyy') = '2025'
			and D.status = 1
			group by to_char(startdate, 'yyyy')	) as totalAmount
	
		from tbl_annual
		where fk_employeeNo = '100014' and year = '2025'
		
		UNION ALL
		
		select 0 AS totalAmount
		from dual
		where not exists
		(
			select occurannual + overannual - addannual as totalAmount
			from tbl_annual
			where fk_employeeNo = '100014' and year = '2025'
		);


update tbl_commute set overTimeYN = 1
where fk_employeeNo = to_number('100010') and workdate = '2025-03-17';

rollback;

select documentNo, subject, documentType, to_char(draftDate, 'yyyy-mm-dd') as draftDate, status, name
     , nvl(to_char(approvalDate, 'yyyy-mm-dd'), '-') as approvalDate, urgent
from
(
    select employeeNo, name, E1.fk_departmentno
    from
        (
            select fk_departmentno
            from tbl_employee
            where employeeNo = '111111'
        ) E1 JOIN tbl_employee E2
    ON E1.fk_departmentNo = E2.fk_departmentno
) E JOIN tbl_document D
ON E.employeeNO = D.fk_employeeNo
where temp = 0