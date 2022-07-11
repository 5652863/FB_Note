SET TERM ^ ;

CREATE OR ALTER package PKTER_SHIPMENT
as
begin
  procedure GET_TASKCOUNT (
      IDDOCPLACE type of column DOCPLACE.ID)
  returns (
      TASKDONE int,
      TASKALL int);

  procedure SET_BOX_SHIPMENT (
      IDDOCPLACE type of column DOCPLACE.ID,
      SBARCODE type of column STOCKGRP.SBARCODE)
  returns (
      TASKDONE int,
      TASKALL int);
end^

RECREATE package body PKTER_SHIPMENT
as
begin
  procedure GET_TASKCOUNT (
      IDDOCPLACE type of column DOCPLACE.ID)
  returns (
      TASKDONE int,
      TASKALL int)
  as
  begin
    for select sum(iif(DPI.STATE_DOCPLACE = 50, 1, 0)),
               count(DPI.ID)
      from DOCPLACEITEM DPI
      where DPI.IDDOCPLACE = :IDDOCPLACE
      into :TASKDONE, :TASKALL
    do
      suspend;
  end
  procedure SET_BOX_SHIPMENT (
      IDDOCPLACE type of column DOCPLACE.ID,
      SBARCODE type of column STOCKGRP.SBARCODE)
  returns (
      TASKDONE int,
      TASKALL int)
  as
  declare variable IDSG type of column STOCKGRP.ID;
  declare variable IDDPI type of column DOCPLACEITEM.ID;
  declare variable ISTATE type of column DOCPLACEITEM.STATE_DOCPLACE;
  declare variable SNAME type of column STOCKGRP.SCAPTION;
  begin
    select SG.ID,
           SG.SCAPTION
    from STOCKGRP SG
    where SG.SBARCODE = :SBARCODE
    into :IDSG, :SNAME;

    if (IDSG is null) then
      exception E_ERROR('ШК [' || :SBARCODE || '] не найден');

    select DPI.ID,
           DPI.STATE_DOCPLACE
    from DOCPLACEITEM DPI
    where DPI.IDDOCPLACE = :IDDOCPLACE and
          DPI.DYTE = :IDSG
    into :IDDPI, :ISTATE;

    if (IDDPI is null) then
      exception E_ERROR(:SNAME || ' не найдено в текущем документе');

    if (ISTATE >= 50) then
      exception E_ERROR('Задание ' || PKENUM.GET_SNAMEOUTPUT(47, :ISTATE));

    --execute procedure PKDPUSR.SETSTATE_DOCPLACEITEM(:ISTATE, 50, 1, 0, 1);

    execute procedure GET_TASKCOUNT(:IDDOCPLACE)
        returning_values :TASKDONE, :TASKALL;

    suspend;

  end
end
^

SET TERM ; ^

/* Following GRANT statements are generated automatically */

GRANT SELECT ON DOCPLACEITEM TO PACKAGE PKTER_SHIPMENT;
GRANT USAGE ON EXCEPTION E_ERROR TO PACKAGE PKTER_SHIPMENT;
GRANT EXECUTE ON PACKAGE PKENUM TO PACKAGE PKTER_SHIPMENT;
GRANT SELECT ON STOCKGRP TO PACKAGE PKTER_SHIPMENT;

/* Existing privileges on this package */

GRANT EXECUTE ON PACKAGE PKTER_SHIPMENT TO SYSDBA;