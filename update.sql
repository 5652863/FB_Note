
insert into ENUMVALUE (IDENUM, IVALUE, SNAME, SCODEDEVELOP, BSIGNIFICANT, SHELP, SNAME_USR,
                       SNAME_SHORT)
values (127, 11,
        'Выставляет событие контроль отгрузки',
        'PKEVENT.ex_docgrp_stockgrpch_11', 1, null, null,
        'Контроль отгрузки');
		
update ALG_STORAGEEVENT
set ITYPEEVENT = 7,
    ITYPEHANDLEREVENT = 1
where (ID = 11);

insert into ENUMVALUE (IDENUM, IVALUE, SNAME, SCODEDEVELOP, BSIGNIFICANT, SHELP, SNAME_USR,
                       SNAME_SHORT)
values (157, 11, 'Контроль отгрузки', null, 1, null, null, null);

update TYPEDOCPLACE
set ISCENARIO_TER = 11
where (ID = 28);		